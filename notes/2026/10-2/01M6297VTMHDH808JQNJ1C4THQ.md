---
id: 01M6297VTMHDH808JQNJ1C4THQ
created: 2026-10-28T22:14:10.004151Z
updated: 2026-10-29T10:35:16.72799Z
type: task
title: What changed, by email — chosen people get the company's summary monthly or quarterly, with the PDF attached and a link to the page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1423
sprint: s6j9773
blocked_by:
- 01M6297JBJ009CJ1HG9Q9BJDM1
comments:
- id: 01M63KMV9E42Y4JMRSAXBEB7NX
  author: Steve Vine
  at: 2026-10-29T10:35:15.630604Z
  text: |-
    Done — PR #1440 (stacked on #1439).

    What you'll see:
    - On Posture ▸ Compliance's What changed panel, an Email button (for people who can run reports). It opens: Off / Monthly / Quarterly; the measure (Core controls or one framework); recipients chosen from Compass users; anyone no longer sent ("No longer sent (no longer in Compass): …"); the next send ("Next: 4 Jan 2027, for 1 Oct 2026 to 31 Dec 2026"); recent sends with any failure and its reason; and "Send a test to me".
    - The email goes on the first working day after the month or quarter (a weekend or bank holiday moves it on), from 08:00 UK time. Subject: "<Company>: what changed in Q3 2026". The body has the headline and each section's counts and names nobody. The PDF is attached, with a link to the page set to that period.
    - Each person gets it once per period, however many times the job runs.

    My calls:
    - The setup lives on the What changed panel, not a separate Settings screen, and needs Run reports (Posture has no "Manage company settings" — ADR 0132 call 9). It's in the activity log.
    - Turning it on requires choosing at least one person; only active Compass users can be chosen.
    - A recipient gets every section, whatever their own permissions. Being chosen is the permission (ADR 0132 §12).
    - "Send a test to me" sends the last whole period: last month, or last quarter if set to quarterly. It's recorded as a test and never stops the real send.
    - If no way of sending mail is set up, the send is recorded as "Not sent" with the reason.

    To try it on staging: set it to Quarterly to yourself and press "Send a test to me". It should arrive in staging's mail catcher with the PDF.

    Tests: the due-day rules (month end on a Saturday, New Year bank holiday), the send going once with the PDF and the link, deactivated recipients dropped, permissions, and the test send.
assignee: steve
label:
- feature
priority: medium
task_status: review
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