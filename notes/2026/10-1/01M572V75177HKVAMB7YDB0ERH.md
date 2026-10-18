---
id: 01M572V75177HKVAMB7YDB0ERH
created: 2026-10-18T08:42:54.497668Z
updated: 2026-10-18T08:44:19.584129Z
type: task
title: Any employee reports an incident or an AI concern from the User Portal — what happened, when, what it affects — the handlers are emailed at once, and the reporter follows its status under My reports
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1077
sprint: serbigk
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 76, Incidents - Register (ADR in COM-1063; Steve's decision: named, from the portal). Builds on triage (COM-1067). It answers ISO 27001 A.6.8, ISO 42001 A.3.3, IMA.2 and SEA.6.

## What people see

**Report an incident** in the User Portal, for every signed-in employee. It needs no incident permission. It asks:
- **what happened**, in their own words;
- **when it happened** or when they noticed (defaults to now);
- **what kind of thing it seems to be**: Something's down or not working / Security worry (phishing, lost laptop, odd account activity) / Personal data sent or seen by the wrong person / An AI tool did something wrong / Not sure. This only suggests a category; the handler decides at triage;
- **what it affects**, optionally: a system, or which company if they work for several;
- **attachments**, optional (a screenshot, the suspicious email).

A short line under the form says that reporting quickly matters more than being sure, and that they won't be told off for a false alarm.

**On submit**:
- the incident is created as **Reported** for that company, with the reporter named;
- the reporter gets the reference;
- **everyone with `incidents.handle` for that company is emailed straight away**, not in the hourly digest, because the 72-hour clock may be running;
- the report also shows in their Actions (actions task).

**My reports** in the portal lists what the person has reported:
- the reference;
- what they wrote;
- a **status in plain words**: Received, Being handled, Closed, or "Looked at: not an incident" with the handler's reason.

The reporter sees nothing else from the inside: not the timeline, links, the breach assessment or the review. They can **add more information** to their report while it's open, which goes on the timeline.

## Rules

- A report from the portal can't be withdrawn. If it's a mistake, the handler triages it out.
- Restricted incidents still show their reporter the plain status.

## Notes (technical)

- `POST /api/v1/portal/incidents`, plus the add-information route. Add both to the exact-set portal write-routes test in `tests/test_portal.py` (memory: integration-only, so a red is CI-only).
- Use immediate mail through the existing outbound mail path, not a hand-written notify (ADR 0055 derived mail). Check whether a "send now" kind exists. If none does, add one as a declared notification.

**Done when:** any employee can report from the portal; handlers are emailed at once; the reporter sees their reports' plain status and can add information.