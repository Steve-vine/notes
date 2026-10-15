---
id: 01M4ZTE8C0F7Y61PVTAEN9JKPT
created: 2026-10-15T13:01:20.128515Z
updated: 2026-10-15T13:01:35.849231Z
type: task
title: The assistant can read your Actions and a company's Compliance — what's asked of you, where the company stands, and how that has moved over time
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 984
sprint: sadf3j6
blocked_by:
- 01M4ZTA4GTXVEB7VCA28HW24TV
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 70, Content - Build MCP (ADR in COM-974). Built on COM-975. Overview batch. Both areas are read-only, as Steve decided on 2026-10-15.

## What people can ask of it

- **Actions:**
  - everything asked of you, across every module, as your Actions page lists it, each with where it comes from, what's asked and by when;
  - the assistant reads only what your Actions page shows you, so items from Vendors or Access appear when the page shows them;
  - the assistant can't act on an item. It points you to the screen.
- **Compliance, for a named company:**
  - where the company stands today: overall and per framework, at the level it's working towards, and per domain;
  - how that has moved over time, with the notes people have added to the timeline;
  - which controls or requirements are holding a figure down.
- **Example:** "What's on my plate this week?" or "How has Acme's ISO 27001 compliance moved since July, and what's holding it back?"
- The Dashboard is left out (COM-974). Compliance covers the same figures.

## Notes (technical)

- These wrap `actions.py`, `posture_compliance.py` and `posture_timeline.py`, and read `posture_annotations.py` (read only, no writes).
- Timeline series can be long, so the tool takes a date range and a framework, and returns points plus a one-line summary of the change.
- Actions is universal (ADR 0055 §1). The route decides each row's audience, so the tool adds no filter of its own.

**Done when:** on staging, the assistant answers "what's on my plate" for Steve and "how has compliance moved" for a company, matching the two screens.