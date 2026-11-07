---
id: 01M6PVNM0PSWF3GDGZN9TYA7QZ
created: 2026-11-05T22:01:03.766489Z
updated: 2026-11-07T08:55:18.878304Z
type: task
title: 'The review queue — a Polaris batch comes back as one summary ("looked at 52: 31 still fine, 14 new checks, 4 changes, 3 can''t be automated"); still-fine items approve together, new checks and changes are reviewed side by side with sensitive fields highlighted, and can''t-be-automated answers set Manual only'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1610
sprint: s5khbev
blocked_by:
- 01M6PVN2WBHVZRSTP7Y247GEV0
comments:
- id: 01M6QB0FM5ND1DYCYA1ZCR65F9
  author: Steve Vine
  at: 2026-11-06T02:29:08.356986Z
  text: |-
    Done — merged to main (PR #1626).

    What's there
    - Posture ▸ Checks has a Review tab, with a count of everything waiting for a person: Polaris's proposals from any job or batch, and captures held for review.
    - A batch's review action opens the tab on that batch's summary: "Looked at 52: 4 changes · 14 new checks · 0 rules · 31 still fine · 3 can't be automated · 0 couldn't". "Show everything waiting" clears the batch filter.
    - The items are grouped:
      - Changes, held captures, new checks, rules and audit flags are reviewed one at a time with their samples. A approves, D discards, and the arrow keys move between them.
      - "Still fine" and "can't be automated" are accepted together with "Accept all N". Each is applied on its own, so one that can't be applied doesn't stop the rest, and anything that couldn't be is listed.
      - "Couldn't" lists the controls Polaris stopped on, with why.
    - Anything waiting more than 30 days says "the system may have changed".
    - Someone without Record assessments sees the queue without the buttons.

    My calls
    - "Something sensitive" verdicts sit under Changes and aren't in Accept all, because they change what's kept.
    - Keyboard shortcuts never fire while you're typing in a field.

    Tests: test_collection_review.py; ReviewTab.test.tsx.

    What to check on staging: open Posture ▸ Checks ▸ Review in E2E Test Company. Without Polaris it will mostly be empty unless a capture is held. The batch summary is Couldn't check: it needs Polaris's AI provider.
- id: 01M6RBFN44M4T0FEVKEDMZV9J6
  author: Steve Vine
  at: 2026-11-06T11:56:39.940088Z
  text: |-
    Pre-UAT, as E2E Admin B in E2E Test Company, against the real AI provider: Passed, with one fix (COM-1620).

    What I saw:
    - **One summary for the batch.** "Looked at 2: 0 changes · 3 new checks · 0 rules · 0 still fine · 1 can't be automated · 0 couldn't."
    - **New checks side by side.** One at a time ("1 of 3", Previous / Next), with the sample and the sensitive fields highlighted.
    - **Can't be automated.** "Accept all 1" marked ACC.1 Manual only, with Polaris's full reason.
    - **Keyboard.** "D" discarded the three new checks one after another.
    - **The count is right.** The Review tab's count matched what was waiting (6) and went down as I worked (5, 4, 2). It ended "Nothing is waiting for review" for the batch.

    Fix (COM-1620): the summary line recounted as I worked and ended "0 new checks · 0 can't be automated", losing what Polaris found. It now keeps the batch's own counts and adds "N still to review" or "All reviewed".

    Screenshot: ~/compass-uat/s5khbev/COM-1610/
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint "Checks - Coverage and batch work" (COM-1605). Builds on COM-1609. This is the batch form of the one-at-a-time reviews from the previous sprint (COM-1601, COM-1603, COM-1604).

## What people see

- **Posture ▸ Checks ▸ Review**, a tab with a count. It holds everything waiting for a person: Polaris's proposals from any batch or single job, and captures held for review (COM-1603). Problems on the main tab link here.
- **A finished batch opens as a summary:** "Polaris looked at 52 controls: 31 still fine · 14 new checks · 4 changes proposed · 3 can't be automated · 0 couldn't". Each group is a filter of the queue.
- **Working the queue, one group at a time:**
  - **Still fine:** **Approve all 31** in one go, or open any one first.
  - **New checks / changes proposed:** one at a time, with **Next** and keyboard shortcuts (A approve, D discard, → next). Each shows:
    - what's proposed beside what's there now (for a change);
    - a sample capture with sensitive-looking fields highlighted and **Leave out** beside each;
    - the coverage claim (Fully / Partly + note) and any rule.
    - Approving a change swaps the check over (COM-1604); approving a new check makes it live (COM-1601).
  - **Can't be automated:** each with Polaris's reason, **Accept all** (sets Manual only with that reason, COM-1607) or one at a time.
  - **Held captures:** the COM-1603 side-by-side, with Confirm / Leave out / Discard, and "Ask Polaris" for a batch of them.
- **Filters:** by batch, kind, control domain, integration, and who started it.
- **Nothing in the queue is ever applied without a person.** A proposal not acted on for 30 days is marked stale ("the system may have changed since"). Re-validate refreshes it.
- **The queue empties as it's worked.** Each decision is in the activity log and on the check's history.

## Notes (technical)

- One list over `polaris_proposals` (COM-1599) plus held captures, with server-side grouping and counts. Approve-all is one request with the proposal ids, applied one by one in a transaction per item, so one bad item doesn't block the rest. It reports "30 approved, 1 couldn't: <why>".
- The keyboard shortcuts must not fire inside text inputs.
- "Polaris · Review" actions (COM-1599) link here, filtered to the starter's batch.

**Chain:** on the chain (API).

**Done when:** with a fake provider, a batch producing all five outcomes shows the right summary; Approve all applies every still-fine item; a change swaps its check; Accept all marks the controls Manual only with reasons. On staging, the Review tab's count matches what's waiting, and empties as it's worked. Without a provider key, the Polaris parts are Couldn't check.