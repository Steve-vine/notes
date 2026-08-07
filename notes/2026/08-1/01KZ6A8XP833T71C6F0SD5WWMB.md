---
id: 01KZ6A8XP833T71C6F0SD5WWMB
created: 2026-08-04T11:59:18.216301Z
updated: 2026-08-07T10:56:14.169489Z
type: task
title: Platform Log — ISE's own warnings/errors as a filterable in-app surface
project: 01KX671DATY39VW6GWK3M2T3DN
number: 531
order: 1.0625
sprint: skxht3g
comments:
- id: 01KZ6W66VNDZH3H9AA3TV8ZKWY
  author: Steve Vine
  at: 2026-08-04T17:12:23.66919Z
  text: |-
    PR #460 — https://github.com/Steve-vine/ise/pull/460 (ADR 0077, migration 0095)

    STACKED: 531 → on 534 (#459) → on 533 (#458), so migrations chain 0093 → 0094 → 0095. Merge in that order.

    Built the whole shape:
    - Sink: DatabaseLogHandler on the existing pipeline, WARNING+ from api/worker/beat. Both hard rules implemented AND tested — never raises (bare returns, thread-local re-entry guard, sqlalchemy/alembic/ISE_api.db excluded so a DB warning can't provoke a DB write; a test stubs the factory to throw and asserts the caller survives), and the same redact() as stdout (tested on both paths: sensitive KEY replaced wholesale, secret inside a VALUE scrubbed by pattern).
    - Screen: grouped by (logger, message) as the default and the feature — count + first/last seen, ordered by most-recently-seen not by count, occurrences fetched only on expand. Filters level/component/window/free-text. Nav entry beside Audit.
    - Retention: daily beat sweep, 14 days, and a misconfigured zero KEEPS everything rather than deleting everything.
    - ADR 0077 written, including why WARNING+ only and why the DB rather than an external log stack.

    Two decisions you asked to be settled, both recorded in the ADR:
    - The System-card badge ("2 slices failing — see Platform Log") is NOT built. It needs a rule mapping loggers to systems, and inventing one under time pressure is how a badge ends up lying. Logged as open in ADR 0077 — say if you want it as a follow-up ticket.
    - The suite runs with the sink OFF (ISE_PLATFORM_LOG_ENABLED=false): these tests log warnings by the thousand on purpose and each would spend a connection. Its own tests switch it on.

    Migration gotcha worth keeping: the timestamp columns needed server_default=now() explicitly. Without it the ORM sends no value, Postgres refuses the insert, and because the handler swallows its own exceptions by design it would have lost EVERY record silently. A test caught it, not production — but it is exactly the failure mode this ticket is about.

    Side effect to expect: every existing logger.warning in the codebase is now user-visible. That is intended and it raises the bar on their wording, but the first look at this screen on staging will probably show warnings nobody has read before.
assignee: steve
priority: medium
task_status: done
---
Direction from Steve 2026-08-04, prompted by the AWS-credentials find (ISE-530): the AWS alarm-detection and S3-tag-sweep slices had been 403ing every sync on both accounts for who-knows-how-long, and nothing in the app showed it — health stayed `connected`, the warnings lived only in `kubectl logs`. Rather than one-off surfacing (per-slice degraded health was considered and set aside), **ISE should have a central log surface: the platform's own WARNING+ records, filterable, in the app.**

This is the single-pane-of-glass principle applied to ISE itself: an operator should not need cluster access to see that a slice of their own monitoring platform is failing.

## Shape

**Sink.** A logging handler in `logging_setup.py` (which already does structured JSON + central redaction, ADR 0010) that also writes **WARNING and above** to a `platform_log` table: `timestamp, level, component (api|worker|beat), logger, message, extra JSONB`. All three processes get it. Two hard rules:
- The handler must **never raise and never log about failing to log** — a DB outage must degrade to stdout-only, not recurse or take the caller down.
- Records pass through the **existing redaction** (`REDACTED_KEY_PARTS` / patterns) before the DB write — the DB copy must never hold more than the stdout copy would.

**Screen.** "Platform Log" page + nav entry (this is a new user-facing surface — nav + UI-brief treatment per the DoD rule). Filters: level, component, time range, free-text over message/logger. Row detail shows the `extra` JSON (where `why`, system name, region etc. already live — the AWS 403s carry everything needed to diagnose without kubectl).

**Grouping is the feature, not a nicety.** The motivating case fires ~8 identical warnings per 15-minute cycle; a flat list is hundreds of duplicate rows a day. Default view groups by (logger, message): *"aws alarm detection failed — ×384, first 02:41, last 11:24"*, expandable to occurrences. That turns "noise in a log" into "this has been broken since Tuesday", which is the actual question.

**Retention.** A beat task prunes rows older than N days (default 14?). WARNING+ only keeps volume trivial — INFO would drown it (the celery task-success flood).

## Decisions for plan mode

- New ADR (in-DB log sink is an architectural choice; relates to ADR 0010). Include why WARNING+ only, and why DB rather than an external log stack — one live ISE, and the pane of glass should not depend on a second observability system to explain itself.
- Whether sync/obs slice failures should ALSO badge the System card ("2 slices failing — see Platform Log"), linking into the filtered log. Cheap once the table exists, and it puts the signal where the operator already looks. Lean yes, as a follow-up if not in-slice.
- Migration for the table; index on (timestamp desc), maybe (logger, timestamp).

## Acceptance (the motivating case, replayed)

With an AWS credential missing `cloudwatch:DescribeAlarms`: an operator opens Platform Log, filters level=WARNING, and sees one grouped row for the alarm-detection failure with count, first/last seen and the AccessDenied detail — without touching kubectl. The 403s from ISE-530's broken state would have been visible the day they started.
