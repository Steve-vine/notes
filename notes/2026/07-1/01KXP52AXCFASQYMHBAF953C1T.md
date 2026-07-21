---
id: 01KXP52AXCFASQYMHBAF953C1T
created: 2026-07-16T19:04:46.764773636Z
updated: 2026-07-21T16:49:42.695719Z
type: task
title: 'Design: issue timeline layout + bubble colour taxonomy'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 90
sprint: s0v93ii
blocked_by:
- 01KXP51V7CR9VDWE6Z4T9WEV1F
assignee: steve
label: null
priority: high
task_status: done
---
The UI brief (`docs/briefs/ui-brief.md`, screen 3) describes Issues as a stacked-panel detail page; it does **not** describe a timeline/chat surface. Update the brief + `docs/briefs/design-system.md` before the frontend work starts, so the colour and layout decisions are made once, in the single-source-of-truth place, not ad hoc in components.

**Layout (per ISE-88):**
- Top section: Issue ID + title + severity/source pills on the **left**; status pill moved to the **far right**; "Raised {time} by {actor}" and the assignee line as today; the **evidence block collapsed by default**, expand to read (today it's an always-open `EvidencePanel`, `IssueDetailPage.tsx:434-475`).
- Main section: a vertical **timeline/chat** of typed events, each a colour-coded bubble with a timestamp header.
- Bottom: the input panel (chat + pre-baked action buttons).

**Bubble colour taxonomy — the real decision.** ISE-88 proposes user=blue, AI=green, action/alert/question=orange, other=purple. These **collide** with the existing semantic map in `design-system.md:116-138` / `statusColors.ts`, where blue already = info/acknowledged, green/teal = resolved/success, orange = high-severity/awaiting-approval. Define a `bubble-role → token` mapping in `statusColors.ts` (single source; no hex/pixel in components, per the design-system enforcement rules) that reads clearly **without** fighting the status pills that also appear inside the bubbles. Flag any residual conflict for Steve rather than quietly overloading a colour.

**Also specify:**
- Tier badges (T0–T3) rendered on every action/proposal bubble, consistent with the rest of the app (design-system.md:181).
- The approval-bubble spec: orange "awaiting approval" notification for non-approvers; inline Approve/Reject for approvers; resolves to "approved by {name} at {time}" once decided.

Docs only — no code. Feeds the frontend tasks. Label: brief.