---
id: 01M6296JQY05DTMZTVYTZ6C3NS
created: 2026-10-28T22:13:27.934125Z
updated: 2026-10-29T08:44:19.456076Z
type: task
title: 'A control shows its checks — a Checks card on the company''s assessment: each check passing, failing or can''t tell, since when, what''s failing, the gap it raised, and a run-now button; History records each change'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1419
sprint: s6j9773
blocked_by:
- 01M629676E5AJFGD3CBZTYBH0A
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 96, Continuous Control Checks (ADR 0132, COM-1415).

## What people see

- **Assessment of a control** (the panel where status and maturity are set): a **Checks** card beside Evidence of operation. Controls with no checks show no card.
- **One row per check:**
  - a status pill: Passing (green), Failing (red), Can't tell (grey) or Off;
  - the check's name;
  - "since 3 Nov";
  - the failing count ("4 of 212 people");
  - the gap it raised (G-123), linked;
  - when it last ran.
- **Opening a row** shows the failing items as a short list (first 20, then "see all on the Checks page") and the reason for Can't tell.
- **Run now** re-runs the check for this company and refreshes the row. It's limited to once a minute per check.
- **The card's header:** "3 checks · 1 failing". The status pill near the control's status reads, for example, "Status: Implemented · 1 check failing", so the assessor sees the disagreement without the status changing.
- **History** on the assessment: "Check 'Admins have MFA' started failing (2 people)" and "… passing again". Only changes of state are logged, not every run.
- **Once sprint 94 is in:** an excepted control shows its failing checks with "Excepted until …" and raises no gap.

## Who can do what

- Anyone who can read the assessment sees the card.
- The failing items follow each module's own read permission: Access Control for people, Inventory and Vulnerabilities for systems. Without it, you see counts only.
- **Run now** needs the permission to edit the assessment.

## Notes (technical)

- `GET /companies/{id}/assessments/{control}/checks` returns the latest result per check plus the gap link. Add `POST …/checks/{key}/run`.
- FE: `components/AssessmentPanel.tsx` gets a new `ChecksCard`. Follow the screen conventions (pills never truncate). Use adaptive red text (`c="red"`, never fixed shades).
- History: assessment History lines from `check_results` state changes. These are merged at read time, not written as assessment revisions.

**Chain:** on the chain (API).

**Done when:** on staging, IDM.13 shows its two checks, one failing with names. Run now refreshes it, and History shows when it started failing.