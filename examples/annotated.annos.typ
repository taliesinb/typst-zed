// typst-annos v1 — annotation sidecar, edited by humans, tinymist, and agents.
//
// Each entry is one annotation, anchored to a cursor label like <-7C42->
// placed in the document source at the annotated text. The entry itself is
// labeled <note-7C42>. Entry shape:
//
//   #metadata((
//     type: str,        // "comment" | "question" | "request"
//     uuid: str,        // "7C42", matches the anchor label <-7C42->
//     letter: str,      // display letter on the pin: "a".."z", "aa", ...
//     author: str,      // who created it, e.g. "tali" or "agent"
//     content: str,     // the message
//     time: str,        // ISO 8601 UTC, e.g. "2026-08-11T01:12:40Z"
//     status: str,      // "created" | "ongoing" | "resolved"
//     discussion: (),   // ordered replies, each:
//                       //   (author: str, time: str, content: str)
//   )) <note-7C42>
//
// Rules for agents:
// - Read this file with `typst query <file> metadata` — it returns every
//   entry as JSON. tinymist reads it the same way (by evaluation), so
//   entries may use any valid Typst, not just literal dicts; only keep the
//   trailing <note-XXXX> label directly after an entry's closing `))`.
// - Reply by appending to `discussion`; never edit another author's text.
// - Flip `status` to "ongoing" while addressing an entry and "resolved"
//   when done. The preview renders resolved annotations gray.
// - Do not touch `type`, `label`, `author`, `content`, or `time` of
//   existing entries.
// - Typst syntax notes: an empty array is (); a one-element array of dicts
//   needs a trailing comma: ((author: "x", ...),).
// - Find an anchor's position with `typst query main.typ "<-7C42->"`;
//   deleting an entry or its anchor orphans the other half harmlessly.

#metadata((
  type: "comment",
  uuid: "A100",
  letter: "a",
  author: "tali",
  content: "title anchor — first pin in the document",
  time: "2026-08-11T09:00:00Z",
  status: "created",
  discussion: (),
)) <note-A100>

#metadata((
  type: "question",
  uuid: "B200",
  letter: "b",
  author: "tali",
  content: "should the caret glyph scale with the surrounding font size?",
  time: "2026-08-11T09:05:00Z",
  status: "ongoing",
  discussion: (
    (
      author: "agent",
      time: "2026-08-11T09:20:00Z",
      content: "it is fixed at ~10pt now; scaling needs the glyph size from the frame, doable",
    ),
  ),
)) <note-B200>

#metadata((
  type: "comment",
  uuid: "C300",
  letter: "c",
  author: "tali",
  content: "anchored on a bullet item",
  time: "2026-08-11T09:10:00Z",
  status: "created",
  discussion: (),
)) <note-C300>

#metadata((
  type: "request",
  uuid: "D400",
  letter: "d",
  author: "tali",
  content: "make the middle square a bit larger and match the circle height",
  time: "2026-08-11T09:15:00Z",
  status: "ongoing",
  discussion: (),
)) <note-D400>

#metadata((
  type: "comment",
  uuid: "E500",
  letter: "e",
  author: "tali",
  content: "mid-document anchor: watch me hop between the top and bottom stacks",
  time: "2026-08-11T09:25:00Z",
  status: "created",
  discussion: (),
)) <note-E500>

#metadata((
  type: "comment",
  uuid: "F600",
  letter: "f",
  author: "tali",
  content: "nested bullet anchor",
  time: "2026-08-11T09:30:00Z",
  status: "resolved",
  discussion: (
    (
      author: "agent",
      time: "2026-08-11T09:45:00Z",
      content: "verified nested list anchors resolve correctly",
    ),
  ),
)) <note-F600>

#metadata((
  type: "request",
  uuid: "G700",
  letter: "g",
  author: "tali",
  content: "the B-to-C edge should attach to the circle borders, not float nearby",
  time: "2026-08-11T09:35:00Z",
  status: "created",
  discussion: (),
)) <note-G700>

#metadata((
  type: "comment",
  uuid: "H800",
  letter: "h",
  author: "tali",
  content: "final page anchor — everything else should be stacked by now",
  time: "2026-08-11T09:40:00Z",
  status: "resolved",
  discussion: (),
)) <note-H800>
