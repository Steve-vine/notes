---
id: 01M5B0JZSG582CAEXKKC2M1GNN
created: 2026-10-19T21:20:25.392315Z
updated: 2026-10-20T18:05:46.16424Z
type: task
title: The privacy controls show the module's work as Evidence of operation — requests answered and on time on access and correction/erasure, the Disclosures log on disclosures, complaints on complaints — with late and overdue warnings
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1145
sprint: ss8348q
blocked_by:
- 01M5B0JM7T3BT1PQ14EP58BZJD
- 01M5B0KFBPB486ADBCZD4HC1AG
comments:
- id: 01M5BSZ54R4T0Z1SVRC7EAMR2C
  author: Steve Vine
  at: 2026-10-20T04:43:58.4884Z
  text: |-
    Done — merged (PR #1140).

    - On a company's assessment of **PDH.10, PDH.15, PDH.17 and PDH.18**, the Evidence of operation card has a "Data Subject Requests" row for that control's kinds of request: how many came in over the last 12 months, how many were answered on time, how many are still open, and a link to the latest closed one.
    - **PDH.15** also shows whether recipients were told (told, not told, not yet recorded).
    - **PDH.17** shows complaints acknowledged in time and what they were about; the row opens the Compliance tab.
    - **PDH.16** shows the Disclosures log: authorised and unauthorised counts, the latest disclosure, and requests to disclose decided. It warns about any unauthorised disclosure with no incident tied to it, beside Incidents' existing "Privacy incidents" row.
    - **PDH.18** covers objection, restriction, portability and automated-decision requests.
    - Warnings for open requests past their deadline (a paused clock doesn't count) and for any request answered late.
    - Restricted requests and disclosures are counted but never linked or named. With no requests, the row says "No requests in the last 12 months" — not a warning. Show-only: nothing changes status, maturity or gaps.

    My calls: the latest request shows as "DSR-12 · Access, erasure", never the person's name (a control assessment is no place for personal data); restricted items stay unlinked even for people named on them; the on-time figure covers requests answered in the last 12 months, whenever received; rows link to the Compliance tab rather than a filtered register (the register filters by one type at a time).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 79, Data Privacy (ADR in COM-1129). Uses ADR 0115: Evidence of operation is shown on a company's assessment of a library control. It is show-only and never changes a status, maturity or gap.

## What people see

On a company's assessment of each control, an **Evidence of operation** row from Data Subject Requests:

| Control (ref · key) | Shows |
|---|---|
| PDH.10 · `PDH.12`: requests to access personal data | access, portability and accounting requests, last 12 months: count, on time %, latest closed (link). Warns on overdue open requests, or any answered late |
| PDH.15 · `s42.PDH.4`: correction and erasure within the timeframe | correction, erasure and restriction requests: count, on time %, recipients told; warns on overdue or late |
| PDH.16 · `s42.PDH.5`: disclosures recorded, authorised or not | disclosures, last 12 months: authorised and unauthorised counts, latest (link); requests to disclose decided. Warns on an unauthorised disclosure with no incident |
| PDH.17 · `s42.PDH.6`: complaints handled and monitored | complaints: count, acknowledged in time %, latest; links to the Compliance tab's themes |
| the new control from the Library task (if added) | objection, restriction, portability and automated-decision requests |

Through the library's mappings, these show wherever those controls answer a framework: SOC 2 P5.1, P5.2, P6.1–P6.3, P6.7, P8.1; HITRUST 13.c, 13.f, 13.n, 13.o; ISO 27001 A.5.34.

## Rules

- Restricted requests are counted but never linked (redacted, as for incidents).
- A company with no requests in 12 months shows "No requests in the last 12 months". This isn't a warning: having none is normal.

## Notes (technical)

- `core/dsr_evidence_of_operation.py`, registered in `core/evidence_of_operation.py` `_sources()`.
- **Look controls up by `CoreControl.key`, not by ref.** controls.csv Key ≠ Control ID after renumbering (COM-1062). The keys are given above.

**Done when:** each of the four controls' assessments shows the module's row with counts and warnings; restricted requests aren't linked.