---
id: 01M5CM9HTEMXA7H92AG4TH3YYW
created: 2026-10-20T12:24:02.126772Z
updated: 2026-10-20T17:51:41.275336Z
type: task
title: Access recertifications show as Evidence of operation on the access-review controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1154
comments:
- id: 01M5D71G6VJW7YZ5H9SXSVZ1X8
  author: Steve Vine
  at: 2026-10-20T17:51:41.27521Z
  text: |-
    Merged in PR #1157 at 17:49 UTC on 2026-10-20 (main fc708b9f). Not yet on staging.

    **What changed:** on a company's assessment, Evidence of operation now has **Access recertification** lines, one per recertification schedule:
    - **ACC.4** and **IDM.5**: every Access Control schedule (groups, business roles, directory roles and shared mailboxes);
    - **ACC.3**: directory-role schedules only.

    Each line shows:
    - **Last done:** the last completed review, with when, who submitted it, "N kept, M removed", and its evidence CSV. The line links to that review.
    - **Next due:** the next period's opening, the same date the plan's calendar shows, and the schedule's owners.
    - **Warnings:**
      - a review open past its due date;
      - a review withdrawn since the last completed one, with its reason.

      A withdrawn review is never counted as done.

    As every source does, it only shows: nothing changes a control's status or maturity. People who can see the assessment and Access Control see it; nobody else does.

    **My calls:**
    - As in the task: fixed controls, one line per schedule, and ACC.3 for directory roles only.
    - **No schedule is the finding.** A company with no schedule on the control gets one line with a warning: "No recertification schedules", or on ACC.3 "No directory role is recertified".
    - **Withdrawn reviews show until a later review completes.** After that the withdrawn one has been replaced, and it drops off the line. It stays on the Instances list.
    - **Asset schedules are left out.** They are Inventory's own line (COM-1155), so ACC.4 shows both, each under its own label.
    - "Removed" counts the rows the reviewers flagged for removal.

    **Checks:**
    - New integration tests (6) cover:
      - each control is found by its key;
      - last done, next due, and the overdue and withdrawn warnings;
      - a withdrawn-only schedule isn't done;
      - ACC.3 shows directory roles only;
      - no schedules, and asset schedules left out;
      - a reader without Access Control sees nothing.
    - After each rebase onto the vendor, content and Inventory sources, I reran the neighbouring Evidence of operation suites (SAP, assistant SAP, attestations, DSR, incidents, vendor, content, Inventory). All green.
    - ruff check, ruff format --check and mypy all pass. No API change, no migration.

    **CI:** the run that merged took 12.2 min, with backend-test at 11.4. The frontend job was skipped (backend only). The three sibling sources merged while this PR was open. Two earlier runs were superseded by rebases onto them; the second of those was green at 22 min.
assignee: steve
label:
- follow_up
priority: low
task_status: active
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