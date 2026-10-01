---
id: 01M3W3VHP1K852SWHMSXFWVHAG
created: 2026-10-01T16:13:13.281107Z
updated: 2026-10-01T21:16:02.585105Z
type: task
title: OU List
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 822
sprint: s0zzctz
comments:
- id: 01M3WN5W4CW59V2DM0TV8F9GAD
  author: Steve Vine
  at: 2026-10-01T21:15:57.452739Z
  text: |-
    Merged: PR #836 (05e661a).

    On Admin ▸ Integrations, the Active Directory card's list of OUs now sits in a folding section — "Organisational units" with the count beside it — together with its Save button.

    - Folded when at least one OU is already managed. Anything wrong with the choice (missing rights) is still shown above the fold, so it can't be hidden.
    - Open while nothing is managed yet, because ticking OUs is the next step.
    - The "Managed OUs" heading and explanation, the rights warnings and "Default OU for new starters" stay outside the fold. Ticks made before folding are kept.

    To check on staging: Admin ▸ Integrations ▸ Active Directory — the list should arrive folded; click "Organisational units" to open it.

    Technical: admin/DirectoryIntegrations.tsx, using the kit's Section. Not seen in a browser — covered by tests only (fold closed with a managed OU, open with none, tick-and-save through the fold).
assignee: steve
label: null
priority: medium
task_status: review
---
On Admin->Integration Active Directory card, put the list of OU's in a collapsable section.