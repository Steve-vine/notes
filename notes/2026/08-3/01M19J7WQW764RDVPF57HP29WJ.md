---
id: 01M19J7WQW764RDVPF57HP29WJ
created: 2026-08-30T14:47:40.028247Z
updated: 2026-08-30T15:32:43.682345Z
type: task
title: Extra fields are configured where they are used — an Admin tab in Access Control
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 538
sprint: sz42uhw
comments:
- id: 01M19JT9STZYM230QSSM0SCER7
  author: Steve Vine
  at: 2026-08-30T14:57:43.226167Z
  text: |-
    Shipped — PR #541, merged to main as 17fb693.

    Access Control's tab bar ends with **Admin**, and the extra-fields section lives there. It has left the main Admin page entirely, so there is one place rather than two.

    The tab is the first in that bar not readable by the whole Access read set, so the list is now filtered by permission rather than rendered wholesale — an Access Reviewer, who fills fields in but does not define them, does not see a tab offering something they would be refused. The page guards again on its own: a hidden tab is not a closed door, and the URL is typeable.

    It lands as a section with one card rather than a single screen, so the next piece of Access configuration arrives beside it instead of costing the tab bar another entry — the argument the Rubrics tab already settled on the Admin page.

    Closes the question COM-528 left open. An Access Manager can now define extra fields through the screen as well as the API, which was always the intent.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: done
---
COM-528 put the extra-fields admin screen on the main Admin page, and that page is admin-only. The API guard is the Access write set — admin, access_manager, access_admin — so an Access Manager can define fields through the API and cannot reach the screen that does it. The two halves have never met.

It is also the wrong place on its own terms. Extra fields describe directory objects, are filled in from the Access screens, and are read back in Access reports. Configuring them two sections away, behind a role that has nothing to do with the directory, puts the setting furthest from everybody who uses it.

## What changes for the reader

Access Control gains a final tab, **Admin**, and the extra-fields section moves into it. It leaves the main Admin page entirely — one place, not two.

The tab appears only for somebody who may use it: the Access **write** set, matching the guard the API already applies. An Access Reviewer, who can fill fields in but not define them, does not see a tab offering something they would be refused.

It is a section, not a single screen — one card for extra fields, with room for the next piece of Access configuration to land beside it rather than costing the tab bar another entry.

## Notes

- The tab bar in `AccessControlPage.tsx` currently renders every tab for everybody, because until now every tab was readable by the whole Access read set. This is the first one that is not, so the list needs filtering by permission — and the route needs guarding too, since a hidden tab is not a closed door.
- `/access/admin`, and the section moves out of `AdminPage.tsx` with its `extra-fields` tab value. A stale `?tab=extra-fields` bookmark falls back to the default tab, which is the existing behaviour for an unknown value.
- Last in the bar deliberately: it is configuration, and the twelve tabs before it are the work.
- `AdminPage.test.tsx` asserts the exact tab list and will need the entry removing again.
- Closes the question COM-528 left open, which was whether to open Admin to Access-write or move the tab here. This is the answer.
