---
id: 01M68R9HGABR6BVSCKQWDRS4A4
created: 2026-10-31T10:32:40.202923Z
updated: 2026-11-01T02:36:16.620491Z
type: task
title: Policy reviews join the portal — a named reviewer sees "My policy reviews", reads the current version, and records their review there
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1494
sprint: snvd637
comments:
- id: 01M6AFDYVC30BJAXTRQ7YVQXYY
  author: Steve Vine
  at: 2026-11-01T02:36:16.620341Z
  text: |-
    Done, merged to main in PR #1512 (bed416c0).

    What people see:
    - A **Policies** menu item for anyone named as a reviewer on a policy or other library content. This includes accounts that only attest. **My policy reviews** lists what they review and when each is next due.
    - The review page shows the published document and its review history. The reviewer records one of two outcomes:
      - **No changes needed**: the next review date moves on by the content type's review cadence.
      - **Changes needed**, with what should change (required): this creates an action, "Content — Make the changes", for the library team. It's due 30 days later, and they're emailed about it from 14 days before. It closes when a new version or file is published, or when a later review records no changes.
    - Their My actions rows for reviews open this page.

    Things to know:
    - This adds migration 0752 to record each review's outcome. Existing reviews are recorded as "No changes needed". It's safe on a populated database.
    - ADR 0137 is amended to cover the new action.

    Setting up on staging for UAT: add E2E Asset Owner as a reviewer on a published policy that's due for review. The policy's type needs a review cadence, or the date has nothing to move by.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 80, Update user portal. Steve chose this on 2026-10-31 in answer to "which other modules should the portal have?".

## Why

A policy, standard or procedure can name reviewers, such as the department head whose area it covers. A portal-only reviewer gets the "review due" action with nothing to open.

## What people see

- A **Policies** menu item, shown to anyone named as a reviewer on any content. Nobody else sees it.
- The page is **My policy reviews**. It lists the content they review, with its title, type (policy, standard, procedure, runbook), version, last review and next review date. Due and overdue reviews come first.
- Opening one shows the **current published version** to read, the same as the PDF view, plus its review history. The reviewer can **record their review** in one of two ways:
  - **No changes needed**: the next review date moves on;
  - **Changes needed**, with what should change: the content's owner gets an action to make the changes.
- Editing the content stays internal.
- Their My actions rows for these reviews open this page.

## Notes (technical)

- Add `/api/v1/portal/content-reviews` reads, scoped to `ContentReviewer` rows for the caller, and a review write that reuses the existing content review service (`playbook_review_content` uses the same one). Add the write route to the allowlist test in `tests/test_portal.py`.
- In `links.py`, rewrite `/content/{slug}` to the portal review page for a reviewer only. An owner's link stays internal, so `links.py` needs to know the action's type, not only its link.
- Find out whether "Changes needed" already exists as an outcome. If it doesn't, the action for the owner is new: add it to COM-1468's per-type table.

**Chain:** on the chain (new portal API).

**Done when:** on staging, E2E Asset Owner is named a reviewer on an E2E Test Company policy that is due for review. Signed in as them, Policies lists it, they can read it and record "No changes needed", and its next review date moves on.