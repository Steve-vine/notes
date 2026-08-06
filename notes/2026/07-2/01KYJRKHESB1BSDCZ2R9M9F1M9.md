---
id: 01KYJRKHESB1BSDCZ2R9M9F1M9
created: 2026-07-27T21:44:57.561434Z
updated: 2026-08-06T08:34:37.159093Z
type: task
title: Guided incident page for responders — the Service Desk experience
project: 01KX671DATY39VW6GWK3M2T3DN
number: 347
order: 1.5
sprint: sf23rna
comments:
- id: 01KYJTZE3W0C3GZS7YVCEA7N2R
  author: Steve Vine
  at: 2026-07-27T22:26:24.508236Z
  text: 'Built (PR #321, stacked on #320). IssueDetailPage branches on role: a responder without operator gets GuidedIncidentView — compact brief, then "Pre-approved responses": the matched desk-executable playbooks from the new GET /issues/{id}/desk-playbooks, each showing the envelope''s plain-terms summary ("may run restart_rollout on the incident''s affected entity; checks pending_pods.total_pending == 0"), its worked-N/M track record, and Run. The run lifecycle rides the existing polls: 202 → "Running the playbook…" → the playbook_run pointer lands (baseline-compared so a previous run''s verdict never reads as this one''s) → green shows one-click Resolve (normal cascade), red shows the escalation alert with the run summary and "nothing more will run automatically". No-match shows the honest empty state pointing at escalation. Operators keep today''s page pixel-for-pixel. One deliberate simplification vs the task body: no step-by-step streaming panel — the verdict panel + the timeline''s existing live feed carry the progress story (same deviation noted on ISE-346; revisit after the walkthrough if the desk wants more play-by-play). Endpoint test green; the full run view gets its real exercise in the ISE-349 staging walkthrough since it needs a live model + cluster.'
assignee: steve
label: null
priority: high
task_status: done
---
The sprint's flagship screen (pane-of-glass DoD): the incident page's new job for the responder role — guided response, with the power tools gone.

- **Layout for a responder**: incident brief up top (status, severity, affected entity, alert state — reusing the existing panels); then **matched desk-executable playbooks** ranked by efficacy, each showing name, what it will do in plain terms (derived from the envelope: "may run these operations on this target"), track record, and a **Run** button. No diagnose/propose/merge/chat chrome.
- **The run view**: live streamed interpretation (SSE), evidence checks going green/red, executed changes appearing, the validation verdict, then either "Resolve incident" (one click, cascades as normal) or the escalation summary with "flag for an engineer" (assigns/notes per ADR 0038 spirit).
- **No playbook matches** → an honest empty state: "no pre-approved response for this incident — escalate", with the escalation action. The desk never dead-ends.
- Engineers/operators keep today's page untouched; the guided surface renders for the responder role only (ISE-344).
- Wallboard/queue counts unaffected; the timeline shows the run like any other activity so an engineer reviewing later sees the whole story.

DoD: a responder works a staging incident end-to-end — open, run, watch, resolve — without ever seeing a tool they cannot use; the no-match and escalation paths both read clearly.