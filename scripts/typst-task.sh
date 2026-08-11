#!/bin/sh
# Theme-aware Typst tasks for Zed (export | watch | preview).
#
# The theme comes from Zed's settings.json:
#   "lsp": { "tinymist": { "settings": { "preview": { "theme": "dark" } } } }
# with values dark | light | auto. Missing (or "auto") follows the macOS
# appearance. The key rides along in the tinymist LSP settings block, which
# is free-form JSON; tinymist itself ignores unknown keys.
#
# export/watch produce BOTH themes: <stem>.pdf in the current theme (the one
# the preview would use) and <stem>-light.pdf or <stem>-dark.pdf for the
# other one.
#
# preview: dark opens the background LSP preview (whose compiles carry the
# dark inputs from Zed's tinymist settings); light runs a standalone
# tinymist preview without dark inputs.

TINYMIST=/Users/tali/github/tinymist/target/release/tinymist

theme=$(python3 - <<'EOF'
import json, os, re

def strip_jsonc(s):
    out, i, n, instr = [], 0, len(s), False
    while i < n:
        c = s[i]
        if instr:
            out.append(c)
            if c == "\\" and i + 1 < n:
                out.append(s[i + 1])
                i += 2
                continue
            if c == '"':
                instr = False
            i += 1
            continue
        if c == '"':
            instr = True
            out.append(c)
            i += 1
            continue
        if c == "/" and i + 1 < n and s[i + 1] == "/":
            while i < n and s[i] != "\n":
                i += 1
            continue
        if c == "/" and i + 1 < n and s[i + 1] == "*":
            i += 2
            while i + 1 < n and not (s[i] == "*" and s[i + 1] == "/"):
                i += 1
            i += 2
            continue
        out.append(c)
        i += 1
    return "".join(out)

try:
    text = strip_jsonc(open(os.path.expanduser("~/.config/zed/settings.json")).read())
    text = re.sub(r",\s*([}\]])", r"\1", text)  # trailing commas
    cfg = json.loads(text)
    theme = cfg["lsp"]["tinymist"]["settings"]["preview"].get("theme", "auto")
    print(theme if theme in ("dark", "light") else "auto")
except Exception:
    print("auto")
EOF
)
if [ "$theme" = auto ]; then
    if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
        theme=dark
    else
        theme=light
    fi
fi

cmd=$1
shift

# typst_themed <compile|watch> <dark|light> <file> <output>
typst_themed() {
    if [ "$2" = dark ]; then
        typst "$1" --input theme=dark --input dark-mode=true "$3" "$4"
    else
        typst "$1" "$3" "$4"
    fi
}

case "$theme" in
dark) other=light ;;
*) other=dark ;;
esac

# Stable per-file port in [base, base+700): lets the Safari web app keep a
# reconnectable URL across restarts, and lets a rerun reuse a live server
# instead of spawning a duplicate.
file_port() {
    echo $(($1 + $(printf %s "$2" | cksum | awk '{print $1}') % 700))
}

case "$cmd" in
export)
    file=$1
    stem="$(dirname "$file")/$(basename "$file" .typ)"
    typst_themed compile "$theme" "$file" "$stem.pdf" || exit
    typst_themed compile "$other" "$file" "$stem-$other.pdf"
    # open the current-theme pdf in the OS default viewer (macOS Preview)
    open "$stem.pdf"
    ;;
watch)
    file=$1
    stem="$(dirname "$file")/$(basename "$file" .typ)"
    trap 'kill 0' INT TERM
    typst_themed watch "$theme" "$file" "$stem.pdf" &
    typst_themed watch "$other" "$file" "$stem-$other.pdf" &
    wait
    ;;
preview)
    root=$1
    file=$2
    if [ "$theme" = dark ]; then
        addr_file="$HOME/Library/Caches/tinymist/preview/$(printf %s "$root" | tr / _).addr"
        url="http://$(cat "$addr_file" 2>/dev/null || echo 127.0.0.1:23635)/"
        open -a Typst "$url" 2>/dev/null || open "$url"
    else
        port=$(file_port 24000 "$file")
        url="http://127.0.0.1:$port/"
        if curl -s --max-time 1 "$url" > /dev/null 2>&1; then
            exec open -a Typst "$url"
        fi
        exec "$TINYMIST" preview \
            --data-plane-host=127.0.0.1:$port \
            --control-plane-host=127.0.0.1:0 \
            --open-in Typst \
            --invert-colors=never \
            --root "$root" \
            --open "$file"
    fi
    ;;
annotate)
    root=$1
    file=$2
    port=$(file_port 24800 "$file")
    url="http://127.0.0.1:$port/?annotate"
    if curl -s --max-time 1 "http://127.0.0.1:$port/" > /dev/null 2>&1; then
        exec open -a Typst "$url"
    fi
    if [ "$theme" = dark ]; then
        set -- --input theme=dark --input dark-mode=true
    else
        set --
    fi
    exec "$TINYMIST" annotate \
        --data-plane-host=127.0.0.1:$port \
        --control-plane-host=127.0.0.1:0 \
        --open-in Typst \
        --invert-colors=smart \
        "$@" \
        --root "$root" \
        --open "$file"
    ;;
*)
    echo "usage: typst-task.sh export|watch <file> | preview|annotate <root> <file>" >&2
    exit 2
    ;;
esac
