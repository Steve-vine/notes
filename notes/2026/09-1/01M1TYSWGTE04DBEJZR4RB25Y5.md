---
id: 01M1TYSWGTE04DBEJZR4RB25Y5
created: 2026-09-06T08:54:17.882445Z
updated: 2026-09-06T08:54:22.121532Z
type: task
title: work can be taken but never given — there is no way to assign anything to a colleague
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 575
sprint: s2fcksg
assignee: steve
label:
- feature
priority: high
task_status: backlog
---
Found by Steve on staging, 2026-09-06, on the assessment panel — and it is not confined to controls.

**Nothing in Compass can be assigned to another person.** Every ownership control in the app offers exactly two things: *Assign to me*, and clear. You can claim work or drop it; you cannot give it to a colleague. Accountability has to be volunteered.

That is the case on the **assessment panel** (Steve's report), on a **risk** in two places, and on a **vendor** in two more. **Gaps are worse**: the Gaps screen shows an owner column and offers no way to change it at all, not even to yourself — status and target date are editable there, ownership is read-only.

**The API has always supported it.** Assessments, gaps and risks all accept any user as the owner, on create and on update. This is a missing picker, not a missing capability — which is why it is one task rather than five.

## Why this matters more than it looks

Ownership is not decoration here. The Actions queue has an Owner column and an "Owned by me" filter; the nightly mail chases owners by name; unowned work is attributed to a whole module precisely because nobody has taken it (ADR 0055 §4). The entire chasing apparatus assumes somebody can be made accountable for a piece of remediation — and today the only person who can do that is the person volunteering.

For a governance tool, "the manager cannot assign the remediation" is close to the centre of the job.

## What changes

One shared owner picker, used everywhere ownership is shown:

- **The assessment panel** — the reported case, and the one to build against.
- **Risk detail** (two places), **vendor detail** (two places) — the same three lines each; do them in the same pass or the identical complaint arrives one screen later.
- **The Gaps screen** — needs an assign control where today there is none.

*Assign to me* stays. It is the common case and it is one click; a picker that makes claiming your own work a three-step search would be a downgrade.

## The one real decision

**Who appears in the list.** The existing user picker (used for content owners) returns every user, and that is wrong here — a vendor contact or portal user must not become the owner of a control assessment. The list should be internal accounts that can actually hold the work, active ones only. Worth settling deliberately rather than reaching for the existing hook: getting it wrong puts an external contact's name against a company's governance record.

Assigning work to somebody is also a thing they should learn about. Whether that means a notification is a judgement call — the actions queue and the digest already carry newly-owned work to its owner, so it may be covered. Check before adding a second channel.

## Related

- ADR 0055 §4 — unowned work is real work; ownership is what the chasing hangs on.
- COM-564 / COM-566 / COM-568 / COM-569 / COM-570 — the same panel.
