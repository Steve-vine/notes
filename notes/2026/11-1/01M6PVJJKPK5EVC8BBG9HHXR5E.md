---
id: 01M6PVJJKPK5EVC8BBG9HHXR5E
created: 2026-11-05T21:59:24.022691Z
updated: 2026-11-05T21:59:24.022691Z
type: task
title: Ask Polaris to check this, or re-create it — on demand, Polaris reads a collected check's latest capture against its control and says "still fine", proposes a change, or flags something sensitive; Re-create designs it again while the old one keeps running until the replacement is approved
assignee: steve
priority: high
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1604
---
Sprint "Evidence Collection - Integrations" (ADR 0142, COM-1595). Builds on COM-1603. It is the one-at-a-time version. Selecting many and doing this in a batch is the next sprint.

## What people see

- **On a collected check, from the control's card or a held capture's review:**
  - **Ask Polaris to check this** (Record assessments). Polaris reads the latest capture, or the held one, alongside the approved one and the control, and answers with one of three:
    - **Still fine:** "Still shows every Conditional Access policy; 6 more because 6 were added". On a held capture, it offers **Confirm**.
    - **Change proposed:** "This no longer shows the grant controls, because the API now returns them under `grantControlsV2`". It comes with a corrected check and a fresh sample, and goes through the first-capture check (COM-1601) to approve.
    - **Something sensitive:** "`mfaPhoneNumber` holds phone numbers", proposing to leave it out. One click applies it.
  - **Re-create** has Polaris design the check from scratch, for a vendor's API change or a control that's been reworded.
    - **The old check keeps running** until the replacement is approved, so coverage never drops while Polaris works. The exception is a check that's already Broken.
    - Approving the replacement retires the old one. Its captures stay in the register's history.
- **Polaris never runs on a schedule** (Steve). It only looks when someone asks.
- Each answer is kept on the check's history: when, who asked, what Polaris said, and what the person did.

## Notes (technical)

- Two job kinds on COM-1599: `revalidate_check` (input: check, approved shape, latest or held capture sample, control text; form: `verdict` = fine / change / sensitive) and `recreate_check` (reuses `design_collection`, carrying the old check's id so approval swaps them).
- Send samples, not whole captures: cap the rows sent to the provider and say so in the prompt.

**Chain:** on the chain (API).

**Done when:** with a fake provider, all three verdicts reach the screen and act correctly, and Re-create keeps the old check live until approval. On staging with a provider key, a held capture with a new field gets "Still fine" or a leave-out proposal that applies in one click. Otherwise: Couldn't check, needs Polaris's AI provider.