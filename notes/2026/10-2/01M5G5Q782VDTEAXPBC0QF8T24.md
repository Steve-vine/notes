---
id: 01M5G5Q782VDTEAXPBC0QF8T24
created: 2026-10-21T21:26:19.138544Z
updated: 2026-10-21T21:26:19.138544Z
type: task
title: The next assessment falls due — 12 months after approval by default for each kind, in Actions before it's due and overdue after; start the next from the last, or early when something significant changes
priority: high
assignee: steve
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1227
---
Sprint 83, Risk Assessments (ADR in COM-1219). ISO 27001 8.2, PCI 12.3.1 (12 months), HITRUST 03.b, RIM.3.

**Chain:** on the chain — migration + API

## What people see

- **Risk Assessments ▸ Settings** (Manage): how often each kind falls due — **Risk assessment**, **DPIA review**, **PCI targeted risk analysis**, **AI impact assessment** — 12 months each by default.
- An approved assessment shows **Next due**: approval date + the cadence. It's the one that counts until the next of the same kind and scope is approved; the older one is marked **Superseded by RA-9** but stays readable.
- **Actions:**
  - "Risk assessment due: RA-7 (Company-wide)" for its assessors and approver from 60 days before, overdue after;
  - "Continue RA-9" for assessors of one in progress for over 30 days;
  - "Approve RA-9" for the approver (from the previous task).
- **Start the next one** from an approved assessment's page: pre-filled from it (scope, assessors, approver, threats and scores as the starting point), Why now = Scheduled.
- **Early, on change (SOC 2 CC3.4, ISO 8.2):** "Start a risk assessment" on an incident's Governance card and on a change-worthy record (a new technology asset marked critical, a new vendor) opens the start form with Why now and the link filled in.

## Notes (technical)

- Settings table (per organisation); action sources per ADR 0055; dates per ADR 0121.

**Done when:** an approved RA shows its next due date; it appears in Actions 60 days ahead; Start the next one carries its threats; an incident can start one with the link kept.