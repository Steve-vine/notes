---
id: 01M0M5X1GTPM08CZNHYZR3H4YV
created: 2026-08-22T07:27:58.490797Z
updated: 2026-08-22T08:16:16.756334Z
type: task
title: Move Vendors into Modules as "Vendor Management" and delete the Vendors section
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 341
sprint: s7jknet
blocked_by:
- 01M0M5WZED82WBMZ6P86R7QAQ2
comments:
- id: 01M0M8NAFQKRVA3J5EKDHJEVAE
  author: Steve Vine
  at: 2026-08-22T08:16:11.254973Z
  text: |-
    Done — PR #343, merged to main as 13a5d05.

    The Vendors menu item is now "Vendor Management" inside Modules, and the one-item Vendors section header is gone.

    Gate and URL unchanged: the item carries `gate: 'Vendors'`, /vendors keeps RequireSection section="Vendors", so every existing link still lands where it did.

    Test: a vendor_manager sees Modules holding exactly Vendor Management, and no Vendors header.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Move the **Vendors** menu item from the **Vendors** section into the new **Modules** section, rename it to **Vendor Management**, and delete the now-empty **Vendors** section header.

Depends on the task that creates the Modules section.