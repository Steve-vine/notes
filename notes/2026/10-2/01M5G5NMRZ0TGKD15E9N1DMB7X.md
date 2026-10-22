---
id: 01M5G5NMRZ0TGKD15E9N1DMB7X
created: 2026-10-21T21:25:27.455303Z
updated: 2026-10-22T21:09:23.728458Z
type: task
title: A risk has a review date, and accepting one needs an approver and runs out — both come up in Actions when due
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1222
sprint: s33gwqy
blocked_by:
- 01M5G5NBWZ8D3QKE46JT8WJWNJ
comments:
- id: 01M5JQ4WAFAMF8S14AP850VW5R
  author: Steve Vine
  at: 2026-10-22T21:09:21.359646Z
  text: |-
    Done — merged in PR #1240 (migration 0505). Not yet on staging.

    - Every open, treated or accepted risk shows Last reviewed and Next review in a Review panel on its page. Next review is also a register column, and turns red once the date has passed.
    - "Mark reviewed" sets Last reviewed to today and Next review one cadence ahead. A new risk starts one cadence out; existing risks get a next review 12 months after their last change.
    - Recording an accept treatment asks for an Approver (someone who can approve risk assessments and accept risks, which may be the owner) and an "Accepted until" date, 12 months ahead by default. Until the approver acts it shows "Awaiting approval" and the risk stays Open.
    - The approver approves (optional comment) or declines (comment required). Once approved, the card reads "Accepted by …, approved by … on …, until …". A declined acceptance can be sent again by naming an approver.
    - The day after an acceptance runs out, the risk goes back to Open, with "Back to Open: the acceptance ran out on …" in its History.
    - Actions:
      - "Review risk R-14", from 30 days before the review date, and overdue after.
      - "Approve acceptance of R-14", for the approver.
      - "Acceptance of R-14 runs out on 3 March", for the owners and the approver, from 30 days before.
    - Risk Assessments ▸ Settings is a new tab for people who can manage risk assessments. It sets the risk review cadence and the acceptance period (12 months each).

    My calls:
    - The two settings apply to every company, the same as the control-assessment review cadence. COM-1227 adds the assessment cadences to the same tab.
    - Accept treatments recorded before today aren't treated as approved. Their risks show "Needs acceptance" until someone names an approver and the approver approves.
    - Only the named approver can decide, not other admins. Approval re-checks appetite at that moment.
    - An approved acceptance can't have its approver or end date changed; a new decision means a new accept treatment.
    - "Review risk R-14" goes to everyone who manages the register, not just the owner, so risks with no owner still reach someone.
    - "Mark reviewed" is refused on a closed risk.
    - Expiry is checked hourly. "Accepted until" is the last day the acceptance stands, on UK time.
    - The assistant can name an approver and an end date when it records an accept treatment. It can't approve or decline one.
assignee: steve
label:
- feature
priority: high
task_status: review
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