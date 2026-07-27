# Typst Extension for Zed

## Usage

To register the LSP and enable certain features (such as compile on save), add the following to your local (resp. server) configuration file (`~/.zed/settings.json`):

```jsonc
// In settings.json
{
	"lsp": {
		"tinymist": {
			"initialization_options": {
				// Enable background preview
				// Server will be running on 127.0.0.1:23635
				"preview": {
					"background": {
						"enabled": true,
					},
				},
			},

			"settings": {
				// Compile on save
				// This will compile a PDF for the `main.typ` file in the project root.
				"exportPdf": "onSave",
				"outputPath": "$root/$name"

				// Enable formatter
				"formatterMode": "typstyle",
			}
		}
	},

	"languages": {
		"Typst": {
			// Disable soft wrap
			"soft_wrap": "none",
		},
	},
}
```

To see all available options refer to [the tinymist documentation](https://github.com/Myriad-Dreamin/tinymist/blob/main/editors/neovim/Configuration.md).
Beware that the configuration options displayed there apply to **NeoVim**, not Zed, so some might be incorrect or misleading

## Live preview

With background preview enabled (see above), tinymist serves a live preview of the
focused Typst file at <http://127.0.0.1:23635>. It updates as you type and follows
the file you are working on.

Every `.typ` file shows a play button (runnable indicator) on its first line that
opens the preview in your default browser, via the bundled `Typst: Open Preview`
task. It is also available from `task: spawn`.

Editor-to-preview scroll synchronization additionally requires a tinymist build
with the `preview.followCursor` setting
(see [taliesinb/tinymist#implicit-scroll-sync](https://github.com/taliesinb/tinymist/tree/implicit-scroll-sync)),
enabled under `lsp.tinymist.settings`:

```jsonc
"settings": {
	"preview": { "followCursor": true },
}
```

## Components

- Tree Sitter: [tree-sitter-typst](https://github.com/uben0/tree-sitter-typst/)
- Language Server: [tinymist](https://github.com/Myriad-Dreamin/tinymist/)
