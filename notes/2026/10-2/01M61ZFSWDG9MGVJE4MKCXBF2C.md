---
id: 01M61ZFSWDG9MGVJE4MKCXBF2C
created: 2026-10-28T19:23:44.39754Z
updated: 2026-10-29T04:11:49.55048Z
type: task
title: A runbook shows its test record — last tested, how, the result and the next test due — says plainly when it's never been tested, and goes back for review after a test that didn't pass
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1412
sprint: stqs5r1
blocked_by:
- 01M61ZFBM87SY79Z4VA2AK1472
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 95, Business Continuity (ADR 0131, COM-1407). Builds on COM-1411 (exercise results). This is "runbook tests on the content-review cadence machinery" from the original list: SAP holds the schedule, the runbook shows the outcome.

## What people see

- **A runbook's page** gains a **Tested** card for the company in the top bar:
  - **Last tested** — date, SAP-NN, kind of exercise, result, and the systems' times against target;
  - **Next test due** — the next planned SAP occurrence naming it, with its owner;
  - **Never tested** in amber when no done exercise names it; **No test planned** when nothing is scheduled, with **Add to the plan** (a Testing entry with this runbook already named).
  - **History** — earlier tests, newest first.
- **Content ▸ list** gains a **Last tested** column and a **Never tested** filter for runbooks.
- **A Partly or Failed result sends the runbook for review**:
  - a content review is started on it (ADR 0032, its usual reviewers), with the reason "SAP-41 failed on 3 Mar — CRM took 9h against 4h" and a link to the exercise;
  - its reviewers get it in Actions as any review;
  - if a review is already open, the exercise is added to its reasons rather than starting another;
  - the exercise's findings (gaps / risks) are unchanged and separate.
- **Evidence of operation** on the BCR controls already shows the exercise; nothing changes there.

## Who can do what

Anyone who can see the runbook sees the card for companies they can see SAP for (`sap.view`); without it the card isn't shown, as Evidence of operation does.

## Notes (technical)

- Read through from SAP (never copied), per company.
- The review start reuses `POST /content/{slug}/reviews`'s path, with a `reason` and a source link; triggered on completion and on a correction that changes the result to Partly/Failed. Idempotent per exercise.

**Chain:** on the chain (API).

**Done when:** on staging, a runbook shows a passed test; a failed one starts a review with the exercise as its reason; a runbook nobody tested says so.