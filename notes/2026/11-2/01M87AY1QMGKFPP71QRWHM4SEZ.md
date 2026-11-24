---
id: 01M87AY1QMGKFPP71QRWHM4SEZ
created: 2026-11-24T17:51:21.332778Z
updated: 2026-11-24T20:42:21.342658Z
type: task
title: 'ADR 0175 (vendor engagement departments): one or more departments per engagement, then mark Accepted'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2146
sprint: sectbn9
assignee: steve
label:
- chore
priority: low
task_status: active
---
Sprint "Vendor Departments". Steve accepted ADR 0175 on 24 Nov 2026, and the same evening amended it so that an engagement can have several departments (COM-2147, COM-2148).

The repo's copy of 0175 is still marked Proposed, so it's amended before being marked Accepted, rather than superseded:
- "Each vendor engagement records exactly one department" becomes "one or more departments, at least one required".
- Record Steve's other decisions: the portal's expanded vendor list shows departments on each engagement line, not the vendor's row (COM-2145); the Compass register shows a vendor's departments together because it lists no engagement lines; and a request's summary follows Edit request (COM-2143).
- Then set Status to **Accepted (2026-11-24)**.

Independent (docs only). Best merged with or just before COM-2147.