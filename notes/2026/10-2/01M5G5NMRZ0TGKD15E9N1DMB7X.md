---
id: 01M5G5NMRZ0TGKD15E9N1DMB7X
created: 2026-10-21T21:25:27.455303Z
updated: 2026-10-21T21:29:25.906048Z
type: task
title: A risk has a review date, and accepting one needs an approver and runs out — both come up in Actions when due
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1222
sprint: s33gwqy
blocked_by:
- 01M5G5NBWZ8D3QKE46JT8WJWNJ
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 83, Risk Assessments (ADR in COM-1219).

**Chain:** on the chain — migration + API

## What people see

**Review date (ISO 8.2, HITRUST 03.d, RIM.4):**
- Every open, treated or accepted risk has a **Next review** date on its page and as a register column, with Last reviewed beside it.
- "Mark reviewed" on the risk sets Last reviewed to today and Next review a cadence ahead (12 months by default, Risk Assessments settings). Approving an assessment containing the risk does the same (later task).
- Existing risks get Next review 12 months after their last change.
- **Actions:** "Review risk R-14" for the risk's owner from 30 days before, overdue after.

**Acceptance (ISO 6.1.3f, HITRUST 03.c):**
- Recording an **accept** treatment asks for an **approver** — someone with *Approve risk assessments and accept risks* (may be the owner if they hold it) — and an **expiry** (12 months by default).
- Until approved it shows **Awaiting approval** and the risk stays Open; the approver gets an Actions item "Approve acceptance of R-14" and approves or declines with a comment.
- Approved: the risk becomes Accepted, the card says who accepted it, who approved it, when, and until when.
- **Expiring:** "Acceptance of R-14 runs out on 3 March" in Actions for owner and approver 30 days before; on expiry the risk goes back to Open and needs a new decision.

## Notes (technical)

- Columns on risk: `next_review_on`, `last_reviewed_on` (dates, ADR 0121). Treatment plan: `approver_id`, `approved_at`, `expires_on`, `decision`.
- Action sources per ADR 0055 (`core/actions/company.py`); Beat job for expiry (idempotent, takes IDs).
- Copy the control-assessment review cadence pattern (`assessment_settings.py`).

**Done when:** a risk shows its next review and appears in Actions when due; an acceptance can't take effect until an approver approves it, and lapses at its expiry.