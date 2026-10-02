---
id: 01M3XX9QFBFWH27HMH0DAM56EA
created: 2026-10-02T08:57:09.239788Z
updated: 2026-10-02T15:59:31.648538Z
type: task
title: Business Role OU
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 834
sprint: s0zzctz
comments:
- id: 01M3XYFKEMSP23A2NBABPYY8W1
  author: Steve Vine
  at: 2026-10-02T09:17:47.86055Z
  text: |-
    Merged to main 2026-10-02 — PR #841 (acf10107). Backstop and image build green. Not yet on staging.

    What changed
    - "New starters go in" on a business role takes typing: the list narrows to matching OUs, and each match names the OUs above it ("Staff › Sales") so same-named OUs can be told apart. Typing several words searches the path too — "sales users" finds the Users under Sales.
    - The chosen OU's name sits flush left in the box.
    - The "Default OU for new starters" picker on Admin ▸ Integrations ▸ Active Directory had the same two problems and gets the same picker.

    Technical
    - Cause of the offset: the tree was drawn by padding each option's label with non-breaking spaces, and the closed box shows the label.
    - New components/OuSelect.tsx (label = bare name, indent drawn per option, custom filter over name + parent OUs) and components/ouPath.ts (parent OUs read from the DN). No API change.
    - Tests: components/OuSelect.test.tsx; RolesPage.test.tsx tightened to assert the box holds the name exactly.

    To smoke-test: open a business role, type part of an OU name in "New starters go in", pick one, check it sits level with the Owner above it; same on the Admin AD card's default OU.
- id: 01M3Y0Z8ECDVTEVRGHQVQ4F6S1
  author: Steve Vine
  at: 2026-10-02T10:01:18.027859Z
  text: On staging 2026-10-02 as staging-20261002-0959 (deploy run 36992939454, smoke check green). All pods on the new image, no restarts. Ready for smoke test.
assignee: steve
label: null
priority: medium
task_status: review
---
When selecting the correct OU for a business role new starter, a very long list can be difficult to navigate. Add a search text box so that the user can type in the name of the OU to find it.

Secondly, once selected the OU name is offset slightly in the text box for some reason, screenshot attached.
![CleanShot 2026-10-02 at 09.55.00.png](attachments/2026/10/01M3XX9QFBFWH27HMH0DAM56EA/CleanShot-2026-10-02-at-09.55.00.png)

