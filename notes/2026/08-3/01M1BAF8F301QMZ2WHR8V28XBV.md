---
id: 01M1BAF8F301QMZ2WHR8V28XBV
created: 2026-08-31T07:10:21.667219Z
updated: 2026-08-31T07:55:21.788219Z
type: task
title: A leaver request runs at a stated time, notes the account, and can delete it after a set number of days
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 546
sprint: sz42uhw
assignee: steve
company: null
label:
- feature
priority: medium
task_status: backlog
---
Today an approved leaver request executes the moment the approver approves it, disables the account and stops there. Three additions: say **when** it should run, write a **note on the account** as it goes, and optionally **delete the account** a stated number of days later.

## 1 — Run at a stated time

- Raising a leaver request, the requester can give a date and time to run it. Leaving it empty keeps today's behaviour — approval executes immediately — and that stays the default.
- Approving a scheduled request doesn't touch the directory. The request reads as **Scheduled**, showing when it will run, and the approval is already recorded.
- Between approval and the run it can be cancelled, exactly as an approved request can be now. The time can also be changed; who changed it and when is on the record like every other decision on the request.
- At the stated time it executes exactly as it does now: same disable, same session revoke, same group removal, same ledger rows, same failure and retry behaviour. The request shows the time it was meant to run and the time it actually ran.
- Times are the requester's local wall clock, stored in UTC. Firing is checked every five minutes, so "17:00" means within five minutes of five — a leaver's access shouldn't wait a quarter of an hour.
- If Compass was down when the time passed, the request still runs when it comes back, however late, with the delay visible. A leaver whose access removal is skipped because a worker was restarting is the worse failure.
- **Standard approval only.** Expedited is break-glass — "do it now and justify it after" — and a scheduled break-glass request is a contradiction. The field isn't offered there.

## 2 — A note written onto the account

- The leaver form shows the account's current description and lets the requester write a new one — "Left 31 Aug 2026, disabled under COM-nnn" — approved along with the rest of the request.
- The new text is written at the same moment the account is disabled, in the same run, and lands in the change ledger beside the disable. If the write fails, the disable still stands: the account being open is the risk, the note is not.
- Left untouched, nothing is written and the existing description stays as it is.

**Open question — which field is "description"?** Microsoft Graph's user resource has no `description` property (groups have one; users don't), and Compass mirrors no such field today. The candidates are `officeLocation`/`jobTitle` (real user fields, but they mean something else), `onPremisesExtensionAttributes.extensionAttributeN` (the usual home for this, **read-only through Graph for accounts synced from on-prem AD** — writable only for cloud-only accounts), or a genuine on-prem AD `description`, which Compass cannot write at all and which AD sync would overwrite. **Confirm with Steve where he sees this field today before building it** — if the accounts are AD-synced, this half may not be possible through Graph, and the note would have to live on the Compass record instead.

## 3 — Delete after N days

- A toggle on the leaver form: delete the account afterwards, after a stated number of days. **0 means delete in the same run as the disable.** Off by default — a disabled account stays the recoverable end state unless somebody asks for otherwise.
- The approver sees and approves the whole thing at once: "disable now, delete in 30 days". No second approval when the day comes; the decision was made here.
- The clock starts at the actual disable, not at the scheduled time — a run that fires late doesn't shorten the window.
- While the deletion is pending, the request shows the date it will happen and **the deletion can be cancelled** — someone comes back, or it was raised in error. Cancelling leaves the account disabled and the leaver request itself untouched; it stays executed.
- Deleting removes the account from the directory. It sits in the tenant's recycle bin for 30 days, restorable, then it is gone permanently — along with the ability to show what it held. The screen should say this where the toggle is, not bury it.
- An account Compass is not allowed to delete — a privileged or protected object — is **refused** and recorded as refused, the same as any other protected-object refusal. It never fails silently and never half-happens.

## Decisions

**No new "scheduled request" type** — this is one nullable `scheduled_for` on `access_requests`, which every kind already shares. Joiner, mover, membership change and the rest get the capability at the data and API layer for free, and only the leaver screen exposes it now. A separate entity would duplicate the whole JML lifecycle — subjects, approval gates, execution path, ledger, audit — and split the record of an access change across two places. When you want scheduled joiners ("starts Monday"), that's a screen change, not a new spine.

**No new status value.** "Scheduled" is derived from *approved + a future `scheduled_for`*, not a seventh state in the lifecycle. `status` keeps meaning where the request is in approval; the transitions map and the enum are untouched (and a new enum value on a live database is its own migration trap — see the Alembic enum notes). A pending deletion is likewise derived from an executed request with a delete date in the future.

**The pending delete rides the same sweeper** as the scheduled execution — one beat job, two kinds of due work, rather than a second scheduler.

**Before offering scheduling to other kinds** — leaver execution re-reads the account and its live memberships from the directory at the moment of the write, so a delay of hours or days doesn't act on stale data. Joiner and mover carry the business roles chosen at request time on the subject row; those *can* drift between approval and a delayed run. That question needs answering before the field is offered for those kinds — it is not a blocker for leaver.

## Implementation

- `models/access_request.py`: `scheduled_for`, `delete_after_days: int | None`, `delete_due_at`, `deleted_at_directory` (or the equivalent on the subject, where per-subject outcomes already live), and the new description text. Partial indexes on the two "due" queries so each sweep pass is cheap.
- New `AccessChangeKind.user_deleted`, and a `user_updated` ledger row for the description write. Both hang off the existing subject outcomes so one failure never poisons the batch.
- `api/v1/access_requests.py`: accept the new fields on create and gate edit; validate `scheduled_for` is in the future, the mode is standard, and `delete_after_days >= 0`. `approve_request` fires `execute_access_request.delay(...)` only when there is no scheduled time. Add cancel-the-pending-deletion, permitted to anyone who can write access, and audited.
- `tasks/access_execute.py`: `_execute_leaver` writes the description before the disable and stamps `delete_due_at` from the real execution time; the delete path is new Graph work (`DELETE /users/{id}`) behind the protected-object gate — check the app registration actually holds the permission to delete a user, and that deleting an account holding a directory role is refused cleanly rather than erroring.
- New beat entry every 5 minutes, modelled on `send-scheduled-reports`: claim due executions and due deletions idempotently, transitioning under the claim so two workers can't both fire one. A pass with nothing due is one query.
- Check the ADR 0055 action sources: an approved request *waiting for its time* must not appear in anyone's action list as work outstanding, while one whose time has passed unexecuted should. A pending deletion is worth surfacing somewhere before it happens, not only after.
- Frontend: date/time field, current-and-new description, and the delete-after toggle on the leaver form; scheduled time, pending-deletion date and a cancel on the request detail; the derived Scheduled state in the status filter.
- **ADR** — two changes to the ADR 0045 §6 execution model: approval no longer triggers the write, and Compass can now delete a directory account, which it deliberately could not before. That needs a decision record appended, not a comment.
- Tests: a scheduled request isn't executed at approval; the sweep fires it once when due and never twice; cancel before the time stops it; a past time is refused; expedited can't carry one; a request whose time passed during downtime still fires; `delete_after_days = 0` deletes in the same run; a pending deletion fires on the right day, can be cancelled, and is refused on a protected account; a failed description write doesn't stop the disable.
