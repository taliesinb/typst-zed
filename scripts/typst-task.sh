#!/bin/sh
# Theme-aware Typst tasks for Zed (export | watch | preview).
#
# The theme comes from ~/.config/typst-zed/theme, containing one of:
#   dark | light | system
# Missing file means "system", which follows the macOS appearance.
#
# export/watch produce BOTH themes: <stem>.pdf in the current theme (the one
# the preview would use) and <stem>-light.pdf or <stem>-dark.pdf for the
# other one.
#
# preview: dark opens the background LSP preview (whose compiles carry the
# dark inputs from Zed's tinymist settings); light runs a standalone
# tinymist preview without dark inputs.

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
