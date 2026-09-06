---
id: 01M1TZSSWHZJJS4JVN4T8EZSVY
created: 2026-09-06T09:11:43.761034Z
updated: 2026-09-06T09:11:43.761034Z
type: task
title: 'raising a gap: the control ref, a blank description, and an assignee'
label: improvement
priority: medium
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 577
---
Raised by Steve, 2026-09-06, alongside COM-576. Kept separate because it is the **raise-gap dialog**, not the gap page — a different screen and a different change, though they belong to the same conversation.

Today the dialog opens with both fields already written for you, by a suggestion the server composes:

- title — *"Close gap: INS.1 Access reviews are performed quarterly"*
- description — *"Control INS.1 is partial. Plan and track remediation to closure."*

The description is boilerplate: it restates the control reference and the status, both of which are on the screen already, and tells the reader to plan and track remediation — which is what a gap *is*. Prefilled text that says nothing is worse than an empty box, because it survives. Somebody in a hurry accepts it, and the register fills with rows that all say the same thing.

## What changes

- **Title prefilled with the control reference and nothing else** — `INS.1: ` — with the cursor after it. The reference is what a gap is always filed under; the rest is the sentence only the assessor can write.
- **Description starts blank.** Its placeholder can invite what belongs there; the field itself stays empty.
- **An assignee on the dialog**, so a gap can be given to somebody at the moment it is raised rather than left unowned and chased later. The list is whoever holds `posture.manage_gaps`, per the rule settled in COM-575 — this needs that task's picker and its "who holds this permission" endpoint, so it stacks behind it.
  - Suggest defaulting to the **assessment's owner** and letting it be changed: whoever owns the control is the likeliest person to own its remediation, and the server's suggestion already works this out and hands it over today (the dialog throws it away). Say if you would rather it started empty.

## The suggestion endpoint

With the description gone and the title reduced to a reference the panel already knows, `GET /gaps/suggestion` has nothing left to contribute — its third field, the owner, has never been used. It is a round trip on every dialog open, and it refuses with a 422 when the assessment is not a shortfall.

Retiring it is the tidy end of this, but it is a public `/api/v1` endpoint (ADR 0004), so it goes through the front door: check nothing else calls it, remove it deliberately, regenerate the schema. Do not leave it in place unused — a suggestion endpoint that no longer matches what the dialog does is a trap for whoever reads it next.

## Related

- COM-576 — a gap has no page. Same conversation, other end of the gap's life.
- COM-575 — the owner picker and the permission rule this borrows.
