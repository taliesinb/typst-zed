#set page(numbering: "1 / 1")
#set heading(numbering: "1.1")

= Annotated example<anno.A100.word>

This document demonstrates preview annotations across several pages. Open it
in Zed and run the *Typst: Annotate* task: the web view is locked to
annotations — click any word to attach a comment, click a letter square to
read, reply, resolve, or delete one. Anchors are invisible cursor labels
like `<anno.A100.word>`; the marks in the letter's own colour show their exact
positions<anno.B200.word> inline. Scroll around: annotations whose anchors leave
the viewport stack up as letter squares at the top-right and bottom-right
edges, so every thread stays one click away.

== How it fits together

- The sidecar `annotated.annos.typ` holds one `#metadata` entry per
  annotation; read it with `typst query annotated.annos.typ metadata`.
- Anchors<anno.C300.item> travel with the text they follow — edit freely, they
  re-resolve on every compile.
- Agents watch the sidecar (or the JSONL events on stdout of
  `tinymist annotate`) and reply by appending to `discussion`.
- Deleting<anno.31CA.word> an<anno.B12A.word> anchor or an entry orphans the other half harmlessly.
- Why do Typst annotations make terrible<anno.8494.point> comedians? Their delivery is
  always anchored to the same spot — but at least they never lose their
  place in the document.

== Lists, nested and numbered<anno.H001.item>

A section for exercising the list scopes: every marker below should point at
its own item<anno.H002.item>, never at a neighbour, and nested items should be marked at
their own indentation.

- A plain bullet<anno.L001.item> carrying an item annotation.
- A bullet whose *word*<anno.L002.word> is annotated instead of the item.
- A bullet with children:
  - A nested bullet<anno.L003.item> with its own item annotation.
  - Another nested bullet, unannotated.
  - A third nested bullet whose sentence is annotated. It continues past the
    line break so the highlight has to wrap.
- Back out to the top level<anno.L005.item>.

+ A numbered item<anno.L006.item>, first in its list.
+ A numbered item with nested numbering:
  + An inner number<anno.L007.item> annotated as an item.
  + Another inner number, unannotated.
+ A numbered item annotated as a *paragraph*<anno.L008.para> instead.

/ A term: with a definition body that is annotated as an item<anno.L009.item>.
/ Another term: unannotated, for contrast.

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
  caption: [Three primitives standing in for a real diagram<anno.D400.word>.],
)<anno.CC3B.block>

The caret placement machinery resolves anchors at glyph granularity, so an
anchor in a caption lands in the caption, not merely "near the figure".

== A table for good measure

Colour belongs to the annotation, not to its state: each letter takes the next
hue from a fixed palette, so A is always the same colour wherever it appears —
in the text, on the chip riding the right-hand edge, and on the window at the
corner. After the tenth letter the palette starts again.

#figure(
  table(
    columns: 3,
    stroke: 0.4pt + gray,
    [*status*], [*shown as*], [*meaning*],
    [created], [its own colour], [nobody has looked yet],
    [ongoing], [its own colour], [someone is on it],
    [resolved], [the same, dimmed], [done; safe to delete],
  ),
  caption: [Annotation states as rendered in the preview.],
)

#pagebreak()

= A page of prose

Lorem ipsum dolor sit amet, consectetur adipiscing elit, <anno.S100.span.begin>sed do eiusmod tempor
incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque
doleamus animo, cum<anno.S100.span.end> corpore dolemus, fieri tamen permagna accessio potest, si
aliquod aeternum et infinitum impendere malum nobis opinemur. Quod idem licet
transferre in voluptatem, ut postea variari voluptas distinguique possit, augeri
amplificarique non possit. At.

This is an unannotated sentence. This is an annotated <anno.E500.sentence> sentence. This is an unannotated sentence.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque
doleamus animo, cum corpore dolemus, fieri tamen permagna accessio potest, si
aliquod aeternum et infinitum impendere malum nobis opinemur. Quod idem licet
transferre in voluptatem, ut postea variari voluptas distinguique possit, augeri
amplificarique non possit. At etiam Athenis, ut e patre audiebam facete et urbane
Stoicos irridente, statua est in quo a nobis philosophia defensa et.

== Nested structure

+ Numbered items work like bullets.
+ So does deeper nesting:
  - An inner bullet with its own annotation anchor attached.
  - Another inner bullet, unannotated.
+ And back out again.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque
doleamus animo, cum corpore dolemus, fieri tamen permagna accessio potest, si
aliquod aeternum et infinitum impendere.

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
  caption: [<anno.D8DA.svg>A tiny hypergraph impersonator],
)

Some display math to annotate around (anchors live in markup text, so this
sentence carries the anchor, not the formula itself):

$ sum_(k=1)^n k = (n(n+1)) / 2 $<anno.A8CF.math.block>

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque
doleamus animo, cum corpore dolemus, fieri tamen permagna accessio potest, si
aliquod aeternum et infinitum impendere malum nobis opinemur. Quod idem licet
transferre in voluptatem, ut.

#pagebreak()

= Closing page

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque
doleamus animo, cum corpore dolemus, fieri.

If you can read this, you have scrolled far enough that most anchors above
are stacked at the top-right edge. This final anchor should be the
only one still rendered inline — click any square in the stack to jump into
its thread without scrolling back.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim aeque
doleamus animo, cum corpore dolemus, fieri.
