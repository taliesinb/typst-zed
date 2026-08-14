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

# The blessed build: `cargo install --path crates/tinymist-cli` in the fork
# promotes whatever is in the working tree to ~/.cargo/bin/talimist. Iteration
# happens in target/release/talimist, which this deliberately does not follow.
TINYMIST="$HOME/.cargo/bin/talimist"
# Annotation is served by the document server rather than by a preview tied to
# this editor session: it derives its own port from the document's path, reuses
# a server that is already up, and exits by itself when the binary is replaced.
TINYMIST_SERVE="$HOME/.cargo/bin/talimist-serve"

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
# `root` (the project root; set by each case, defaulting to the task's
# working directory, i.e. Zed's worktree root) becomes --root so files
# in subdirectories can import upward ("../style.typ")
typst_themed() {
    if [ "$2" = dark ]; then
        typst "$1" --root "$root" --input theme=dark --input dark-mode=true "$3" "$4"
    else
        typst "$1" --root "$root" "$3" "$4"
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

# A live server on the port is reused — but only if it is not older than the
# binary. A rebuilt tinymist otherwise keeps serving from the process that was
# already running, which looks exactly like the rebuild not having worked.
# Prints "reuse" or "stale" (having killed the stale server).
server_state() {
    port=$1
    curl -s --max-time 1 "http://127.0.0.1:$port/" > /dev/null 2>&1 || {
        echo none
        return
    }
    pid=$(lsof -t -nP -iTCP:"$port" -sTCP:LISTEN 2>/dev/null | head -1)
    started=$(ps -p "${pid:-0}" -o lstart= 2>/dev/null)
    if [ -n "$started" ]; then
        started=$(date -j -f "%a %b %e %T %Y" "$started" +%s 2>/dev/null)
        built=$(stat -f %m "$TINYMIST" 2>/dev/null)
        if [ -n "$started" ] && [ -n "$built" ] && [ "$built" -gt "$started" ]; then
            echo "typst-task: tinymist is newer than the server on :$port — restarting it" >&2
            kill "$pid" 2>/dev/null
            # Give the port a moment to come free before rebinding it.
            n=0
            while [ $n -lt 20 ] && lsof -t -nP -iTCP:"$port" -sTCP:LISTEN > /dev/null 2>&1; do
                n=$((n + 1))
                /bin/sleep 0.1
            done
            echo none
            return
        fi
    fi
    echo reuse
}

case "$cmd" in
export)
    file=$1
    root=${2:-$PWD}
    stem="$(dirname "$file")/$(basename "$file" .typ)"
    typst_themed compile "$theme" "$file" "$stem.pdf" || exit
    typst_themed compile "$other" "$file" "$stem-$other.pdf"
    # open the current-theme pdf in the OS default viewer (macOS Preview)
    open "$stem.pdf"
    ;;
watch)
    file=$1
    root=${2:-$PWD}
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
        open "$url"
    else
        port=$(file_port 24000 "$file")
        # `/p/` is where a preview lives; the annotator is at `/a/` and a plain
    # served document at `/v/`.
    url="http://127.0.0.1:$port/p/"
        if [ "$(server_state "$port")" = reuse ]; then
            exec open "$url"
        fi
        # The window is the whole point of this server: when it closes, nothing
        # is left to serve, and a lingering one would be reused tomorrow.
        exec "$TINYMIST" preview \
            --data-plane-host=127.0.0.1:$port \
            --control-plane-host=127.0.0.1:0 \
            --invert-colors=never \
            --shutdown-on-last-client \
            --open \
            --root "$root" \
            "$file"
    fi
    ;;
annotate)
    root=$1
    file=$2
    if [ "$theme" = dark ]; then
        set -- --input theme=dark --input dark-mode=true
    else
        set --
    fi
    # Annotations hang off the document's own elements in HTML — which is the
    # default now — so they survive reflow and the window can be any width.
    # The port, the reuse of a server that is already up, and the web app's
    # name and icon are all the document server's business.
    # The annotate window is the whole point of this server: when it closes,
    # nothing is left to serve, and a lingering one would be reused tomorrow.
    # The salt keeps that from applying to a server started by hand: `talimist
    # serve docs/MATH.typ` in a terminal gets a port of its own, and closing
    # this window does not stop it.
    # `--mcp` as well: a document being annotated is one an agent may be asked
    # about, and the tools reach a server only if it was started with it. It
    # also means an agent working on this document keeps the server alive for
    # half an hour after the window closes, rather than losing it mid-edit.
    exec "$TINYMIST_SERVE" \
        --anno \
        --mcp \
        --port-salt zed \
        --shutdown-on-last-client \
        --open \
        --root "$root" \
        "$@" \
        "$file"
    ;;
*)
    echo "usage: typst-task.sh export|watch <file> [root] | preview|annotate <root> <file>" >&2
    exit 2
    ;;
esac
