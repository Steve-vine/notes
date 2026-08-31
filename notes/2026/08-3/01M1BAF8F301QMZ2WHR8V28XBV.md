---
id: 01M1BAF8F301QMZ2WHR8V28XBV
created: 2026-08-31T07:10:21.667219Z
updated: 2026-08-31T07:15:17.385527Z
type: task
title: A leaver request can be set to run at a stated time, and approval arms it rather than firing it
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
Today an approved leaver request executes the moment the approver approves it. Someone leaving at 5pm on Friday therefore has to be approved at 5pm on Friday, by a person who has to be there to do it. Let the requester say **when** the change should happen; approval then arms it, and Compass runs it at that moment.

**Behaviour**
- Raising a leaver request, the requester can give a date and time to run it. Leaving it empty keeps today's behaviour — approval executes immediately — and that stays the default.
- Approving a scheduled request doesn't touch the directory. The request reads as **Scheduled**, showing when it will run, and the approval is already recorded.
- Between approval and the run it can be cancelled, exactly as an approved request can be now. The time can also be changed; who changed it and when is on the record like every other decision on the request.
- At the stated time it executes exactly as it does now: same disable, same session revoke, same group removal, same ledger rows, same failure and retry behaviour. The request shows the time it was meant to run and the time it actually ran.
- Times are the requester's local wall clock, stored in UTC. Firing is checked every five minutes, so "17:00" means within five minutes of five — a leaver's access shouldn't wait a quarter of an hour.
- If Compass was down when the time passed, the request still runs when it comes back, however late, with the delay visible. A leaver whose access removal is skipped because a worker was restarting is the worse failure.
- **Standard approval only.** Expedited is break-glass — "do it now and justify it after" — and a scheduled break-glass request is a contradiction. The field isn't offered there.

**Decision: no new "scheduled request" type** — this is one nullable `scheduled_for` on `access_requests`, which every kind already shares. Joiner, mover, membership change and the rest get the capability at the data and API layer for free, and only the leaver screen exposes it now. A separate entity would duplicate the whole JML lifecycle — subjects, approval gates, execution path, ledger, audit — and split the record of an access change across two places. When you want scheduled joiners ("starts Monday"), that's a screen change, not a new spine.

**Decision: no new status value.** "Scheduled" is derived from *approved + a future `scheduled_for`*, not a seventh state in the lifecycle. `status` keeps meaning where the request is in approval; the transitions map and the enum are untouched (and a new enum value on a live database is its own migration trap — see the Alembic enum notes).

**Before exposing this to other kinds** — leaver execution re-reads the account and its live memberships from the directory at the moment of the write, so a delay of hours or days doesn't act on stale data. Joiner and mover carry the business roles chosen at request time on the subject row; those *can* drift between approval and a delayed run. That question needs answering before the field is offered for those kinds — it is not a blocker for leaver.

**Implementation**
- `models/access_request.py`: `scheduled_for: datetime | None` (timestamptz), plus a partial index on approved rows with a non-null value so the sweep is a cheap query.
- `api/v1/access_requests.py`: accept it on create and on gate edit; validate it is in the future and that the mode is standard. `approve_request` fires `execute_access_request.delay(...)` only when it is null. Add a reschedule path, or fold it into the existing gate-edit endpoint, and audit it either way.
- New beat entry every 5 minutes, modelled on `send-scheduled-reports`: claim due requests idempotently and transition `approved → executing` under the claim so two workers can't both fire one. A pass with nothing due is one query.
- Check the ADR 0055 action sources: an approved request that is *waiting for its time* must not appear in anyone's action list as work outstanding, while one whose time has passed unexecuted should.
- Frontend: a date/time field on the leaver request form, the scheduled time on the request list and detail, and the derived Scheduled state in the status filter.
- **ADR** — approval no longer triggers the write for every request; a sweeper does. That's a change to the ADR 0045 §6 execution model and needs a decision record appended, not a comment.
- Tests: a scheduled request isn't executed at approval; the sweep fires it once when due and never twice; cancel before the time stops it; a time in the past is refused at creation; an expedited request can't carry one; a request whose time passed during downtime still fires.
