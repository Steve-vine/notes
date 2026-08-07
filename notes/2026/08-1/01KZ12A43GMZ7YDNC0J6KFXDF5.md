---
id: 01KZ12A43GMZ7YDNC0J6KFXDF5
created: 2026-08-02T11:03:56.784152Z
updated: 2026-08-07T10:35:43.496185Z
type: task
title: 'Proposals: subheading + restyle filters to match Incidents (ISE-478)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 484
sprint: sfv5yw0
comments:
- id: 01KZ1QX6BVZ8P2Z83FE9TJG2WA
  author: Steve Vine
  at: 2026-08-02T17:21:21.787745Z
  text: |-
    Done — PR #426, merged to staging (ad22ce7), staging CI green and deployed.

    Subheading changed; Status/Kind/Source dropdowns fold into a labelled section below the top row.

    Added free text over the EVIDENCE — the sentence a reviewer actually reads — since kind and source are already dropdowns, so the claim itself is the only thing left worth typing. "What did we decide about checkout?" used to be a scroll. New `q` param on GET /api/v1/proposals with the same escaped-ILIKE contract as the other screens.

    Like Events, "no filters" is not "empty filters" here: the queue opens on status=proposed because decided rows are history. Clear returns it to proposed rather than showing every decision ever made.

    Note: this PR's first CI run failed on MasterIncidents.test.tsx, a file it does not touch — the known load flake. Passed on re-run.
assignee: steve
priority: medium
task_status: done
---
UI tweaks on the Proposals page.

1. **Subheading** — change to: "Things ISE believes it has learned and cannot assert on its own"
2. **Restyle** — restyle the Proposals window to follow the same look and function as Incidents after ISE-478: text search box with X clear button, collapsible extended filter section on the line below, and the same styling on text and dropdown boxes.

Depends on ISE-478 (Incidents filter restyle) as the reference pattern.