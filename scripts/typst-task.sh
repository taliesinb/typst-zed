#!/bin/sh
# Theme-aware Typst tasks for Zed (export | watch | preview).
#
# The theme comes from ~/.config/typst-zed/theme, containing one of:
#   dark | light | system
# Missing file means "system", which follows the macOS appearance.
#
# dark  export/watch: compiles with --input theme=dark --input dark-mode=true
#       to <stem>-dark.pdf; preview: opens the background LSP preview (whose
#       compiles carry the dark inputs from Zed's tinymist settings).
# light export/watch: plain typst compile to <stem>.pdf; preview: runs a
#       standalone tinymist preview without dark inputs.

TINYMIST=/Users/tali/github/tinymist/target/release/tinymist

theme=$(cat "$HOME/.config/typst-zed/theme" 2>/dev/null || echo system)
if [ "$theme" = system ]; then
    if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
        theme=dark
    else
        theme=light
    fi
fi

cmd=$1
shift

dark_output() {
    printf '%s/%s-dark.pdf' "$(dirname "$1")" "$(basename "$1" .typ)"
}

case "$cmd" in
export)
    if [ "$theme" = dark ]; then
        exec typst compile --input theme=dark --input dark-mode=true "$1" "$(dark_output "$1")"
    else
        exec typst compile "$1"
    fi
    ;;
watch)
    if [ "$theme" = dark ]; then
        exec typst watch --input theme=dark --input dark-mode=true "$1" "$(dark_output "$1")"
    else
        exec typst watch "$1"
    fi
    ;;
preview)
    root=$1
    file=$2
    if [ "$theme" = dark ]; then
        addr_file="$HOME/Library/Caches/tinymist/preview/$(printf %s "$root" | tr / _).addr"
        url="http://$(cat "$addr_file" 2>/dev/null || echo 127.0.0.1:23635)/"
        open -a Typst "$url" 2>/dev/null || open "$url"
    else
        exec "$TINYMIST" preview \
            --data-plane-host=127.0.0.1:0 \
            --open-in Typst \
            --invert-colors=never \
            --root "$root" \
            --open "$file"
    fi
    ;;
*)
    echo "usage: typst-task.sh export|watch <file> | preview <root> <file>" >&2
    exit 2
    ;;
esac
