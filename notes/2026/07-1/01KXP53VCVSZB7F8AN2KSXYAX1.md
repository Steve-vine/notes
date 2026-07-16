---
id: 01KXP53VCVSZB7F8AN2KSXYAX1
created: 2026-07-16T19:05:36.411498868Z
updated: 2026-07-16T20:44:49.957893991Z
type: task
title: Issues screen redesign — header + layout shell
priority: high
assignee: steve
task_status: active
label:
- feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 96
blocked_by:
- 01KXP52AXCFASQYMHBAF953C1T
sprint: s0v93ii
---
Restructure `IssueDetailPage.tsx` (currently a single stacked `Stack` of Cards, 549 lines) into the three-zone shell ISE-88 describes, following the design task (ISE-90).

**Header (rework `IssueDetailPage.tsx:494-523`):**
- Issue ID + title + severity/source pills on the **left**; move the **status pill to the far right** of the header row.
- "Raised {time} by {created_by}" and the assignee line (`AssigneeControl`) stay as today.
- The evidence block becomes **collapsed by default** (expand to read) — wrap today's `EvidencePanel` (`:434-475`) in a Mantine collapsible.

**Shell:**
- Three zones: header (above), a scrollable **timeline** region (ISE-97), and a pinned **bottom input panel** (ISE-98).
- The four stacked panels — `DiagnosisPanel`, `RemediationSummaryPanel`, `ProposedChangesPanel`, and the always-open evidence dump — are **removed from the body**; their content moves into timeline events (ISE-97). Keep the collapsed raw-evidence block for inspectability (ui-brief "evidence is one click away").

Blocked by the design task (ISE-90). Label: feature.