---
id: 01M1VHMPWDANJVE40RAF8M8VNJ
created: 2026-09-06T14:23:31.213544Z
updated: 2026-09-06T14:23:33.95962Z
type: task
title: a gap's title and description can be read but never corrected
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 588
sprint: s2fcksg
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
The gap page shows the title as a heading and the description as prose, and neither can be edited. Owner, status and target date each have a real control on the same page; the two fields that say what the gap *is* have none.

There is nowhere else to do it either. The raise dialog (COM-577) is the only screen in the app that writes a gap's title or description, so both are set once, at the moment the gap is raised, and are frozen from then on. A typo in the title, or a description that turns out to describe the wrong shortfall, cannot be corrected — the gap has to be destroyed and raised again, losing its history.

This is the other half of what COM-576 set out to fix. That task's own note calls the description "write-only" — saved, and then never rendered anywhere — and the page fixed the reading. The writing is still missing: you can now see the sentence somebody typed, and still cannot change a word of it.

## What is needed

No backend work. `GapUpdate` already accepts `title` and `description`, and the page already holds a `PATCH /api/v1/gaps/{gap_id}` mutation — status, owner and target date all save through it.

- [ ] The title becomes editable in place in the page header, saving through the existing mutation. Keep the status pill beside it.
- [ ] The description card gains an edit affordance — a textarea, saving the same way. Preserve the `pre-wrap` rendering when it is not being edited: the line breaks somebody typed are part of what they wrote.
- [ ] Both gated on `posture.manage_gaps`, like every other control on the page; a reader sees the text and no affordance.
- [ ] An empty title is refused (the API's `min_length=1` would reject it anyway — it should not get that far).

Follow the editor conventions COM-578 settled rather than inventing a third pattern.

## Related

- COM-576 — the page this completes.
- COM-577 — the raise dialog, currently the only writer of these two fields.
- COM-578 — one editor, three entry points.
