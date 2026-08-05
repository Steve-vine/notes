---
id: 01KYWAF6EQYGSYRYV3VH8C68EA
created: 2026-07-31T14:50:19.479998Z
updated: 2026-08-05T12:34:41.964451Z
type: task
title: 'Docs: Concepts — the core loop'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 426
order: 0.25
sprint: sp3en5k
comments:
- id: 01KYWB500PZ6NFN3RF34AWW19M
  author: Steve Vine
  at: 2026-07-31T15:02:13.782401Z
  text: |-
    Done on feature/ise-426-docs-core-loop — PR #21, left OPEN for review.

    Core loop walked end to end. Monitor (deferral principle — sources with their own detection layer are forwarded, Kubernetes gets ISE's own detectors; discovery keeps the estate current). Analyse (AI reads/reasons/writes records, never touches infra; evidence on demand not polled; full run traces). Evaluate (transient signals → durable human-owned incidents; incident-as-conversation timeline, ADR 0024). Configure as a numbered propose→approve→execute→verify with the structural boundaries stated: all three proposal doorways reach the same governed entry point, a proposal is a record not a change, higher tiers block self-approval and the AI has no approve capability at all, execution is deterministic connector code with no model in the loop, LROs truthfully polled. Worked crash-loop example touching every stage incl. the deploy event on the timeline. Closing section on what shortens the loop (playbooks' spend-approval-once model, a better estate). Cross-links to signals/actions/proposals/estate rather than duplicating. Build/lint green.
assignee: steve
priority: medium
task_status: done
---
Replace the stub at `src/content/docs/concepts/core-loop.md` with real content: walk Monitor → Analyse → Evaluate → Configure end to end with one worked example (alert → incident → diagnosis with evidence → proposed change → approval → execution → verification), showing where the operator is in control at each step and how the loop repeats. Cross-link to the signals, actions, and playbooks concept pages rather than duplicating them.

Ground in ADRs 0025, 0024 (remediation loop), 0030 (Obs Loop), and the product vision brief. Operator audience, released capability only.