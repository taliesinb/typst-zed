#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

// #set page(numbering: "1 / 1")
// #set heading(numbering: "1.1")

= Annotated example<anno.A100>

This document describes the features of the tinymist Typst annotation server,
and contains some annotations for good measure.

From Zed you can run the *Typst: Annotate* task to auto-open your browser to
this page in annotation mode, which will allow you to see and read these
annotations.

Alternatively, from the command line you can run
`talimist serve --anno --open annotated.typ`, the `--open` flag will
automatically open your system browser to the annotation page.

If you are an agent, and the MCP tool is installed (`talimist mcp --print-config`
prints the one line that registers it), then you can use tools to watch for and
respond to user annotations on a document that they (or you) are serving. See
the MCP section at the end of this document.

== What are annotations?

Annotations are anchored by labels like `<anno.A100>` in the Typst file being
annotated. Everything else about an annotation lives in the sidecar file
(`annotated.annos.json`, named after the document it belongs to).

The `A100` in `<anno.A100>` identifies the anchor, not the annotation: several
annotations may point at the same anchor, which is what allows two comments on
one word. A Typst element carries at most one label, so anchors are shared
rather than written per annotation. Each annotation has an ID of its own in the
sidecar, and a human-visible letter that ticks up from `a` to `b` to `c`.

The sidecar says what kind of place each anchor marks, in a `location` field.
The kinds are:

#figure(
  table(
    columns: 3,
    align: left,
    stroke: 0.4pt + gray,
    [*location*], [*refers to*], [*drawn as*],

    [`word`], [the word before its anchor], [an underline],
    [`math`], [the inline equation before it], [an underline],
    [`link`], [the link before it], [an underline],
    [`raw`], [the raw text before it, e.g. code], [an underline],
    [`opaque`], [content a call produced, annotated as the call], [an underline],
    [`pos.h`], [a position between words], [a caret],
    [`pos.v`], [a position above or below a block], [a caret],
    [`sentence`], [the sentence containing its anchor], [an underline],
    [`span.h`], [everything between two anchors], [an underline],
    [`span.v`], [the blocks between two anchors], [a frame],
    [`item`], [the list item, term or heading containing it], [a ring on its marker],
    [`para`], [the paragraph containing it], [a frame],
    [`block`], [the block containing it: a heading, a figure, a callout], [a frame],
    [`math.block`], [the block equation before it], [a frame],
    [`svg`], [the drawing before it], [a frame],
    [`image`], [the picture before it: a PNG, a JPEG, an SVG file], [a frame],
    [`document`], [the document as a whole, no anchor], [a pin in the corner],
  ),
  caption: [The locations an annotation can have.],
)<anno.T001>

A location that names something _before_ its anchor (a word, an equation, a
drawing) needs the label written immediately after that thing, with no space
between them. The rest are found by looking outwards from where the label sits.

== How to add annotations

Hovering shows what annotation WOULD be created if you were to click.

E.g. click any word to attach a word-level annotation, click an equation to attach a math-level annotation,
click on the bounding box of a figure to attach a figure-level annotation, etc.

Annotations also have matching "chips" that show up in the right hand gutter, you can click these to scroll to the annotation and edit it.

== How it fits together

- The sidecar `annotated.annos.json` holds one record per annotation; read it
  with `talimist annos list annotated.typ`, or as JSON.
- Anchors<anno.C300> travel with the text they follow — edit freely, they
  re-resolve on every compile.
- Agents watch the sidecar, or the JSONL events `talimist serve --anno` writes
  to stderr, or call the MCP tools above, and reply by appending to
  `discussion`.
- Deleting<anno.31CA> an<anno.B12A> anchor leaves its annotations without a
  subject, which `talimist annos audit` reports. An anchor no annotation points
  at is removed.

== Watching a server

A server narrates what it is doing, one JSON object per line, on stderr. Every
line begins with `ts` and then `type`, so a column of lines is a column of
times. The kinds are:

#figure(
  table(
    columns: 2,
    align: left,
    stroke: 0.4pt + gray,
    [*line*], [*said when*],

    [`initialized`], [the server starts: what it serves, where, and its pid],
    [`tailscale_initialized`], [it is also published on the tailnet],
    [`document_compiled`], [a compile finished: why it ran, and the version it wrote],
    [`file_changed`], [a watched file moved],
    [`directory_listed`], [the listing changed, for a server holding a directory],
    [`client_identified`], [a caller is seen for the first time: name, address, browser],
    [`client_requested`], [a page was asked for],
    [`client_opened`], [a page opened its event stream],
    [`client_closed`], [and closed it again],
    [`shutdown`], [the server is stopping, and why],
  ),
  caption: [The lines a server writes.],
)<anno.J001>

A caller is identified once — the triple of login, address and browser — and
every line after that names its `client_id` alone. Two tabs in one browser are
one caller, which is why the lines about a page carry the URL as well.

The `reason` on `document_compiled` says what set the compile off:
`file_opened` for the first one, `file_changed` when the document itself was
edited, `annotation_changed` when its sidecar was written, and
`dependency_changed` for anything else it reads. The `version` is the one the
rendering was written at, which is what a page fetches; a compile that produces
the same rendering keeps the version it had.

See below for some examples.

#pagebreak()

= Examples

What follows are some examples annotations.

== An annotated heading <anno.H001>

== Text<anno.E4E0>

An annotated word<anno.W001>.

A space between two <anno.P001> words can be annotated as well.<anno.75DD>

A <anno.S001>span of annotated words on a single<anno.0010> line.

A span of annotated words over multiple lines: <anno.S002>sed do eiusmod tempor
incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque
doleamus animo, cum<anno.0020> corpore dolemus, fieri tamen permagna accessio potest, si
aliquod aeternum et infinitum impendere malum nobis opinemur.

This is an unannotated sentence. This is an annotated <anno.X001> sentence. This is an unannotated sentence.

An entire paragraph can be annotated. <anno.X002>
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque
doleamus animo, cum corpore dolemus, fieri tamen permagna accessio potest, si
aliquod aeternum et infinitum impendere malum nobis opinemur.

A code fragment like `let x = 1`<anno.R001> is annotated as raw text, and a
link like #link("https://typst.app")[the Typst website]<anno.K001> is
annotated as a link.

#let shout(word) = text(fill: rgb("#3b7dd8"), weight: "bold", upper(word))

Text a helper made rather than text you wrote — #shout("this")<anno.N001>,
say, from a `#let shout(word) = …` above — is annotated as inline content: the
label attaches to whatever the call produced, not to the words around it.

== Math

An annotated inline equation $x + 2$<anno.M001> within text.

An annotated block equation:
$ sum_(k=1)^n k = (n(n+1)) / 2 $<anno.M002>

== Items

Items can be annotated:
- A plain bullet<anno.I001> carrying an item annotation.
  - A nested bullet<anno.I002> with its own item annotation.
  - An unannotated bullet.

+ A numbered item<anno.I003>, first in its list.
+ A numbered item with nested numbering:
  + An inner number<anno.I004> annotated as an item.
  + Another inner number, unannotated.

/ A term: with a definition body that is annotated as an item<anno.I005>.
/ Another term: unannotated, for contrast.

== Figures

=== Diagrams

A graphics block can be annotated as a whole, WITHIN the figure:

#figure(
  [#box(width: 70%, height: 110pt, {
    place(dx: 10pt, dy: 40pt, circle(radius: 14pt, fill: aqua.lighten(50%), stroke: 0.6pt)[#align(center + horizon)[A]])
    place(dx: 120pt, dy: 6pt, circle(radius: 14pt, fill: aqua.lighten(50%), stroke: 0.6pt)[#align(center + horizon)[B]])
    place(dx: 230pt, dy: 60pt, circle(radius: 14pt, fill: aqua.lighten(50%), stroke: 0.6pt)[#align(center + horizon)[C]])
    place(dx: 34pt, dy: 48pt, line(length: 92pt, angle: -16deg, stroke: 0.8pt))
    place(dx: 145pt, dy: 26pt, line(length: 95pt, angle: 25deg, stroke: 0.8pt))
  })<anno.G001>],
  caption: [A tiny hypergraph impersonator],
)

Or the entire figure can be annotated, as well as any part of the caption:

#figure(
  box(width: 60%, inset: 8pt, stroke: 0.5pt + gray, radius: 4pt)[
    #stack(
      dir: ltr,
      spacing: 12pt,
      circle(radius: 18pt, fill: rgb("#f5a623").lighten(40%)),
      square(size: 36pt, fill: rgb("#409cff").lighten(50%), radius: 4pt),
      polygon(
        fill: rgb("#7bd88f").lighten(30%),
        (0pt, 36pt), (18pt, 0pt), (36pt, 36pt),
      ),
    )
  ],
  caption: [Three primitives standing<anno.W002> in for a real diagram.],
)<anno.F001>

A drawing made by a package is annotated the same way — the anchor names the
drawing itself, not the figure around it:

#figure(
  [#diagram(
    spacing: (18mm, 12mm),
    node((0, 0), $A$),
    node((1, 0), $B$),
    node((0, 1), $C$),
    node((1, 1), $D$),
    edge((0, 0), (1, 0), $f$, "->"),
    edge((0, 0), (0, 1), $g$, "->"),
    edge((1, 0), (1, 1), $h$, "->"),
    edge((0, 1), (1, 1), $k$, "->"),
  )<anno.D001>],
  caption: [A square that commutes, drawn with fletcher.],
)

A table can be annotated as a whole, or any of its contents:

#figure(
  table(
    columns: 3,
    stroke: 0.4pt + gray,
    [*flag*], [*shown as*], [*meaning*],
    [neither], [its own colour], [nobody has looked yet],
    [claimed<anno.T002>], [its own colour], [someone is on it],
    [resolved], [the same, dimmed], [done; safe to delete],
  ),
  caption: [Annotation states as rendered in the preview.],
)<anno.T003>

= MCP interactions

The MCP server is named `talimist`, and the user can receive instructions for
how to install it using `talimist mcp --print-config`.

One `talimist mcp --stdio` process answers for every server that is running,
so an agent talks to one thing however many documents are being read. Serve
with `--mcp` or nothing will be listening.

Here is a list of tools:

== Finding the work

- `list_servers` reports which documents are being served, and under what name.
  It is the first call: everything else takes that name as `server`. An empty
  list means nothing is being served, and `open_document` is how to start one.
- `open_document` serves a file or directory that nobody is serving yet. Pass
  `show: true` to open a window on it, so the person you are working for can
  watch what you are about to do to their paragraph. It reports `state` as
  `started` or `reused`.
- `list_documents` lists what one server holds, with the number of annotations
  by status. A server of one document lists one.
- `close_document` stops a server you started.

== Reading annotations

- `wait_for_annotations` waits until there is something to do, and reports
  everything that happened since the cursor you last saw — including what
  arrived while you were thinking.
- `list_annotations` is the work queue: filter by `status: "created"` for the
  ones nobody has claimed. Each entry carries an excerpt and where it sits, so
  it is usually enough on its own.
- `get_annotation` gives one in full, with its discussion.
- `get_capture` hands you a picture of what a graphical annotation points at —
  a plot, a diagram, a framed drawing — with anything the reader drew on top.
  The document is source, so this is the only way to see what they saw.

== Acting on them

- `claim` says you are working on one; `release` gives it back. Both set the
  `claimed` flag; `resolve` sets `resolved`, and the two are independent.
- `get_block` gives you the piece of source it points at, small enough to
  rewrite whole, with every anchor inside it and where.
- `replace_block` rewrites that piece and tells you whether the document still
  compiles. It refuses a block that changed since you read it, and a rewrite
  that would drop an anchor.
- `render_snippet` compiles a fragment beside the document — same imports,
  fonts and data files — and returns a picture, a PDF, an SVG or HTML. Use it
  to see how a table or a figure comes out before putting it in the document.
- `reply` says something in the thread; `resolve` says what you did and closes
  it.
- `annotate` adds an annotation about the document as a whole, for something
  noticed while reading that is not about one place.
- `delete` removes an annotation. Prefer `resolve`, which keeps what was said
  and what was done about it.

== Checking your work

- `document_status` reports whether the document compiles, which rendering the
  readers are looking at, how many are connected, whether the document says it
  is generated, and which files a change to would rebuild it.
- `audit` reports what the document and its sidecar say about each other:
  anchors nothing points at, and annotations whose anchor is gone.

Two things are worth saying about the source of a served document. Rewriting a
block is optional: an annotation about a figure is often fixed in the script
that draws it, and `resolve` does not require a preceding `replace_block`. And
a document that carries a `// GENERATED` header should be left alone — fix
whatever generates it, since a rewrite here is gone at the next run.

The sidecar `annotated.annos.json` is the reader's work and belongs in the
repository. It sits beside the document and next to build outputs, which makes
it look like one; it is not. The `_` field at the top of the file says so.
