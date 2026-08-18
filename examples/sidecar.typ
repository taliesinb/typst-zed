= The annotation sidecar

Annotations are not stored in the document. The document carries anchors —
labels of the form `<anno.A100>` — and all other annotation data is stored in a
JSON file beside it, named after it: `report.typ` has `report.annos.json`.

The sidecar holds user data and belongs in version control. It is not a build
output.

This document specifies the format. The authoritative definitions are the Rust
types in `tinymist-annos`: `Sidecar`, `Annotation` and `Capture` in `record.rs`,
`Location` in `location.rs`.

= Schema

The notation below is pseudocode. `{ ... }` is a JSON object, `[T]` an array of
`T`, `T?` an optional field, and `|` a choice between alternatives. A choice of
objects is discriminated by the `type` field.

== Records

```
Sidecar = {
  _:           String        // what the file is; rewritten on every save
  version:     Int           // format version, currently 1
  annotations: [Annotation]
}

Annotation = {
  uuid:       String         // identity, stable for the life of the annotation
  letter:     String         // display name, reassigned in reading order
  location:   Location
  snapshot:   String?        // what the location referred to when it was made
  type:       "comment" | "question" | "request"
  color:      String         // "#rrggbb"
  author:     String
  time:       Timestamp      // created
  mtime:      Timestamp      // last changed
  claimed:    Bool           // somebody is working on it
  resolved:   Bool           // it is finished with
  content:    String
  scribble:   Scribble?      // what was drawn while writing it
  discussion: [Reply]        // omitted when empty
  captures:   [Capture]      // omitted when empty
}

Reply = {
  author:   String
  time:     Timestamp
  content:  String
  scribble: Scribble?        // what was drawn while writing it
}

Scribble = {
  id:      String            // its own name, made by the page
  capture: String            // the capture it is drawn on, by that capture's id
  shapes:  [Mark]            // in that capture's coordinates
}

Capture = {
  id:     String             // what a scribble names it by; a capture written
                             // before captures had ids answers to its hash
  time:   Timestamp
  fmt:    "svg" | "png"
  hash:   String             // key into the capture store
  width:  Int                // size on the page, in CSS pixels
  height: Int
}

Mark =
  | { type: "path",  coords: Base64, width: Float, color: String }
  | { type: "point", x: Float, y: Float, width: Float, color: String }

Base64 = String              // little-endian f32, x and y alternating

Timestamp = String           // ISO 8601 UTC, e.g. "2026-08-18T09:22:32Z"
```

== Locations

`Location` is a sum type. Each variant names either what is annotated (a word,
an equation, a drawing) or where an annotation sits without anything being
annotated (a position between words, a span with two ends).

```
Location =
  | { type: "word",       ref: Word }         // the word itself
  | { type: "line",       ref: Word }         // the line the word is on
  | { type: "sentence",   ref: Word }         // the sentence containing it
  | { type: "pos.h",      ref: TextCursor }   // a position between two words
  | { type: "pos.v",      ref: NodeCursor }   // a position between two blocks
  | { type: "span.h",     begin: TextCursor, end: TextCursor }
  | { type: "span.v",     begin: NodeCursor, end: NodeCursor }
  | { type: "raw",        ref: Node }         // a fragment of code
  | { type: "para",       ref: Node }
  | { type: "item",       ref: Node }         // a bullet, an entry, a term
  | { type: "block",      ref: Node }         // a heading, a figure, a callout
  | { type: "opaque",     ref: Node }         // content produced by a call
  | { type: "math",       ref: Node }         // an inline equation
  | { type: "math.block", ref: Node }
  | { type: "link",       ref: Node }
  | { type: "svg",        ref: Node }         // a drawing
  | { type: "image",      ref: Node }         // a picture file
  | { type: "document" }                      // the document as a whole
```

== References

A reference names an anchor by its label, without the angle brackets. `line`
and `sentence` take a `Word` because they are facts about the rendering rather
than about the document: the label marks a word, and the line or sentence
containing it is found from there.

```
Node       = { type: "node",        ref: Label }
Word       = { type: "word",        ref: Label }
TextCursor = { type: "text_cursor", ref: Label, side: "left" | "right" }
NodeCursor = { type: "node_cursor", ref: Label, side: "top"  | "bottom" }

Label = String               // an anchor without its brackets, e.g. "anno.A100"
```

A `TextCursor` carries a side because a Typst label cannot stand between two
characters: it attaches to the thing before it, so a position in the source is
a label and the side of it the position lies on.

Several annotations may share one anchor. A Typst element carries at most one
label, so the anchor identifies the place and the `uuid` identifies the remark.

== The same type against a rendering

`Location` is parameterised by what its references name. The sidecar stores the
Typst form above. The page and its endpoints use the HTML form, which has the
same variants and different references:

```
Node       = { type: "node",        ref: Uid }
Word       = { type: "word",        ref: Uid, beg: Int, end: Int, w: String? }
TextCursor = { type: "text_cursor", ref: Uid, pos: Int, l: String?, r: String? }
NodeCursor = { type: "node_cursor", ref: Uid, side: "top" | "bottom" }

Uid = String                 // an element of one rendering, e.g. "n692"
```

Offsets are in characters from the start of a text run. `w`, `l` and `r` hold
the text that was there — the word itself, and up to eight characters either
side of a cursor — so that a reference into a rendering that has since changed
can be recognised as stale rather than resolved to whatever now occupies those
positions.

Converting between the two forms is `resolve` (HTML to Typst, which writes
anchors into the document) and `project` (Typst to HTML). Both are in
`tinymist-annos`.

= Examples

== The file

```json
{
  "_": "Annotations for companion .typ file; written by talimist; ...",
  "version": 1,
  "annotations": [ ... ]
}
```

The `_` field is a fixed note for whoever opens the file. It is rewritten on
every save and never read back.

== An annotation

```json
{
  "uuid": "030afa98ed6831a1",
  "letter": "a",
  "location": { "type": "word", "ref": { "type": "word", "ref": "anno.A100" } },
  "snapshot": "the words this pointed at",
  "type": "comment",
  "color": "#faa39c",
  "author": "tali",
  "time": "2026-08-14T09:10:00Z",
  "mtime": "2026-08-16T21:40:04Z",
  "claimed": false,
  "resolved": false,
  "content": "What the reader said.",
  "discussion": [
    { "author": "claude", "time": "2026-08-14T09:31:00Z", "content": "What was done." }
  ]
}
```

`snapshot` records what the location referred to when the annotation was made.
An annotation whose anchor is later deleted uses it to report what it was
about; the annotation itself becomes one about the document.

== Locations

```json
{ "type": "block",  "ref":   { "type": "node", "ref": "anno.T003" } }
{ "type": "pos.h",  "ref":   { "type": "text_cursor", "ref": "anno.P001", "side": "right" } }
{ "type": "span.v", "begin": { "type": "node_cursor", "ref": "anno.A", "side": "top" },
                    "end":   { "type": "node_cursor", "ref": "anno.B", "side": "bottom" } }
{ "type": "document" }
```

`annotated.typ` contains one annotation of each type.

== Captures

A capture is an image of what an annotation refers to, taken at a moment. It
exists because the document is source code: an agent asked about a plot cannot
otherwise see the plot.

```json
{
  "id": "49722e8112b0c3f4",
  "time": "2026-08-18T08:33:35Z",
  "fmt": "png",
  "hash": "f30b2f5a6426bc85",
  "width": 720,
  "height": 44
}
```

The image itself is not in the sidecar. It is stored by hash under
`$XDG_STATE_HOME/talimist/captures` and served at `/api/capture/<hash>.<fmt>`.
The store is separate from the sidecar and from the server, so a capture
outlives both: an annotation made in March about a plot that has since been
redrawn still refers to the plot it was made about.

Captures are appended, so the list is a history. Two events add to it:

- A compile. The server extracts the drawing that each graphical annotation
  refers to from the rendered page, as SVG, and records it if it has changed.
- A stroke of the pen. When the reader draws on a picture, the page captures
  the picture itself — the SVG copied as it stands, an image file drawn onto a
  canvas, or any other element rasterised through an SVG `foreignObject` — and
  sends it together with the marks.

== Scribbles

A scribble is a drawing somebody made on a capture. It belongs to the remark it
was drawn with — the annotation itself, or one of its replies — and takes its
author and its time from there, because drawing on a picture is a way of saying
something about it. What it was drawn on is named rather than held: the picture
is a capture of the annotation, and the same picture can be scribbled on more
than once.

A scribble reaches the server with the words it was drawn with, when the reader
presses return. Until then the page holds it, and draws it faintly to say that
it has not been sent.

```json
{
  "id": "sf4gsr5r5",
  "capture": "49722e8112b0c3f4",
  "shapes": [
    { "type": "path", "coords": "mpkeQTMzKUI…", "width": 5, "color": "#7bd88f" },
    { "type": "point", "x": 26.9, "y": 58.5, "width": 5, "color": "#7bd88f" }
  ]
}
```

A `path` is a stroke of the pen: its `coords` are the points it was drawn
through, as little-endian `f32` in the order $x_0, y_0, x_1, y_1, ...$, base64
encoded. A stroke is a few hundred numbers, and numbers written as text are
four times the size. A `point` is a press that never became a stroke.

The points are sub-sampled as they are collected: the page keeps one every ten
pixels of pointer travel, plus the position the pointer was released at. A
pointer reports far more often than a stroke changes direction, and every
report kept is a number stored and drawn for as long as the annotation exists.

#figure(
  table(
    columns: 3,
    align: left,
    stroke: 0.4pt + gray,
    [*capture*], [*coordinates*], [*`width`*],

    [`svg`], [the drawing's user units, as its `viewBox` defines them],
    [5 pixels converted to those units],

    [`png`],
    [CSS pixels from the top left of the image, the units `width` and `height`
      are given in],
    [5],
  ),
  caption: [The coordinate system a scribble is written in.],
)

A mark is the shape and nothing else. How it is painted — the caps, the joins,
the clip to the picture's edge — is decided when the capture is composited, so
that it is not a decision taken once and stored a thousand times.

The server composites onto a capture every scribble that names it, whoever drew
it. A `path` becomes an SVG `path` with round caps and joins, drawn as a curve
through its points; a `point` becomes a cross whose arms reach `width` from it;
both are clipped to the picture. For an `svg` capture the result is inserted before
`</svg>`; for a `png` capture it is rendered over the decoded image, scaled
from `width` and `height` to the image's pixel size. Pass `scribbles: false`
to `get_annotation_capture` to receive the image without any of them.
