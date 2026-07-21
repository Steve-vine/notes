---
id: 01KXRPGA8N63Y65TF9WP33ETS8
created: 2026-07-17T18:47:59.509247855Z
updated: 2026-07-21T15:30:33.082274Z
type: task
title: 'Bug: issue timeline "updated" events don''t say what changed'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 105
sprint: s0v93ii
assignee: steve
label: null
priority: medium
task_status: done
---
**Found in smoke testing.** In the issue timeline, a status change and an assignee change both render the same uninformative line — e.g. *"steve.vine@… updated · 9m ago"* — for resolve AND for assign. The `AuditEventItem` (`IssueTimeline.tsx`) renders `{actor} {statusLabel(action)}` and **ignores `event.details`**, which already carries the change (`details.status.{from,to}` for a lifecycle change; `details.assignee_id.{from,to}` for an assignment).

**Fix:**
- **Frontend:** make the audit line describe the change. For `action: "updated"`, read `details`: a status change → "marked resolved / acknowledged / dismissed"; an assignee change → "assigned to {email}" / "unassigned". Other actions keep their existing label.
- **Backend:** enrich the assignee audit (`update_issue_assignee`) to record the human-readable **emails** (`details.assignee.{from,to}`), not just the user UUIDs — a viewer can read the timeline but not the admin-gated users list, so the frontend can't resolve the id to a name on its own. Keep the ids too for back-compat; the frontend degrades old id-only events to "reassigned/unassigned".

Small polish on the redesigned Issues screen (ISE-96/97). Label: bug.