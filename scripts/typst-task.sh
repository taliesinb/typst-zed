#!/bin/sh
# Theme-aware PDF export for Zed.
#
# Everything else a Typst task used to do is now a talimist subcommand called
# straight from tasks.json: `open-preview` finds the preview the language
# server is already running, and `serve --anno` is the annotator. What is left
# here is the one job that is still two compiles and an `open`.
#
# Both themes are produced: <stem>.pdf in the current theme (the one a preview
# would use) and <stem>-light.pdf or <stem>-dark.pdf for the other, so a
# document written for a dark screen still has a copy to print.
#
# The theme comes from Zed's settings.json:
#   "lsp": { "tinymist": { "settings": { "preview": { "theme": "dark" } } } }
# with values dark | light | auto. Missing (or "auto") follows the macOS
# appearance. The key rides along in the tinymist LSP settings block, which
# is free-form JSON; tinymist itself ignores unknown keys.
#
# The blessed build: `cargo install --path crates/tinymist-cli` in the fork
# promotes whatever is in the working tree to ~/.cargo/bin/talimist. Iteration
# happens in target/release/talimist, which this deliberately does not follow.
TALIMIST="$HOME/.cargo/bin/talimist"

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

# typst_themed <dark|light> <file> <output>
# `root` (the project root; set by each case, defaulting to the task's
# working directory, i.e. Zed's worktree root) becomes --root so files
# in subdirectories can import upward ("../style.typ")
typst_themed() {
    "$TALIMIST" compile --root "$root" --theme "$1" "$2" "$3"
}

case "$theme" in
dark) other=light ;;
*) other=dark ;;
esac

case "$cmd" in
export)
    file=$1
    root=${2:-$PWD}
    stem="$(dirname "$file")/$(basename "$file" .typ)"
    typst_themed "$theme" "$file" "$stem.pdf" || exit
    typst_themed "$other" "$file" "$stem-$other.pdf"
    # open the current-theme pdf in the OS default viewer (macOS Preview)
    open "$stem.pdf"
    ;;
*)
    echo "usage: typst-task.sh export <file> [root]" >&2
    exit 2
    ;;
esac
