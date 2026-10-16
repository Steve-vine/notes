---
id: 01M4ZTDCPXP9ED0ZZB58A95G66
created: 2026-10-15T13:00:51.80547Z
updated: 2026-10-16T07:29:12.12412Z
type: task
title: The assistant can read and write Decisions — draft a decision record, revise it, and link it to the controls, risks and content it concerns
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 982
sprint: sadf3j6
blocked_by:
- 01M4ZTA4GTXVEB7VCA28HW24TV
comments:
- id: 01M50TTBXEGZ5NQD1N24PJ8GM3
  author: Steve Vine
  at: 2026-10-15T22:27:11.40589Z
  text: |-
    On staging 2026-10-15 23:26 BST (PR #973). The assistant lists and reads decisions (by D-12, number or title), records one (optionally superseding another), edits text/status/date, and links/unlinks controls, risks and content.
    Found: decisions are shared by every company, not per company — the tools take no company (except to find a risk to link). I corrected the assistant's opening instructions to say so.
    Found: a decision can't be linked to a gap in Compass today, so "link it to the gap" isn't possible; the assistant is told to link the gap's risk instead. Decision links don't appear in Activity (existing behaviour).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 70, Content - Build MCP (ADR in COM-974). Built on COM-975. Posture batch.

## What people can ask of it

- **Read, for a named company:**
  - the decision records, filtered as on screen (status, area, date);
  - a decision in full, by its number, with what it is linked to.
- **Write (whatever the person's role allows on the Decisions screen):**
  - add a decision;
  - change its text and status as the screen allows (including superseding one);
  - link and unlink it to the things the screen offers.
- A decision can't be deleted on screen today, so the assistant can't delete one either.
- **Example:** "Record a decision for Acme: we accept the risk of running the legacy HR system until March, because the replacement is funded. Link it to that risk and the gap."

## Notes (technical)

- These wrap `decisions.py` (by number). The link targets are whatever `link_target` accepts today. The tool description lists the types, and each target is resolved by its readable reference (control ref, risk, gap, content slug).
- A status change follows the route's rules. The tool doesn't invent transitions.

**Done when:** on staging, the assistant records a decision and links it to a risk, and the decision page shows it, via assistant.