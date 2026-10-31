---
id: 01M68M82SJ7K0TKSNKCHBZM4P5
created: 2026-10-31T09:21:58.066356Z
updated: 2026-10-31T12:59:59.56609Z
type: task
title: Access, Vendors, Inventory and Trust Centre actions follow the one-action-per-thing rule — and waiting module work (Discovered items, software suggestions) becomes an action
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1480
sprint: scpaa6p
blocked_by:
- 01M68M4TR5X3N0A30R9F8XGY5V
- 01M68M56FJGX3ZRTFG9SNDVXQX
comments:
- id: 01M68W76BJGBFBG2S3XX83GWQ0
  author: Steve Vine
  at: 2026-10-31T11:41:17.554659Z
  text: |-
    Done: PR #1496 merged.

    - **Access:**
      - A request shows one step at a time, with titles naming the thing ("ACR-41 · Expedited leaver").
      - A leaver's "Stop or allow deletion" waits until the request is validated and its on-premises steps are done.
      - A business role with removed or rule-based groups is one "Business role · Fix the role" row per role, naming every problem.
      - Recertifications were already one row per reviewer per campaign ("Finance (2026-Q4) · 2 to review").
    - **Vendors:**
      - An approval that's waiting on the requester's answer drops off the approver's list until they answer. Until then the request's only row is the requester's question, and the approver is still emailed when it's answered.
      - Required questionnaires are one row per vendor, naming each form.
    - **Inventory (new):**
      - **Discovered · Sort** ("3 discovered items to sort") and **Software · Match suggestions** ("2 software suggestions"), one row per company.
      - Both belong to the Inventory team until Admin ▸ Actions names someone, and are due 14 days after the oldest item arrived.
    - **Trust Centre:** already one row per thing; titles tidied.
    - **Kept side by side on purpose:** an expedited leaver's on-premises AD step and its validation. Different people do them, and hiding the AD step would slow removing a leaver's access.

    To test on staging, in E2E Test Company:
    1. No request, vendor or role should have two rows for steps that follow each other.
    2. Discovered items should show as one Sort row (E2E Test Company has no discovery connection, so this may be empty — I'll say in the pre-UAT pass).
- id: 01M690Q9PEEAR4VFJAVAHNYT7K
  author: Steve Vine
  at: 2026-10-31T12:59:59.56588Z
  text: |-
    Pre-UAT (staging, 31 Oct, every E2E account, through the API): Passed for what E2E Test Company has.
    - No access request, vendor or role has two rows for one reader.
    - The only repeats are content with two named reviewers (see COM-1478).
    - ACR-78 (a standard leaver) showed one row at its Approve step.

    Couldn't check:
    - **Discovered · Sort and Software · Match suggestions:** E2E Test Company has no discovery connections by design (ADR 0135), so there's nothing to sort.
    - **Vendor steps:** E2E Test Vendor has no open request.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Sprint 100, Actions (ADR 0137 rule 2). This is the module review Steve asked for on 2026-10-31. It works from COM-1468's per-type table.

## What changes

**Access**
- A request has one row at its step: **Approve** (COM-1472), then **Validate** (expedited), then **Run** (a scheduled change whose time passed), then **Do the on-premises step**. A leaver whose account is still standing shows **Stop or allow deletion** until the delete.
- An unrequested directory change: **Adopt or reverse**.
- A recertification: one row per reviewer per campaign (**Recertification · Review**, "14 to review"), not one per item. Check whether today's rows are per item.
- Business role clean-ups (group gone, rule-based group, role removal): one row per role, **Fix the role**.

**Vendors**
- A vendor has one row at its step: **Approve** (request) → **Answer the approver's question** → **Assign the required questionnaire** → **Review** (due, or tier rose; see COM-1478).
- Review follow-ups keep their own rows (**Follow-up · Complete**). Each follow-up is its own thing.
- An expiring certification: **Certification · Renew**.

**Inventory**
- Accounts, subscriptions or projects left undecided: one row per connection, **Decide which to read**.
- A broken discovery rule: **Fix the rule**.
- Access to remove after recertification: **Remove access**.
- **New: waiting module work**
  - Items on the Discovered tab: one row per company, **Discovered · Sort** "14 items to sort", default owner, due N days after the oldest arrived.
  - Software suggestions: one row per company, **Software · Match** "6 suggestions".
  - Today these only show if someone opens the tab.

**Trust Centre**
- Each request: **Approve or decline**.
- An expiring document: **Document · Renew**.
- "Nobody receives questionnaires": **Choose who receives questionnaires**.

All owners come from COM-1471, and unowned work goes to the default owner.

**Chain:** on the chain. Blocked by COM-1470 and COM-1471.

**Done when:** on staging, for each module, the pre-UAT pass finds no thing with two rows for steps that follow each other, and E2E Test Company's Discovered items show as one Sort row.