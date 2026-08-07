---
id: 01KZ12R0MYRE8PKDAK3WZQXHJA
created: 2026-08-02T11:11:31.998041Z
updated: 2026-08-07T09:40:51.278604Z
type: task
title: 'Audit: subheading + restyle filters to match Incidents (ISE-478), sortable columns'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 489
sprint: sfv5yw0
comments:
- id: 01KZ1QYYJTBZG9BZBWDCXVVT2T
  author: Steve Vine
  at: 2026-08-02T17:22:19.354342Z
  text: |-
    Done — PR #424, merged to staging (ad22ce7), staging CI green and deployed.

    Subheading trimmed; search box gained its X clear button; new Action and Entity type dropdowns fold into a labelled section; all four columns sort.

    FOUND A REAL BUG WHILE DOING IT: the existing "Filter by actor…" box sent an `actor` param that the API matched with `==`. Typing part of an email returned an empty trail — indistinguishable from "nothing happened". Added `q` as a substring search over the actor and left `actor` as the exact-match drill-down, rather than quietly changing what an existing parameter means.

    Backend: q, sort/dir over a restricted column set, and a new /audit/facets endpoint so the dropdowns offer only values that exist. `at DESC` is the tiebreak under every sort, and NULLS LAST in both directions — entity_type is nullable, so "sort by entity" would otherwise have opened on a block of rows with no entity at all.

    First dedicated tests for this screen, plus backend tests covering the substring search, the escaped %, and the sort whitelist rejecting injection.
assignee: steve
label: null
priority: medium
task_status: done
---
UI tweaks on the Audit page.

1. **Subheading** — change to: "Append-only record of who did what."
2. **Restyle** — restyle the Audit window to follow the same look and function as Incidents after ISE-478: text search box with X clear button, collapsible extended filter section on the line below, the same styling on text and dropdown boxes, and sortable columns.

Depends on ISE-478 (Incidents filter restyle) as the reference pattern.