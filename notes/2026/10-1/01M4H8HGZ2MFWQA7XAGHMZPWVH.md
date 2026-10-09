---
id: 01M4H8HGZ2MFWQA7XAGHMZPWVH
created: 2026-10-09T21:19:10.818672Z
updated: 2026-10-09T21:19:10.818672Z
type: task
title: 'Move form: any shared mailbox a person holds can be removed (and any shared mailbox added) — the same as manual groups'
task_status: todo
label: bug
priority: high
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 893
---
Found by Steve on staging, 2026-10-09 (`b2e4240a`), smoke-testing COM-891: "It's not currently possible to remove shared mailboxes, this should work like groups."

## What people see today

On a move, **Shared mailboxes (n)** lists what the person can open or send as. Clicking one shows what it is — but for nearly every mailbox there is no **Remove**, only a line saying no role grants it. **Add a shared mailbox** offers a handful at most.

That is the rule COM-891 kept (ADR 0097, from ADR 0076): Compass only changes mailbox access that some role of the company grants. On staging that is 4 kinds of access across 271 shared mailboxes, with 435 people holding access directly — so in practice nothing can be removed.

## What people should see

Shared mailboxes behave as manual groups do on the same form:

- **Remove:** any mailbox access the person holds directly can be removed on a move, whether or not any role grants it. Remove / Restore as now; it shows in **Shared mailbox diff** as a removal and the approver sees it on the request.
- **The one exception, as for groups:** access a role they will still hold gives them has no Remove — the popup says which role, and that taking the role away is how to remove it.
- **Add:** "Add a shared mailbox" offers any shared mailbox of the company, not only ones a role grants. (Steve asked for remove; add is included here because the same rule blocks it and "like groups" covers both — say if add should stay as it is.)
- **Per kind, as now:** "can open" and "can send as" stay separate lines, removed and added separately.
- **After the move:** a mailbox added by name stays through the person's next move (as now); one removed by name stays removed.
- **What doesn't change:** Compass still never takes mailbox access away *by itself* because no role grants it. Only a named change on an approved request does. Access that reaches someone through a group is still not listed.

## How (implementation)

- **This changes an accepted decision — needs a new ADR** that amends ADR 0097 (and narrows ADR 0076's boundary for this one case): a *named* grant on an approved move may be outside the managed set; role-derived reconciliation keeps the managed boundary untouched. State what "outside the managed set" means for drift detection and for the ledger (a named add is already recorded as an exception carrying the request — check an un-mapped mailbox's exception is not then flagged or reverted by `mailbox_grants` detection, and that `standing_exceptions` still carries it through the next move).
- Backend, `core/mailbox_grants.py` `preview_mover`: `removable` is `grant not in desired and grant in managed and …` — drop the `managed` term; `options` is `managed - held - desired` — widen to every shared mailbox of the company × both kinds, minus held and role-desired. 271 mailboxes × 2 is small enough to send, but consider a search endpoint if the payload matters.
- `api/v1/access_requests.py` `_validate_mover_mailbox_grants`: remove the "no role grants it — Compass only changes access a role grants" refusal for a move; keep the others (not a shared mailbox; both add and remove; a role they will hold grants it; already held / not held).
- `tasks/access_execute.py` `_execute_mover`: `manual_joins = (named_joins & managed) - held` and `drop=named_leaves & managed` both intersect with `managed`; and the note "mailbox access refused (not managed by any role)" goes. `plan_mover` / `_apply_mailbox_changes` must accept grants outside the managed set when they are named.
- Check the leaver and joiner paths are **not** widened by accident — this is a move's named changes only. (Whether a leaver should strip un-mapped mailbox access is a separate question; note what it does today on this task.)
- Frontend `access/MoverMailboxes.tsx`: the "no role grants it" explanation and the missing Remove go; the lookup lists the wider set. `RaiseRequestModal.tsx` l.1273 has a description "Only mailboxes some role grants can be requested" on another form — leave unless that form is widened too (it is not, here).
- Tests: `tests/test_mover_mailboxes.py` has cases asserting the refusal and the `removable` flag — rewrite them to the new rule; add one that removes an un-mapped mailbox end to end and one that adds one and sees it survive the next move. `MoverMailboxes.test.tsx` likewise.
- No migration expected. OpenAPI changes only if the preview shape does — run the drift script.

## Done when

- [ ] ADR written and linked from ADR 0097.
- [ ] On a move, every directly-held mailbox access has Remove unless a role they keep gives it.
- [ ] "Add a shared mailbox" offers any shared mailbox of the company.
- [ ] An un-mapped mailbox removed on a move is gone from Exchange after it runs, and the request's record says so.
- [ ] An un-mapped mailbox added on a move is still there after the person's next move, and nothing flags or reverts it in between.
- [ ] Role-derived mailbox changes, leavers and joiners behave exactly as before.
- [ ] Checked on staging against a real mailbox no role grants.