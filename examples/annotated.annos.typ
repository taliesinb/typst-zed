// typst-annos v1 — annotation sidecar, edited by humans, tinymist, and agents.
//
// AGENTS: do not hand-edit this file, use the `tinymist` MCP tool to list
// annotations, claim them, add to discussions, and edit the corresponding document.

// Each entry is one annotation, anchored to a cursor label like
// <anno.7C42.math> placed in the document source at the annotated text. The
// entry itself is labeled <anno.7C42>, so one plain search for `<anno.7C42`
// finds both, and `<anno.` finds every annotation in a file.
// Entry shape:
//
//   #metadata((
//     type: str,        // "comment" | "question" | "request"
//     uuid: str,        // e.g. "7C42", matches the anchor id in <anno.7C42.math>
//     scope: str,       // e.g. "math", matches the anchor suffix in <anno.7C42.math>
//     color: str,       // the colour it is drawn in, e.g. "#faa39c"
//     letter: str,      // display letter on the pin: "a".."z", "aa", ...
//     author: str,      // who created it, e.g. "tali" or "claude"
//     content: str,     // the message
//     time: str,        // when it was made, ISO 8601 UTC, e.g. "2026-08-11T01:12:40Z"
//     mtime: str,       // when it last changed: a reply, a flag, a capture
//     claimed: bool,    // somebody is working on it
//     resolved: bool,   // it is done; still drawn, dimmed, until deleted
//     captures: (),     // for graphical annotations, what the thing it points at
//                       // has looked like, oldest first, each:
//                       // (time: str, fmt: str, hash: str,
//                       //  width: int, height: int, markup: str?)
//                       // fmt is how it is stored ("svg" today); width and height
//                       // are its size on the page in CSS pixels; markup is what
//                       // the reader drew on top, as inline SVG. Ask the MCP tool
//                       // `get_capture` for the picture itself.
//     discussion: (),   // ordered replies, each:
//                       // (author: str, time: str, content: str)
//   )) <anno.7C42>
#metadata((
  type: "comment",
  uuid: "A100",
  scope: "word",
  color: "#faa39c",
  letter: "a",
  author: "tali",
  content: "The title annotation: the first pin in the document, and the one that proves the letters start at A.",
  time: "2026-08-14T09:10:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.A100>
#metadata((
  type: "comment",
  uuid: "T001",
  scope: "block",
  color: "#5ed1de",
  letter: "b",
  author: "tali",
  content: "Is this table complete? I count thirteen scopes in the source but only twelve rows.",
  time: "2026-08-14T09:11:00Z",
  mtime: "",
  claimed: false,
  resolved: true,
  captures: (),
  discussion: (
    (author: "claude", time: "2026-08-14T09:31:00Z", content: "Counted them: span.begin and span.end share one row, which is why the table looks one short. Left as it is, since they are one annotation."),
  ),
)) <anno.T001>
#metadata((
  type: "comment",
  uuid: "C300",
  scope: "item",
  color: "#d1be6c",
  letter: "c",
  author: "tali",
  content: "Worth saying what “re-resolve” means here — resolved against what?",
  time: "2026-08-14T09:12:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.C300>
#metadata((
  type: "comment",
  uuid: "31CA",
  scope: "word",
  color: "#acb8ff",
  letter: "d",
  author: "tali",
  content: "Could this sentence give an example of an orphan rather than only naming one?",
  time: "2026-08-14T09:13:00Z",
  mtime: "",
  claimed: true,
  resolved: false,
  captures: (),
  discussion: (
    (author: "claude", time: "2026-08-14T09:33:00Z", content: "Working on it. An orphan is easiest to show by deleting an anchor and leaving the entry, so I will add that as its own subsection."),
  ),
)) <anno.31CA>
#metadata((
  type: "comment",
  uuid: "B12A",
  scope: "word",
  color: "#73d4b2",
  letter: "e",
  author: "tali",
  content: "Typo check: “an anchor” reads oddly split across two annotations here.",
  time: "2026-08-14T09:14:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.B12A>
#metadata((
  type: "comment",
  uuid: "H001",
  scope: "item",
  color: "#f1a2c8",
  letter: "f",
  author: "tali",
  content: "A heading annotated as an item: the ring goes around the heading's own number.",
  time: "2026-08-14T09:15:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.H001>
#metadata((
  type: "comment",
  uuid: "W001",
  scope: "word",
  color: "#efae76",
  letter: "g",
  author: "tali",
  content: "The plainest kind: one word, one underline.",
  time: "2026-08-14T09:16:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.W001>
#metadata((
  type: "comment",
  uuid: "P001",
  scope: "point",
  color: "#7dc7fb",
  letter: "h",
  author: "tali",
  content: "A caret between two words, for “something belongs here”.",
  time: "2026-08-14T09:17:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.P001>
#metadata((
  type: "comment",
  uuid: "S001",
  scope: "span",
  color: "#a3cd86",
  letter: "i",
  author: "tali",
  content: "A span that fits on one line.",
  time: "2026-08-14T09:18:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.S001>
#metadata((
  type: "comment",
  uuid: "S002",
  scope: "span",
  color: "#d5aaee",
  letter: "j",
  author: "tali",
  content: "Does a span still work when it wraps across several lines?",
  time: "2026-08-14T09:19:00Z",
  mtime: "",
  claimed: false,
  resolved: true,
  captures: (),
  discussion: (
    (author: "claude", time: "2026-08-14T09:39:00Z", content: "It does: every line the span covers gets its own underline, and they are drawn as one annotation. This example is here to prove it."),
  ),
)) <anno.S002>
#metadata((
  type: "comment",
  uuid: "X001",
  scope: "sentence",
  color: "#faa39c",
  letter: "k",
  author: "tali",
  content: "Sentence scope: the whole sentence, found by looking outwards from the label.",
  time: "2026-08-14T09:20:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.X001>
#metadata((
  type: "comment",
  uuid: "X002",
  scope: "para",
  color: "#5ed1de",
  letter: "l",
  author: "tali",
  content: "Paragraph scope draws a frame rather than an underline, since a paragraph is a region.",
  time: "2026-08-14T09:21:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.X002>
#metadata((
  type: "comment",
  uuid: "R001",
  scope: "raw",
  color: "#d1be6c",
  letter: "m",
  author: "tali",
  content: "Raw text: the code fragment before the label, not the words around it.",
  time: "2026-08-14T09:22:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.R001>
#metadata((
  type: "comment",
  uuid: "K001",
  scope: "link",
  color: "#acb8ff",
  letter: "n",
  author: "tali",
  content: "Should a link annotation follow the link when the URL changes?",
  time: "2026-08-14T09:23:00Z",
  mtime: "",
  claimed: true,
  resolved: false,
  captures: (),
  discussion: (
    (author: "claude", time: "2026-08-14T09:43:00Z", content: "It follows the text, not the URL: the anchor sits after the link element, so editing the address leaves the annotation where it was."),
  ),
)) <anno.K001>
#metadata((
  type: "comment",
  uuid: "N001",
  scope: "inline",
  color: "#73d4b2",
  letter: "o",
  author: "tali",
  content: "Inline scope catches whatever a helper produced — here, a coloured run.",
  time: "2026-08-14T09:24:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.N001>
#metadata((
  type: "comment",
  uuid: "M001",
  scope: "math",
  color: "#f1a2c8",
  letter: "p",
  author: "tali",
  content: "Inline maths: the equation before the label, underlined like a word.",
  time: "2026-08-14T09:25:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.M001>
#metadata((
  type: "comment",
  uuid: "M002",
  scope: "math.block",
  color: "#efae76",
  letter: "q",
  author: "tali",
  content: "A block equation is a region, so it gets a frame.",
  time: "2026-08-14T09:26:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.M002>
#metadata((
  type: "comment",
  uuid: "I001",
  scope: "item",
  color: "#7dc7fb",
  letter: "r",
  author: "tali",
  content: "A plain bullet, annotated as an item.",
  time: "2026-08-14T09:27:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.I001>
#metadata((
  type: "comment",
  uuid: "I002",
  scope: "item",
  color: "#a3cd86",
  letter: "s",
  author: "tali",
  content: "A nested bullet is its own item, not part of the one above it.",
  time: "2026-08-14T09:28:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.I002>
#metadata((
  type: "comment",
  uuid: "I003",
  scope: "item",
  color: "#d5aaee",
  letter: "t",
  author: "tali",
  content: "The first item of an enumeration.",
  time: "2026-08-14T09:29:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.I003>
#metadata((
  type: "comment",
  uuid: "I004",
  scope: "item",
  color: "#faa39c",
  letter: "u",
  author: "tali",
  content: "Does the ring go around the number or the text for nested enumerations?",
  time: "2026-08-14T09:30:00Z",
  mtime: "",
  claimed: false,
  resolved: true,
  captures: (),
  discussion: (
    (author: "claude", time: "2026-08-14T09:50:00Z", content: "Around the number: the marker is what identifies the item, and it sits in the padding its list reserves."),
  ),
)) <anno.I004>
#metadata((
  type: "comment",
  uuid: "I005",
  scope: "item",
  color: "#5ed1de",
  letter: "v",
  author: "tali",
  content: "A term list: the annotation is on the definition, not the term.",
  time: "2026-08-14T09:31:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.I005>
#metadata((
  type: "comment",
  uuid: "G001",
  scope: "svg",
  color: "#d1be6c",
  letter: "w",
  author: "tali",
  content: "The drawing inside the figure, annotated on its own.",
  time: "2026-08-14T09:32:00Z",
  mtime: "2026-08-14T19:32:10Z",
  claimed: false,
  resolved: false,
  captures: (
    (
      time: "2026-08-14T15:30:22Z",
      fmt: "svg",
      hash: "58488271b7fc45fc",
      width: 499,
      height: 147,
    ),
    (
      time: "2026-08-14T19:32:10Z",
      fmt: "svg",
      hash: "489b016d01ac9e98",
      width: 349,
      height: 147,
    ),
  ),
  discussion: (),
)) <anno.G001>
#metadata((
  type: "comment",
  uuid: "W002",
  scope: "word",
  color: "#acb8ff",
  letter: "x",
  author: "tali",
  content: "A word inside a caption is annotated like any other word.",
  time: "2026-08-14T09:33:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.W002>
#metadata((
  type: "comment",
  uuid: "F001",
  scope: "block",
  color: "#73d4b2",
  letter: "y",
  author: "tali",
  content: "The figure as a whole, caption included.",
  time: "2026-08-14T09:34:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.F001>
#metadata((
  type: "comment",
  uuid: "T002",
  scope: "word",
  color: "#f1a2c8",
  letter: "z",
  author: "tali",
  content: "One cell of a table.",
  time: "2026-08-14T09:35:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.T002>
#metadata((
  type: "comment",
  uuid: "T003",
  scope: "block",
  color: "#efae76",
  letter: "aa",
  author: "tali",
  content: "And the table as a whole, which is the frame around all of it.",
  time: "2026-08-14T09:36:00Z",
  mtime: "",
  claimed: false,
  resolved: false,
  captures: (),
  discussion: (),
)) <anno.T003>
#metadata((
  type: "question",
  uuid: "D001",
  scope: "svg",
  color: "#7bd88f",
  letter: "ab",
  author: "tali",
  content: "Does a drawing from a package capture the same way a hand-placed one does?",
  time: "2026-08-14T09:37:00Z",
  mtime: "2026-08-14T19:32:10Z",
  claimed: false,
  resolved: false,
  captures: (
    (
      time: "2026-08-14T19:32:10Z",
      fmt: "svg",
      hash: "8ecd77eafef93d5f",
      width: 121,
      height: 101,
    ),
  ),
  discussion: (),
)) <anno.D001>
