---
id: 01M87AY1QMGKFPP71QRWHM4SEZ
created: 2026-11-24T17:51:21.332778Z
updated: 2026-11-24T20:45:19.344749Z
type: task
title: 'ADR 0175 (vendor engagement departments): one or more departments per engagement, then mark Accepted'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2146
sprint: sectbn9
comments:
- id: 01M87MWJ4E8AFH1WZR7S0V67XZ
  author: Steve Vine
  at: 2026-11-24T20:45:18.350516Z
  text: |-
    Merged to main: PR #2136 (809845f30). Docs only.

    ADR 0175 is now Accepted (2026-11-24), amended in place:
    - An engagement records one or more departments: at least one required, no upper limit, and an edit can't leave it with none. Engagements that had one keep it, and older ones read "Not recorded" until edited.
    - A filter matches a vendor when any of its live engagements has any chosen department. Ended engagements don't count.
    - New §6 "Showing, filtering and requesting": department per engagement line on the portal's expanded list (COM-2145); the Compass register shows a vendor's departments together; requests and amendments carry the set (COM-2148); a request's summary follows Edit request (COM-2143).
    - "Steve's decisions (2026-11-24)" records the change from "exactly one", and that his other calls stand (a rename changes past engagements too, who can read the list, no starter list).
    - CLAUDE.md's key-ADR line now says "one or more".
assignee: steve
label:
- chore
priority: low
task_status: review
---
Sprint "Vendor Departments". Steve accepted ADR 0175 on 24 Nov 2026, and the same evening amended it so that an engagement can have several departments (COM-2147, COM-2148).

The repo's copy of 0175 is still marked Proposed, so it's amended before being marked Accepted, rather than superseded:
- "Each vendor engagement records exactly one department" becomes "one or more departments, at least one required".
- Record Steve's other decisions: the portal's expanded vendor list shows departments on each engagement line, not the vendor's row (COM-2145); the Compass register shows a vendor's departments together because it lists no engagement lines; and a request's summary follows Edit request (COM-2143).
- Then set Status to **Accepted (2026-11-24)**.

Independent (docs only). Best merged with or just before COM-2147.