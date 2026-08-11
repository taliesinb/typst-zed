#set page(numbering: "1 / 1")
#set heading(numbering: "1.1")

= Annotated example<-A100->

This document demonstrates preview annotations across several pages. Open it
in Zed and run the *Typst: Annotate* task: the web view is locked to
annotations — click any word to attach a comment, click a letter square to
read, reply, resolve, or delete one. Anchors are invisible cursor labels
like `<-A100->`; the orange I-beam carets mark their exact
positions<-B200-> inline. Scroll around: annotations whose anchors leave
the viewport stack up as letter squares at the top-right and bottom-right
edges, so every thread stays one click away.

== How it fits together

- The sidecar `annotated.annos.typ` holds one `#metadata` entry per
  annotation; read it with `typst query annotated.annos.typ metadata`.
- Anchors<-C300-> travel with the text they follow — edit freely, they
  re-resolve on every compile.
- Agents watch the sidecar (or the JSONL events on stdout of
  `tinymist annotate`) and reply by appending to `discussion`.
- Deleting an anchor or an entry orphans the other half harmlessly.

#pagebreak()

= Shapes and figures

A figure built from primitives, no libraries involved:

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
  caption: [Three primitives standing in for a real diagram<-D400->.],
)

The caret placement machinery resolves anchors at glyph granularity, so an
anchor in a caption lands in the caption, not merely "near the figure".

== A table for good measure

#figure(
  table(
    columns: 3,
    stroke: 0.4pt + gray,
    [*status*], [*pin color*], [*meaning*],
    [created], [green], [nobody has looked yet],
    [ongoing], [orange], [someone is on it],
    [resolved], [blue-gray], [done; safe to delete],
  ),
  caption: [Annotation states as rendered in the preview.],
)

#pagebreak()

= A page of prose

#lorem(60)

The anchor at the end of this very sentence sits mid-page, so it swaps
between the top and bottom stacks as you scroll past it<-E500->.

#lorem(80)

== Nested structure

+ Numbered items work like bullets.
+ So does deeper nesting:
  - An inner bullet with its own annotation anchor<-F600-> attached.
  - Another inner bullet, unannotated.
+ And back out again.

#lorem(40)

#pagebreak()

= Diagrams from scratch

A hand-rolled "graph" using absolutely positioned boxes and lines:

#figure(
  box(width: 70%, height: 110pt, {
    place(dx: 10pt, dy: 40pt, circle(radius: 14pt, fill: aqua.lighten(50%), stroke: 0.6pt)[#align(center + horizon)[A]])
    place(dx: 120pt, dy: 6pt, circle(radius: 14pt, fill: aqua.lighten(50%), stroke: 0.6pt)[#align(center + horizon)[B]])
    place(dx: 230pt, dy: 60pt, circle(radius: 14pt, fill: aqua.lighten(50%), stroke: 0.6pt)[#align(center + horizon)[C]])
    place(dx: 34pt, dy: 48pt, line(length: 92pt, angle: -16deg, stroke: 0.8pt))
    place(dx: 145pt, dy: 26pt, line(length: 95pt, angle: 25deg, stroke: 0.8pt))
  }),
  caption: [A tiny hypergraph impersonator<-G700->.],
)

Some display math to annotate around (anchors live in markup text, so this
sentence carries the anchor, not the formula itself):

$ sum_(k=1)^n k = (n(n+1)) / 2 $

#lorem(50)

#pagebreak()

= Closing page

#lorem(30)

If you can read this, you have scrolled far enough that most anchors above
are stacked at the top-right edge. This final anchor<-H800-> should be the
only one still rendered inline — click any square in the stack to jump into
its thread without scrolling back.

#lorem(30)
