---
id: 01M1VWDST8J0BBX2BNK2ACBC4T
created: 2026-09-06T17:31:59.176575Z
updated: 2026-09-06T17:32:02.46234Z
type: task
title: a proposed decision can retire an accepted one — superseding must mean accepted
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 597
sprint: s2fcksg
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
Writing a superseding decision defaults it to **accepted**, which is right and deliberate: you record a supersession, you do not float one. The status stays a picker, though, and the server does not care what it says.

`POST /decisions` retires the superseded record the moment the new one is saved, unconditionally:

```python
superseded.status = DecisionStatus.superseded
superseded.superseded_by = record.id
```

So change the picker to **proposed** and ADR 12 is retired on the spot while its replacement is only a proposal — the playbook now has nothing in force on that subject, and neither screen says so. Choose **declined** and it is worse: an accepted decision is retired in favour of one that was explicitly rejected. There is no way back, either: supersession happens only at creation (`DecisionUpdate` does not accept `supersedes`), so no later edit restores the old record.

## Fix — superseding means accepted

Decided (Steve, 2026-09-06) in preference to deferring the retirement until the replacement is accepted. That alternative suits a workflow where a superseding ADR circulates for agreement before taking effect; that is not how decisions are made here, and it needs the accept transition to carry the supersession, which is real machinery for a case that does not arise.

- [ ] **Server:** if `supersedes` is set, the new record is `accepted`. Refuse anything else with a clear message rather than silently overriding it — a client that asks for something the model does not allow should be told.
- [ ] **Dialog:** when Supersedes is set, the status picker shows `accepted` and is disabled, with a line saying a superseding decision is one that has been made. Mirrors COM-590's treatment of residual scoring — show the field, explain why it is fixed, do not hide it.
- [ ] The reverse holds too: setting a status other than accepted should not silently clear Supersedes. One of the two is what the author meant; the form should not guess.
- [ ] Tests: a create with `supersedes` and `status=proposed` is refused; the superseded record is untouched when the create fails.

## Not in scope

Any decision already retired by a proposed or declined replacement. Staging data only, and the same call as COM-590 — no repair.

## Related

- COM-578 — where accepted-by-default came from, and why it was right.
- COM-589 — the dialog the picker now lives in.
- ADR 0001 — append-only, supersede-not-rewrite. The rule this protects.
