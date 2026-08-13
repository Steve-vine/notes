---
id: 01KZXKYB7ENK595VDAK6DC6KM7
created: 2026-08-13T13:10:49.326415Z
updated: 2026-08-13T13:10:59.043829Z
type: task
title: The guided view's "resolve on green" button has also been dead since ISE-642
project: 01KX671DATY39VW6GWK3M2T3DN
number: 687
sprint: sevhjex
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
Same root cause as ISE-686, different surface and a different right answer.

`GuidedIncidentView.tsx:109` — the resolve button shown after a playbook run lands green — sends `body: { status: 'resolved' }` with no note. Since ISE-642 made the note mandatory in `apply_status_change` (2026-08-10, PR #588), it 422s on every click. Found while diagnosing ISE-686; not separately reported, which is worth noting — a button at the end of the guided workflow has been failing for three days without a report.

**This one should NOT prompt.** Unlike the bulk case, the account of what was done already exists: a playbook ran, it went green, and the run is the answer to "what was done". Composing the note from the run — the playbook's name and the run's verdict — is both more accurate than anything an operator would type at that moment and true to why ISE-642 exists, which is that Recall should serve the next operator something that teaches. A prompt here would collect "ran the playbook", which the timeline already knows.

**Scope**
- Compose the note from the completed run (playbook name + verdict + run id) and send it with the transition.
- Verify the note reads correctly in Recall and on the timeline — the composed sentence is what a future operator sees as this incident's resolution, so it must stand alone without the surrounding UI.
- Surface the server's `detail` on failure rather than the generic "resolve failed"; the mutation currently throws a fixed string.
- A test that asserts the composed note reaches the request body. The existing guided-view tests stub the API and never inspect it — the same gap that hid ISE-686.

**Sweep before closing.** Two of three callers of `PATCH /issues/{id}/status` were broken by one backend change and both stayed green. Enumerate every caller of that endpoint (frontend, MCP action tool, merge cascade, any playbook step) and confirm each supplies a note where the transition requires one.