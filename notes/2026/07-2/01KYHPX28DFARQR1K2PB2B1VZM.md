---
id: 01KYHPX28DFARQR1K2PB2B1VZM
created: 2026-07-27T11:55:58.093923Z
updated: 2026-08-05T13:25:43.329029Z
type: task
title: 'End-to-end acceptance: replay the IN-1092 investigation through the MCP surface'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 338
sprint: sax9eff
assignee: steve
label: null
priority: medium
task_status: done
---
The sprint's exit test — the scenario that motivated the whole direction, run for real on staging. Not a unit test; a scripted walkthrough with Steve driving Claude Code and the results checked in the ISE UI.

**Script (FailedScheduling incident, IN-1092 shape):**
1. `/ise:work-on IN-NNNN` — session pins; brief + cues arrive (similar-incident cue must appear); chip appears on the incident screen.
2. "What's actually happening on the cluster?" — live Kubernetes evidence (node capacity, pending-pod reasons), NOT a re-hash of synced state. The pass/fail heart of the test.
3. Compare with the sibling incident from the cue; merge it in; verify structural rules + timeline events.
4. Record a note + commit the diagnosis; verify both land attributed on the ticket.
5. Approve a pending proposed change (operator token); repeat with a viewer token and verify refusal + audit of the attempt.
6. Watch the incident screen in a second browser throughout — live activity, session chip lifecycle.
7. `/ise:exit` — chip clears; timeline shows the complete session record; audit trail shows every get/put.

Also verifies the negative space: substantive tools refuse before step 1, and a viewer's tool list contains no write tools at all.

Findings become fix tasks on the relevant feature branches (batch-testing phase rules). Done = Steve signs off that this beats the in-app chat experience for the IN-1092 class of investigation.