---
id: 01KYWAF6EQYGSYRYV3VH8C68EA
created: 2026-07-31T14:50:19.479998Z
updated: 2026-07-31T14:51:40.065571Z
type: task
title: 'Docs: Concepts — the core loop'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 426
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Replace the stub at `src/content/docs/concepts/core-loop.md` with real content: walk Monitor → Analyse → Evaluate → Configure end to end with one worked example (alert → incident → diagnosis with evidence → proposed change → approval → execution → verification), showing where the operator is in control at each step and how the loop repeats. Cross-link to the signals, actions, and playbooks concept pages rather than duplicating them.

Ground in ADRs 0025, 0024 (remediation loop), 0030 (Obs Loop), and the product vision brief. Operator audience, released capability only.