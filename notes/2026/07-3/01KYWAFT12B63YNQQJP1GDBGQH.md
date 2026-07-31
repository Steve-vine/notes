---
id: 01KYWAFT12B63YNQQJP1GDBGQH
created: 2026-07-31T14:50:39.522353Z
updated: 2026-07-31T14:55:59.58922Z
type: task
title: 'Docs: Concepts — playbooks'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 430
order: 0.0
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Replace the stub at `src/content/docs/concepts/playbooks.md` with real content: what a playbook is (freeform natural-language body inside a server-enforced envelope); the envelope's hard limits (allowed catalogue operations T1/T2 only, incident-derived target binding, run bounds, deterministic validation predicates, escalation path); authoring and the second-engineer publish gate (approval spent once, at publish — the standard-change model); who can execute (the responder role) from the guided incident page; efficacy tracking and decay; the run transcript as the audit artefact.

Ground in ADRs 0056 and 0029, plus `../ise/docs/briefs/playbooks-v2.md`. Operator audience, released capability only.