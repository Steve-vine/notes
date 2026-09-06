---
id: 01M1VWDST8J0BBX2BNK2ACBC4T
created: 2026-09-06T17:31:59.176575Z
updated: 2026-09-06T17:35:19.836315Z
type: task
title: a supersession runs from an accepted decision to an accepted decision — neither end is enforced
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 597
sprint: s2fcksg
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
A supersession should run **from** an accepted decision **to** an accepted decision. Neither end is enforced today, and each failure loses something different.

## The new decision's end

Writing a superseding decision defaults it to **accepted**, which is right and deliberate: you record a supersession, you do not float one. The status stays a picker, though, and the server does not care what it says. `POST /decisions` retires the superseded record the moment the new one is saved, unconditionally:

```python
superseded.status = DecisionStatus.superseded
superseded.superseded_by = record.id
```

Change the picker to **proposed** and ADR 12 is retired on the spot while its replacement is only a proposal — the playbook now has nothing in force on that subject, and neither screen says so. Choose **declined** and an accepted decision is retired in favour of one that was explicitly rejected. There is no way back either: supersession happens only at creation (`DecisionUpdate` does not accept `supersedes`), so no later edit restores the old record.

## The superseded decision's end

**Supersede this** appears on every decision whatever its status, and the Supersedes picker lists the whole register unfiltered. So:

- **A proposal can be superseded.** It was never in force, so there is nothing to retire. If it is still a draft, edit it — ADR 0001's append-only rule protects *accepted* records from being rewritten, and a proposal has not been agreed. If it was considered and rejected, decline it and propose its replacement: two records, both true.
- **A declined decision can be superseded** — retiring something already rejected.
- **An already-superseded decision can be superseded again**, which overwrites its `superseded_by` pointer and quietly forgets the record that actually replaced it. That is the append-only rule being broken by the feature that exists to uphold it.

The intent was always accepted-only — the comment beside the button says "superseding an accepted decision is the act ADR governance exists for". Only the gating is missing.

## Fix

Decided (Steve, 2026-09-06) in preference to deferring the retirement until the replacement is accepted. That alternative suits a workflow where a superseding ADR circulates for agreement before taking effect; that is not how decisions are made here, and it needs the accept transition to carry the supersession — real machinery for a case that does not arise.

- [ ] **Server:** refuse a create where `supersedes` is set and the new record's status is not `accepted`, and refuse one where the target is not `accepted`. Refuse with a clear message rather than silently correcting — a client asking for something the model does not allow should be told.
- [ ] **Dialog:** with Supersedes set, the status picker shows `accepted` and is disabled, with a line saying a superseding decision is one that has been made. Mirrors COM-590's treatment of residual scoring — show the field, explain why it is fixed, do not hide it.
- [ ] Setting a status other than accepted must not silently clear Supersedes. One of the two is what the author meant; the form should not guess.
- [ ] **Decision page:** "Supersede this" appears only on an accepted decision. On a proposal, Edit is the answer; on a declined or already-superseded record, neither applies.
- [ ] **Picker:** Supersedes lists accepted decisions only.
- [ ] Tests: a create with `supersedes` + `status=proposed` is refused; a create superseding a proposed, declined or already-superseded record is refused; in every refusal the target record is untouched.

## Not in scope

Any decision already retired by a proposed or declined replacement, or any `superseded_by` pointer already overwritten. Staging data only, and the same call as COM-590 — no repair.

## Related

- COM-578 — where accepted-by-default came from, and why it was right.
- COM-589 — the dialog the picker now lives in.
- ADR 0001 — append-only, supersede-not-rewrite. The rule this protects at both ends.
