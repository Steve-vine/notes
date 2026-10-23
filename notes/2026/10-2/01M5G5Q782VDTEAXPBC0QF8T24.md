---
id: 01M5G5Q782VDTEAXPBC0QF8T24
created: 2026-10-21T21:26:19.138544Z
updated: 2026-10-23T18:06:05.486843Z
type: task
title: The next assessment falls due — 12 months after approval by default for each kind, in Actions before it's due and overdue after; start the next from the last, or early when something significant changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1227
sprint: s33gwqy
blocked_by:
- 01M5G5PZ2KMPQS3CTF673577WX
comments:
- id: 01M5K5GQR90SQDM36Q4TGQWQQC
  author: Steve Vine
  at: 2026-10-23T01:20:29.961225Z
  text: |-
    Done — merged in PR #1250 (migration 0545). Not yet on staging.

    - Risk Assessments ▸ Settings has an Assessments panel: how often each kind falls due — Risk assessment, DPIA review, PCI targeted risk analysis, AI impact assessment — 12 months each by default. PCI says "At most 12 months — PCI DSS 12.3.1." and won't save anything longer.
    - An approved assessment shows Next due (the approval day plus its kind's cadence), on its page and in the list. Changing a cadence moves Next due for current approved assessments of that kind, with a line in each one's History.
    - Actions:
      - "Risk assessment due: RA-7 (Company-wide)" goes to its assessors and approver from 60 days before, and shows as overdue after. It clears when the next one is approved.
      - "Continue RA-9" goes to the assessors of one still Draft or In progress 30 days after it was started.
    - "Start the next one" on an approved assessment opens the start form pre-filled: title, scope, assessors, participants, approver, Why now = Scheduled, and its threats and scores carried forward.
    - "Start a risk assessment" appears on:
      - an incident's Governance card: Why now = Incident, with the incident linked; the card also lists the assessments started for it;
      - a technology asset marked critical, and a vendor that is requested or active: Why now = "New system or processing", with the asset or vendor already in scope.

    My calls:
    - "Same kind and scope" means the line an assessment was started from: the next one supersedes the one it was started from. Starting from a superseded assessment is refused, naming the one that replaced it.
    - A DPIA screening has no cadence, so it never shows a Next due.
    - "Continue RA-9" counts from the day it was started, and leaves out one that was sent back (that has its own action).
    - Both new actions go in the daily digest email rather than being sent immediately.
    - The incident's "Start a risk assessment" shows whether the incident is open or closed.
assignee: steve
label:
- feature
priority: high
task_status: done
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