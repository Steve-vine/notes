---
id: 01KZ12NKYXWSYB35Y48HBXKJJY
created: 2026-08-02T11:10:13.469587Z
updated: 2026-08-07T10:57:30.751863Z
type: task
title: 'Agent runs: restyle filters to match Incidents (ISE-478), sortable columns'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 488
sprint: sfv5yw0
comments:
- id: 01KZ1QYJVAATN9BJ8X2D7FGAQY
  author: Steve Vine
  at: 2026-08-02T17:22:07.338786Z
  text: |-
    Done — PR #425, merged to staging (ad22ce7), staging CI green and deployed.

    Three dropdowns fold into a labelled section; Task / Status / Model / Tokens / Cost / When sort server-side via new sort+dir params on GET /api/v1/agent-runs.

    The search box searches the MODEL — task type and status are already dropdowns, so "show me every Opus run" is the only thing left worth typing. New `q` param, escaped ILIKE.

    System and Duration deliberately do not sort, and the code says why: System is resolved to a name client-side from a separate query; Duration is derived from two columns at read time with no stored value behind it. Sorting either would have to be page-local, which silently answers a different question from the one asked.

    Caught by the tests: sorting cost descending led with the runs that have NO recorded cost, because Postgres defaults DESC to NULLS FIRST. Now NULLS LAST in both directions. The same bug existed in the sort I had just added to Audit, so ISE-489 got the same fix.
assignee: steve
label: null
priority: medium
task_status: done
---
UI tweak on the Agent runs page — restyle the Agent runs window to follow the same look and function as Incidents after ISE-478: text search box with X clear button, collapsible extended filter section on the line below, the same styling on text and dropdown boxes, and sortable columns.

Depends on ISE-478 (Incidents filter restyle) as the reference pattern.