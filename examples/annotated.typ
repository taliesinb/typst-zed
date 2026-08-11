= Annotated example

This document demonstrates preview annotations. Open it in Zed, run the
*Typst: Preview* task (cmd-alt-p), and try the following:

- *Alt-click* any word to attach a new comment. The anchor label lands in
  this file (on disk when the buffer is clean), and the record lands in
  `annotated.annos.typ` next to it.
- Click a numbered bubble in the right margin to read a comment, reply to
  it, resolve or reopen it, or delete it.
- Edit `annotated.annos.typ` by hand (or let an agent do it): flip a
  `status` to `"resolved"`<-7C42-> and watch the bubble turn gray within a
  couple of seconds — no recompile needed.

== A section with an existing thread

The paragraph you are reading carries an annotation created earlier, with a
reply already in its discussion<-F00D-> thread. Its anchor is the invisible
label right after the word "discussion".

Deleting an anchor label from this file simply hides the corresponding
bubble; the record in the sidecar remains, harmlessly orphaned, until you
delete it too.
