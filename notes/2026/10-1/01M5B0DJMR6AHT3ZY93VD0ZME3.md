---
id: 01M5B0DJMR6AHT3ZY93VD0ZME3
created: 2026-10-19T21:17:28.088631Z
updated: 2026-10-19T21:21:34.455723Z
type: task
title: Each request counts down to the law's deadline — UK GDPR, EU GDPR, HIPAA and CCPA ship as standard rules per request type, each company can switch them off, adjust or add its own, the clock pauses while waiting on the person, and an extension needs a reason
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1132
sprint: ss8348q
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 79, Data Privacy (ADR in COM-1129). Steve chose all four laws as standard rules.

## The standard rules

A rule is one law and one request type. It says when the clock starts, how long there is, whether it can pause, and how far it can be extended. Some rules also set an acknowledgement deadline.

| Law | Request types | Acknowledge | Answer within | Extension | Clock |
|---|---|---|---|---|---|
| UK GDPR | Access, correction, erasure, restriction, objection, portability, automated decision | — | 1 calendar month | up to +2 months, if complex or numerous | starts on receipt, or when identity is confirmed if asked for; **pauses** while waiting for clarification |
| UK GDPR | Complaint | 30 days | target 1 month (company sets) | — | on receipt |
| EU GDPR | as UK, plus complaint (target 1 month) | — | 1 calendar month | up to +2 months | starts on receipt; no pause |
| HIPAA | Access | — | 30 days | once, +30 days | on receipt |
| HIPAA | Correction (amendment) | — | 60 days | once, +30 days | on receipt |
| HIPAA | Accounting of disclosures | — | 60 days | once, +30 days | on receipt |
| HIPAA | Restriction, complaint | — | target 30 days (company sets) | — | on receipt |
| CCPA | Access (know), correction, erasure (delete), portability | 10 business days | 45 days | +45 days | on receipt |
| CCPA | Opt out of sale or sharing | — | 15 business days | — | on receipt |

A **calendar month** runs to the same date next month. If there isn't one, it runs to the last day of that month. If the date falls on a weekend or UK bank holiday, it moves to the next working day (ICO). Business days skip weekends. The holiday calendar used is UK bank holidays for UK GDPR, and weekends only otherwise.

A request with several types counts down to its **earliest** deadline. The page shows each type's deadline as well.

**Forwarded by a customer** requests don't use the law's rules. They count down to the customer's deadline entered at logging.

## What people see

- The request page header shows **Due 12 Nov — 9 days left**. It turns amber inside 7 days, red when overdue, and shows **Paused** while paused.
- **Pause** (only where the rule allows): "Waiting for the person to clarify". The handler can restart it by hand, or it restarts when "clarification received" is recorded. Paused days push the deadline back. Each pause and restart goes on the timeline.
- **Waiting for identity**: where the rule starts on confirmed identity, asking for ID (in Verify) holds the start. The header says "Clock starts when identity is confirmed".
- **Extend**: once per request, within the rule's maximum, with a reason. It must be done before the original deadline. The new date shows, and an extension letter is expected (Letters task).
- **Settings ▸ Deadline rules**: the standard rules, read-only for everyone, plus per company **switch off**, **adjust** (change the days) or **add** a rule (e.g. a customer contract or another country's law). The pattern is the same as Incidents ▸ Settings (COM-1122). Each rule shows where it comes from (e.g. "UK GDPR Art. 12(3); DUAA 2025").

## Rules

- A request copies its rule when it's logged, so changing a rule later doesn't move open requests' deadlines. A **Recalculate** action on the request applies the current rule, and it's logged.
- Changing a request's law or types recalculates its deadline, and that's logged.

## Notes (technical)

- Standard rules ship as seed data (seed import runs every deploy; repair seed data in the importer, not a migration). Company overrides in their own table.
- Deadline maths as a pure, unit-tested function. Cover month-end (31 Jan → 28/29 Feb), bank holidays and business days. Hold UK bank holidays as data.
- Pause intervals as rows, so the history is exact.

**Done when:** a UK GDPR access request logged on 31 January is due 28 February (or the next working day); pausing for 5 days moves it by 5 days; an extension needs a reason and can't exceed the maximum; a company can switch off CCPA and add its own rule.