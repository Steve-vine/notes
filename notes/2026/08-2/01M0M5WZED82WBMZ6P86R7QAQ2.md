---
id: 01M0M5WZED82WBMZ6P86R7QAQ2
created: 2026-08-22T07:27:56.365416Z
updated: 2026-08-22T08:12:06.285815Z
type: task
title: Create a new Modules section under the Company section
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 340
sprint: s7jknet
comments:
- id: 01M0M8DGX79R12T98ENPA1BJ8J
  author: Steve Vine
  at: 2026-08-22T08:11:55.687216Z
  text: |-
    Done — PR #342, merged to main as d0e37c6.

    A Modules section now sits directly under Company. Nothing changes on screen from this task alone: the section is empty until Vendor Management moves in (COM-341), and a section with no visible items renders no header.

    Modules deliberately carries no section-wide gate (SECTION_GATE.Modules = null) — each module names its own, and the header appears once one of them is visible. A new nav.test.ts guards that: any item in an ungated section must name a gate, or it leaks to accounts that cannot read what it points at.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Add a new navigation menu section called **Modules**, positioned directly under the **Company** section. (The Vendors menu item moves into it in a follow-on task.)