---
id: 01M2YYK7YQJ293QPYCPRV6F7CR
created: 2026-09-20T08:23:19.767457Z
updated: 2026-09-22T15:39:50.277017Z
type: task
title: Add group mapping button cut-off
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 732
sprint: s3nfes0
comments:
- id: 01M32QBZFT0931H052WSDRQ014
  author: Steve Vine
  at: 2026-09-21T19:33:59.418818Z
  text: |-
    Fixed in PR #742 (merged to main, 7864644).

    What changed: in the "Add group → role mapping" dialog, the Select button now keeps its full width however long the group's description is — the description wraps beside it instead of squeezing the button to "Se".

    The cause was general, so the fix is too: a button anywhere in Compass no longer shrinks under its label when the text beside it is long (same approach as the "a pill never truncates" rule).

    To check on staging: Admin → SSO → Add mapping, search "compass" — all three rows show a full "Select" button, including compass-admin with its long description.

    Technical: Mantine Button is a flex item with flex-shrink 1 and an overflow-hidden label. One theme rule (Button root flexShrink: 0) in theme.ts, with a test in theme.test.tsx.
assignee: steve
priority: medium
task_status: done
---
On the add mapping modal, a long description of a groups means the 'Select' button doesn't fit properly. Screenshot attached.
![Compass role mapping.png](attachments/2026/09/01M2YYK7YQJ293QPYCPRV6F7CR/Compass-role-mapping.png)