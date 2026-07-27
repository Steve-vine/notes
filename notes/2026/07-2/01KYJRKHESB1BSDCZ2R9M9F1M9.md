---
id: 01KYJRKHESB1BSDCZ2R9M9F1M9
created: 2026-07-27T21:44:57.561434Z
updated: 2026-07-27T21:45:11.826453Z
type: task
title: Guided incident page for responders — the Service Desk experience
project: 01KX671DATY39VW6GWK3M2T3DN
number: 347
assignee: steve
label:
- feature
priority: high
task_status: backlog
---
The sprint's flagship screen (pane-of-glass DoD): the incident page's new job for the responder role — guided response, with the power tools gone.

- **Layout for a responder**: incident brief up top (status, severity, affected entity, alert state — reusing the existing panels); then **matched desk-executable playbooks** ranked by efficacy, each showing name, what it will do in plain terms (derived from the envelope: "may run these operations on this target"), track record, and a **Run** button. No diagnose/propose/merge/chat chrome.
- **The run view**: live streamed interpretation (SSE), evidence checks going green/red, executed changes appearing, the validation verdict, then either "Resolve incident" (one click, cascades as normal) or the escalation summary with "flag for an engineer" (assigns/notes per ADR 0038 spirit).
- **No playbook matches** → an honest empty state: "no pre-approved response for this incident — escalate", with the escalation action. The desk never dead-ends.
- Engineers/operators keep today's page untouched; the guided surface renders for the responder role only (ISE-344).
- Wallboard/queue counts unaffected; the timeline shows the run like any other activity so an engineer reviewing later sees the whole story.

DoD: a responder works a staging incident end-to-end — open, run, watch, resolve — without ever seeing a tool they cannot use; the no-match and escalation paths both read clearly.