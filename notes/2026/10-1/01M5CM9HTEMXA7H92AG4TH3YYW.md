---
id: 01M5CM9HTEMXA7H92AG4TH3YYW
created: 2026-10-20T12:24:02.126772Z
updated: 2026-10-20T12:24:02.126772Z
type: task
title: Access recertifications show as Evidence of operation on the access-review controls
task_status: backlog
assignee: steve
label: follow_up
priority: low
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1154
---
Split from COM-1060 (2026-10-20). Builds on COM-1051's Evidence of operation registry (ADR 0115 §10).

## Why

An access recertification is the textbook evidence that access reviews happen, but the access-review controls' assessments don't show it.

## What people see

On a company's assessment of these controls, Evidence of operation gains one **Access recertification** line per recertification schedule:
- **ACC.4** (`ACC.8`): owners recertify users' access every six months;
- **IDM.5** (`ACC.23`): accounts are inventoried and reviewed every six months;
- **ACC.3** (`ACC.7`): privileged access is reviewed quarterly. Only schedules that cover a directory role appear here.

Each line shows:
- **Last done:** the last completed review, when, by whom, its outcome (rows kept and removed), and a link to its evidence export.
- **Next due:** the next period's opening, and the schedule's owner.
- **Warning:** a review that is open and overdue. A withdrawn review (COM-837) appears as withdrawn, with its reason, and is never counted as done.

The line is visible to people who can see the assessment and can run or view recertification.

## My calls (to confirm)

- **Fixed controls,** as Incidents, Attestations and DSR do. They are not set per schedule.
- **One line per schedule.** A company has a handful of schedules, and each is its own piece of evidence.
- **Privileged-access control only for directory-role schedules.** A group schedule isn't evidence that privileged access is reviewed.

## Notes (technical)

- New source module; `CONTROL_EVIDENCE` keyed by control key (memory control-key-vs-ref).
- Reuse COM-1048's recertification calendar adapter for the next due date.
- Depends on COM-837 for the withdrawn state. Build after it lands.
- Tests: a completed, an open overdue and a withdrawn review; a role schedule appears on ACC.3 and a group schedule doesn't; a reader without permission sees nothing.

**Done when:** on staging, a company's assessment of ACC.4 lists its recertification schedules with the last completed review and the next due.