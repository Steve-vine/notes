---
id: 01KZ11KFWZWD555D6XEYDAWG2E
created: 2026-08-02T10:51:35.199665Z
updated: 2026-08-07T10:56:04.28691Z
type: task
title: 'Events: subheading + restyle filters to match Incidents (ISE-478)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 480
sprint: sfv5yw0
blocked_by:
- 01KZ117G77Z9DFWS8KNYF26K55
comments:
- id: 01KZ1QVM5V1G3N6N4DTZDTM4G4
  author: Steve Vine
  at: 2026-08-02T17:20:30.39501Z
  text: |-
    Done — PR #423, merged to staging (ad22ce7), staging CI green and deployed.

    Subheading changed, and the Source/Type/Outcome/Level dropdowns plus the time-window control now fold into a labelled section below the search row, matching ISE-478.

    Backend change: Events had NO free-text search at all, so the search box needed a new `q` param on GET /api/v1/events (title match, escaped ILIKE like Incidents and Alerts). API types regenerated.

    One deliberate difference from Incidents: Events defaults to a 7d window, so "no filters" is not the same as "empty filters". Clear resets the window to 7d rather than to All — a clear button that silently WIDENED the query it was asked to reset would be worse than none. The window only counts toward the filter badge when it differs from that default.

    This screen had no tests at all; it has four now, plus a backend test covering case-insensitivity, a literal % and whitespace-only input.
assignee: steve
priority: medium
task_status: done
---
UI tweaks on the Events page.

1. **Subheading** — change to: "Events pushed to ISE by other systems"
2. **Restyle** — restyle the Events window to follow the same look and function as Incidents after ISE-478: text search box with X clear button, collapsible extended filter section on the line below, headings above the dropdown filters, and the same styling on text and dropdown boxes.

Depends on ISE-478 (Incidents filter restyle) as the reference pattern.