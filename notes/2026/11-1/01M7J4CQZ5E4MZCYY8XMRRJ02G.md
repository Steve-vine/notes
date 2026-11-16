---
id: 01M7J4CQZ5E4MZCYY8XMRRJ02G
created: 2026-11-16T12:12:59.749055Z
updated: 2026-11-16T12:13:09.622924Z
type: task
title: 'Check page: a Details section says what the check does, "Latest capture" becomes "Evidence" showing only the evidence itself, and picking a History entry shows that capture''s evidence'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1870
sprint: s7nqsy0
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Asked for by Steve while testing sprint "Automation - Workflows" on staging (2026-11-16).

## Today

- What the check does sits in a side panel called About.
- "Latest capture" shows the Review sample table: the first 10 rows, with the column tools (rename, move, lookups and other mappings).
- History lists every capture, but picking one doesn't show its evidence.

## Done when

- **Details** is a section that says what the check does:
  - **Description** (its About text);
  - **Reads**;
  - **Schedule**, with when it next runs;
  - **Evidences**: the control, linked, fully or partly;
  - **Approved by**: who approved it, and when.

  It replaces the side About panel. (When COM-1866 lands, the date it collects by goes here too.)
- **Evidence** replaces "Latest capture". It shows only the capture's evidence: its table of items, columns as the check names them, every item, paged or scrollable. The column tools, mappings and other controls are removed (column changes stay on the control's Evidence tab and in Review). A capture with no items says so.
- **History** stays as it is, but picking an entry shows that capture in the Evidence section. A line names which capture is shown (period and when it was taken), with **Back to latest**. The entry stays highlighted. A held capture still opens its review as today.
- Order on the page: Details, Evidence, History, Workflows. The side column keeps Changes.
- Tests cover: Details shows each item; Evidence shows every item with no column tools; picking a History entry shows that capture, and Back to latest returns.

Independent, unless showing a past capture's full items needs an API route (it then joins the chain).