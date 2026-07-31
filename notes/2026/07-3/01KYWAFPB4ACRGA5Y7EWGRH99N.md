---
id: 01KYWAFPB4ACRGA5Y7EWGRH99N
created: 2026-07-31T14:50:35.748293Z
updated: 2026-07-31T15:05:39.951213Z
type: task
title: 'Docs: Concepts — actions &amp; approvals'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 429
order: 1.0
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Replace the stub at `src/content/docs/concepts/actions-and-approvals.md` with real content: the action catalogue and why only declared operations can run; what each tier (T0–T3) means with cross-integration examples; default-deny risk policy and per-system policy that can raise but never lower a tier; protected targets; separation of duties; the read/write credential split; reversibility and truthful completion. Cross-link to the Proposals page for the workflow and to each integration page for its catalogue.

Ground in ADRs 0017, 0021, 0018, 0024, and the connector briefs. Operator audience, released capability only.