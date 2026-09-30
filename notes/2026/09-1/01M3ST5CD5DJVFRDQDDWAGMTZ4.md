---
id: 01M3ST5CD5DJVFRDQDDWAGMTZ4
created: 2026-09-30T18:45:20.933011Z
updated: 2026-09-30T18:46:24.39231Z
type: task
title: Admin, Activity and System status in the new layout
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 812
sprint: s0zzctz
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The admin screens, in the prototype's patterns. Nothing they do changes, apart from Appearance, which has already gone.

## What people see

- **Admin:**
  - page header, and its sections as tabs with the overflow folding into **More**;
  - each section's settings in the kit's cards, with a clear Save where a section saves;
  - lists (Companies, Users, Tokens, SSO mappings, rubrics, review cadences, storage, email, integrations) as kit lists, with row actions in their own right-aligned column as the convention says.
- **Activity:** page header, the filter bar (who, what, when), and the audit trail as a list with a dot per kind of change.
- **System status:**
  - summary cards (workers, queues, oldest waiting job);
  - the scheduled-jobs table with ran / took / worked / overdue pills in the status tones;
  - the trend charts in the new palette.

## Notes (technical)

- **Pages:** `pages/AdminPage` and every `admin/*Section.tsx`; `ActivityPage`; `SystemStatusPage`.
- **Admin sections** are tabs today. Put the kit's tab bar on them; the tab URLs don't change.
- **The rubric editors** (maturity, risk, data) keep their editing behaviour.
- **System status charts** use [[mantine-charts-version-pin]].
- **Ratchet.** Empty these pages' entries from the page-header ratchet.

**Done when:** on staging, every Admin section, Activity and System status is in the new layout.