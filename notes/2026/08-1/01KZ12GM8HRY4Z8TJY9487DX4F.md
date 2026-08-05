---
id: 01KZ12GM8HRY4Z8TJY9487DX4F
created: 2026-08-02T11:07:29.937745Z
updated: 2026-08-05T19:29:25.566133Z
type: task
title: 'Alerts: subheading + restyle filters to match Incidents (ISE-478), sortable columns'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 486
sprint: sfv5yw0
comments:
- id: 01KZ1QXX315KNZ5GERVTBK6H49
  author: Steve Vine
  at: 2026-08-02T17:21:45.057313Z
  text: |-
    Done — PR #428, merged to staging (ad22ce7), staging CI green and deployed.

    Subheading now "Signals raised by integrations"; dropdowns fold into a labelled section; Severity / Signal / Kind / Status / Confidence / Last seen all sort server-side via new sort+dir params on GET /api/v1/findings.

    Worth knowing: severity and status are ranked by MEANING, not text. Sorting severity alphabetically gives critical, high, info, low, medium — which looks sorted and is not, on the column an operator reaches for first. Reused the ordinal approach Incidents proved in ISE-208. Nulls sort last in both directions (an Alert has no confidence), and every sort ends with last_seen_at desc as a tiebreak so the polled, paged list cannot shuffle a signal onto two pages or neither.

    System deliberately does NOT sort — it is resolved to a name client-side from a separate query, so the server cannot order by what is displayed.

    The status filter is renamed "Signal Status" to match its heading. Since Alerts and Observations are one component, this restyle serves both screens and completes ISE-487's restyle half.
assignee: steve
priority: medium
task_status: done
---
UI tweaks on the Alerts page.

1. **Subheading** — change to: "Signals raised by integrations"
2. **Restyle** — restyle the Alerts window to follow the same look and function as Incidents after ISE-478: text search box with X clear button, collapsible extended filter section on the line below, the same styling on text and dropdown boxes, and sortable columns.

Depends on ISE-478 (Incidents filter restyle) as the reference pattern.