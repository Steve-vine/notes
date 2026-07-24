---
id: 01KY3402DHFQTAFAN141NVVX4Y
created: 2026-07-21T19:56:11.569099Z
updated: 2026-07-24T12:07:57.504099Z
type: task
title: Tooltips on the incident action buttons
project: 01KX671DATY39VW6GWK3M2T3DN
number: 203
sprint: sohzsw2
blocked_by:
- 01KY33QW3Z18PPDM2HZH5N5JX7
assignee: steve
priority: medium
task_status: done
---
Add Mantine `Tooltip`s to the action-button row at the foot of the incident detail page (`IssueDetailPage.tsx` ~line 1106) — after ISE-202 removes Acknowledge, that's the remaining 7 on an open incident. The lifecycle set varies by status, so cover the whole label map (Close included).

Suggested copy (one line each, saying what the button *actually does*):
- **Analyse** — Run an AI analysis of this incident and update its summary
- **Diagnose** — Run an AI root-cause diagnosis (lands on the timeline)
- **Propose remediation** — Ask the AI to propose a fix for approval
- **Resolve** — Mark fixed; also resolves the underlying signal and cascades to merged children
- **Dismiss** — Close as not worth fixing; sticky — a recurring signal won't reopen it
- **Close** — Archive a resolved or dismissed incident
- **Downgrade severity** — Override this signal kind's severity so future occurrences stop opening incidents
- **Ignore signal** — Hard-mute this signal: still recorded, but never opens or reactivates an incident

Frontend-only; no API change. Sequence after ISE-202 so we don't write a tooltip for a button being deleted.