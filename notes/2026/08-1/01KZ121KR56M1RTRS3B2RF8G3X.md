---
id: 01KZ121KR56M1RTRS3B2RF8G3X
created: 2026-08-02T10:59:17.893974Z
updated: 2026-08-06T07:28:24.712754Z
type: task
title: 'Estate: subheading, Incidents-style filters, tag search, new filter dropdowns, integration names'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 482
sprint: sfv5yw0
blocked_by:
- 01KZ117G77Z9DFWS8KNYF26K55
comments:
- id: 01KZ1QWC0D5BA3WSZ43A27ERMH
  author: Steve Vine
  at: 2026-08-02T17:20:54.797233Z
  text: |-
    Done — PR #429, merged to staging (ad22ce7), staging CI green and deployed. All five items covered.

    Integrations column now NAMES them. "3 integrations" told you how many but never which, so the column could not answer the question it exists for. Built from the same entity_alias rows the count comes from so the two cannot disagree; past two it folds to a count with the names on hover, so a widely-known entity does not stretch the row.

    Second search box for tags, matched on the rendered key:value label — what the badges and the tag cloud already show, so what you read is what you can type. "env:" finds every environment; a bare valueless tag like "legacy" matches on its key alone.

    New Integration filter plus First Seen / Last Seen ranges. A date input gives a bare day, so the "to" end is stretched to 23:59:59 — otherwise picking today returns nothing. A range counts as ONE filter on the badge, since both ends answer one question.

    TWO THINGS TO CONFIRM ON SMOKE TEST:
    1. I used native date inputs rather than adding @mantine/dates — that package plus its dayjs peer is not worth two fields on a bundle already over the size warning, and the browser gives a real calendar regardless. Say if you'd rather have the Mantine picker and I will add the dependency.
    2. Subheading reads "Entity details and relationships" — I assumed "Entitly" was a typo.

    Backend: tag, system_id and four date-range params on GET /api/v1/entities, plus `integrations` on the list row. The three separate localStorage filter keys collapse into one under a new key, so remembered Estate filters reset once.
assignee: steve
label: null
priority: medium
task_status: done
---
UI tweaks on the Estate page.

1. **Subheading** — change to: "Entity details and relationships" (Steve typed "Entitly" — assumed typo).
2. **Restyle** — restyle the Estate window to follow the same look and function as Incidents after ISE-478: text search box with X clear button, collapsible extended filter section on the line below, headings above filters, same styling on text and dropdown boxes.
3. **Tag search** — add a second search text box for tags.
4. **New filters** — add additional filter dropdowns for "Integration", "First Seen" and "Last Seen" — the latter two being date range pickers.
5. **Integrations column** — change the integrations column so that it names the integration(s).

Depends on ISE-478 (Incidents filter restyle) as the reference pattern.