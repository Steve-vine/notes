---
id: 01M6297VTMHDH808JQNJ1C4THQ
created: 2026-10-28T22:14:10.004151Z
updated: 2026-10-29T10:14:47.638154Z
type: task
title: What changed, by email — chosen people get the company's summary monthly or quarterly, with the PDF attached and a link to the page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1423
sprint: s6j9773
blocked_by:
- 01M6297JBJ009CJ1HG9Q9BJDM1
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 96, Continuous Control Checks (ADR 0132, COM-1415).

## What people see

- **Settings ▸ What changed email** (per company):
  - **Off** by default; **Monthly** or **Quarterly**;
  - **Recipients**: people chosen from Compass users;
  - the **measure** (Core controls, or one framework);
  - **Send a test to me**.
- **The email** goes out on the first working day after the period ends, at 08:00 UK time:
  - subject "<Company>: what changed in Q3 2026";
  - the headline figures and the count in each section, in the body;
  - the PDF (COM-1422) attached;
  - a link to the page set to that period.
- Every send goes in the mail ledger, like other Compass mail. A failed send shows on the Settings page, with the reason.
- A recipient who leaves Compass (deactivated) is dropped and listed on the Settings page as "no longer sent".

## Who can do what

- Setting it up needs *Manage company settings*.
- Recipients receive the email whatever their permissions. The PDF holds the same content as the page, but the email names no people and lists no failing items. Being chosen as a recipient is the permission. Flag this in the ADR (COM-1415).

## Notes (technical)

- This is a scheduled send, not an Action: use the email transport and the mail ledger (`core/mail_digest.py` is the closest pattern), not `notify()` (ADR 0055).
- Beat runs daily and decides whether today is the first working day after a period. Use ADR 0121 for UK time, and make it idempotent per (company, period).
- Generate the PDF in the worker, sharing `what_changed.summarise`.

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve sets quarterly to himself, uses Send a test, and receives the email with the PDF.