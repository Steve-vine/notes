---
id: 01M1TTQHTH2CAH6E616SJYBB04
created: 2026-09-06T07:43:07.089275Z
updated: 2026-09-06T09:44:38.886173Z
type: task
title: attaching evidence to a control you have not saved yet
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 569
sprint: s2fcksg
comments:
- id: 01M1V1P286ZD0NR3SCBDJ9QDVN
  author: Steve Vine
  at: 2026-09-06T09:44:38.406361Z
  text: |-
    Done — PR #583, merged to main.

    The panel holds the chosen file and the save that creates the record uploads it, so attaching and saving read as one act. The button says **Choose file**, not Upload file — nothing is sent until there is something to send it to, and a button claiming otherwise would be the same kind of lie the old message was. The file is named, removable, and says "Attached when you save the assessment."

    Both the careful bits are covered by a test:

    - **The pending file counts as unsaved work**, so the COM-543 guard asks about it — tested against the browser's own leave-site prompt, armed by the file alone with nothing typed.
    - **A failed upload after a successful save keeps the assessment.** It refreshes first, so the panel stops offering to create a record that now exists, then says exactly what happened — *"The assessment was saved, but the file was not attached: Unsupported file type. It is still selected — try again."* — and fails loudly enough that Save and continue leaves you here with the file.

    Not create-on-open, for the reason you gave.

    One implementation note worth having: the raw upload is now a plain function alongside the existing hook, because this call site only learns the assessment id at the moment of the save. The hook is unchanged for its existing caller.

    Four new tests; frontend suite green at 1004.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Raised by Steve, 2026-09-06, after asking whether the missing upload button was by design. It is — and it says so, *"Save the assessment to attach evidence files."* This is about the seam it leaves, not about a defect.

## The seam

On a control that has never been assessed, the panel offers two ways to record evidence and only one of them works:

- **Evidence links** — part of the form. Type one straight away; it saves with everything else.
- **Evidence files** — not available. A file has to be attached to a record, and there is no record until the first save.

Nothing on the screen explains why one is offered and the other withheld, and the reason is invisible to the person: it is not about the status they have or have not set, it is about whether a row exists yet. So the message reads as a rule about assessing when it is really a rule about saving.

It lands in the middle of the job. Assessing a control is *look at the evidence, then judge it* — the file is often the thing you are holding when you arrive, and being told to come back for it after saving inverts the order of the work.

## What changes

The panel holds a chosen file and uploads it once the first save has created the record, so attaching and saving read as one act. Before the first save the button is offered like any other field, with the file named and removable; the save creates the assessment and the upload follows it.

Worth being careful about two things:

- **A failed upload after a successful save.** The assessment is created and the file is not — say so plainly and leave the file selected to retry. Do not roll the assessment back; a saved judgement is worth keeping.
- **Leaving without saving** discards the pending file along with the rest of the form, which the unsaved-changes guard already asks about (COM-543). The file should count as unsaved work for that prompt, or somebody will lose one to a Discard they read as being about the notes.

## What not to do

**Do not create the assessment record when the control is opened.** It looks like the simpler fix and it is worse: every control anybody merely looked at would appear in the register as an assessment, and once COM-566 lands it would be stamped as reviewed today. An empty record is a claim, and browsing is not assessing.

## Related

- COM-566 — saving stamps the review dates, which is what makes create-on-open unacceptable rather than just untidy.
- COM-543 — the unsaved-changes guard the pending file has to join.
- COM-564 / COM-565 / COM-568 — the same panel.
