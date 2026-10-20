---
id: 01M572VTYY0XW96WBA93P2X4MP
created: 2026-10-18T08:43:14.782375Z
updated: 2026-10-20T12:18:19.146584Z
type: task
title: Incidents opens on an Overview — what's open now by severity, incidents by category over the last twelve months, how fast they're contained and recovered, and how often notifications went out on time
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1079
sprint: serbigk
blocked_by:
- 01M572TC5E35KF0JEX9T9B3BK0
comments:
- id: 01M583DV8Y0CSEMNNH7E26F735
  author: Steve Vine
  at: 2026-10-18T18:12:19.358804Z
  text: |-
    Done: merged in PR #1078.

    - Incidents now opens on an **Overview** tab, with the **Register** as the second tab. Old register links still open the Register.
    - **Open now:** open incidents by severity (P1–P4) and how many are still in triage. Each card opens the register filtered to what it counts.
    - **Needing attention:** notifications due within 24 hours or overdue, post-incident reviews overdue, and reports waiting for triage. Each item opens the incident at the right card. Restricted incidents are counted but appear as "And 1 restricted incident you can't open".
    - **For the chosen period** (Last 12 months by default, This year, Last year or Custom):
      - incidents in the period;
      - reports triaged out, counted on their own;
      - notifications on time ("7 of 8 sent by the deadline");
      - lessons into action (corrective actions raised, and how many are still open).
    - **Monthly chart by category:** stacked bars, noting that an incident with two categories counts in both and that triaged-out reports are left out.
    - **How fast:** median time to triage, to contain and to recover, compared with the period before.
    - Checked in a real browser, light and dark, and the chart renders cleanly.

    Choices made:
    - "Open now" includes reports still in triage, so each severity card matches what the register shows for the same filter.
    - "How fast" follows the period picker rather than always comparing quarters, so it compares like with like.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 76, Incidents - Register (ADR in COM-1063). Builds on closure (COM-1075). It is the input to management review (INS.19, ISO 9.3 "trends in nonconformities and incidents").

## What people see

**Incidents ▸ Overview** (the module's first tab; the register is the second):

- **Open now**: the count by severity (P1–P4), plus how many are still in triage.
- **Needing attention**: notifications due within 24 hours or overdue, reviews overdue, and reports waiting for triage. Each links through.
- **Last 12 months by category**: a monthly chart, one series per category. An incident with two categories counts in both, and the chart says so.
- **How fast**: the median time to triage, to contain and to recover, this quarter against last.
- **Notifications on time**: of the notifications decided as sent in the period, how many went out by their deadline.
- **Lessons into action**: corrective actions raised from reviews, and how many are still open.
- A period picker: last 12 months, this year, last year, custom.

## Rules

- Triaged-out reports (not an incident, duplicate) are left out of the charts but counted on their own ("31 reports triaged out"). Lots of false alarms is a healthy reporting culture, and the Overview shows it.
- Restricted incidents count in the numbers; drill-downs only show them to people who can see them (COM-1076).

## Notes (technical)

- Use `@mantine/charts` at the pinned version (memory: charts version pin). A many-series chart needs a real-browser look before merge.

**Done when:** the Overview shows the cards above for the chosen period, with counts that match the register.