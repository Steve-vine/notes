---
id: 01M3ST5CD5DJVFRDQDDWAGMTZ4
created: 2026-09-30T18:45:20.933011Z
updated: 2026-10-01T01:51:45.52652Z
type: task
title: Admin, Activity and System status in the new layout
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 812
sprint: s0zzctz
blocked_by:
- 01M3ST04QGV1F3BH3F9J4XDZXK
comments:
- id: 01M3TJJ122HFMFKKA6TWD1R910
  author: Steve Vine
  at: 2026-10-01T01:51:41.122011Z
  text: |-
    Done: PR #821, merged to main (0a609e9).

    What you'll see:
    - **Admin:**
      - the new header, with its sections on the tab bar (folding into More when they don't fit);
      - each rubric, review cadence, integration and the attachment store as a card with its own Save;
      - the lists (users, roles, companies, API tokens, SSO mappings, files, email transports) with their buttons lined up on the right, and Active/Disabled as dots.
    - **Activity:** the new header, the same three filters (what, action, this company only) in a filter bar, and each change marked with a coloured dot (created, updated, deleted).
    - **System status:**
      - three cards at the top: workers online, jobs waiting, and the oldest waiting job;
      - the scheduled-jobs table now has separate Last ran, Took, Outcome and On schedule columns;
      - the charts in the new colours.

    Small things decided while building:
    - **Email** now lists the transports as a table; picking one opens its details underneath.
    - **The two worker lanes on the charts** are cyan and violet, with the second line dashed, so they stay tellable apart for colour-blind readers. The old blue/purple pair wasn't.
    - **Activity's filters** still aren't kept in the address, as before. That would be a small follow-up if you want it.

    All checks passed.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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