---
id: 01M5YA8JFC9Q3C8QJV0SC6J8GZ
created: 2026-10-27T09:15:04.044042Z
updated: 2026-10-28T18:17:05.391273Z
type: task
title: A technology asset's page shows its open vulnerabilities, and an owner without an internal role sees and works theirs in the User Portal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1372
sprint: s6wypy5
blocked_by:
- 01M5YA6ZNQ5Q5CGV8DXB00MQ41
- 01M5YA7DPCE2V1RDSDZBKK1XN5
comments:
- id: 01M5ZSBRH9XM1ZM0K3WVEXS9WY
  author: Steve Vine
  at: 2026-10-27T22:58:11.625138Z
  text: |-
    Built and merged: PR #1387.

    **What's there**
    - **Inventory ▸ a technology asset** has a **Vulnerabilities** card: open counts by severity, the overdue count and the five most severe, each a link. "See all" opens the Register for that system. It's shown to anyone who can view the asset and view vulnerabilities, and sits beside the Findings card until sprint 93.
    - **User Portal ▸ Vulnerabilities** (a new menu entry) lists the ones assigned to the person. Opening one shows its details, where it is, the recommendation and the timeline. They can:
      - comment;
      - **mark fixed**, for hand-recorded or pen-test ones only (a scanner's one says why not);
      - **ask for it to be accepted**.
      They can't accept, change severity or reassign.
    - **User Portal ▸ an owned asset** lists what's open on it.
    - **Asking for acceptance** adds a comment with their reason. Everyone who can accept gets an action, "Decide whether to accept VUL-12", until its state changes. The Fix card inside says who asked and when.
    - Nobody else's is reachable from the portal; the tests check every route.

    **My calls**
    - On a portal owner's asset, **every open vulnerability on the system is listed**, but only the ones assigned to them open. The rest are someone else's to fix.
    - The "decide whether to accept" action goes to everyone with *Accept vulnerabilities*, except whoever recorded or owns that one.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). Builds on COM-1367 and COM-1368.

## What people see

- **Inventory ▸ a technology asset:** a **Vulnerabilities** card.
  - It shows open counts by severity, the overdue count, and the five most severe, each a link.
  - "See all" opens the Register filtered to that system.
  - Shown to anyone who can view the asset *and* view vulnerabilities.
  - Until sprint 93 it sits beside the existing Findings card; sprint 93 folds that one in.
- **User Portal ▸ Inventory** (owners without an internal role, ADR 0072 §10):
  - each of their assets shows its open vulnerabilities;
  - a **Vulnerabilities** list shows those assigned to them, with the fix-by date and state.
  - Opening one shows its details, where it is, a recommendation and the timeline.
  - They can:
    - **comment**;
    - **mark fixed** (hand-recorded and pen-test only, as inside);
    - **ask for it to be accepted**, which leaves a comment and an action for the people who can accept.
  - They can't accept, change severity or reassign.

## Who can do what

- Inside: view vulnerabilities, plus the asset's own visibility.
- Portal: the vulnerability's owner only.

## Notes (technical)

- Portal endpoints under `/api/v1/portal`.
- **Add the new portal write routes to the exact-set test** in `tests/test_portal.py`. It runs as an integration test, so a miss only shows red on CI.
- Owner-only checks on every portal route.

**Chain:** on the chain (API).

**Done when:**
- the asset card shows true counts;
- a portal-only owner can find, comment on and mark fixed their vulnerability, and ask for acceptance;
- nobody else's vulnerabilities are reachable from the portal.