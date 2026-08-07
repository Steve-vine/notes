---
id: 01KYWAFPB4ACRGA5Y7EWGRH99N
created: 2026-07-31T14:50:35.748293Z
updated: 2026-08-07T10:09:35.167053Z
type: task
title: 'Docs: Concepts — actions &amp; approvals'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 429
order: 1.0
sprint: sp3en5k
comments:
- id: 01KYWBDFHSH4TE234JGDCFNTCV
  author: Steve Vine
  at: 2026-07-31T15:06:51.8339Z
  text: |-
    Done on feature/ise-429-docs-actions-approvals — PR #24, left OPEN for review.

    Full governance model: declared catalogue with "an operation that isn't in the catalogue cannot be invoked — not by you, not by the UI, not by any prompt"; T0–T3 table with cross-integration examples and per-tier handling; default-deny section (empty policy auto-applies NOTHING, only T0/T1 ever enableable, T2/T3 auto-apply requests ignored, policy raises but never lowers with the ignored-not-errored fail-safe reasoning and "a typo can never produce an unclassified mutation"); protected targets with the approval-gates-intent-not-blast-radius framing, the ise-namespace worked example, structural enforcement inside the connector action path, connector-declared target fields, seeded namespaces; separation of duties incl. why it makes AI proposals safe (no approve function in the toolset) and the playbook publish-time variant; read/write credential split with forbidden-permission invariants; deterministic truthful execution (exact parameters, no model, LRO polled to completion, no silent non-idempotent retries). Cross-links to Proposals/Playbooks/Roles and per-integration catalogues. Facts from ADRs 0017/0021/0018/0024. Build/lint green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the stub at `src/content/docs/concepts/actions-and-approvals.md` with real content: the action catalogue and why only declared operations can run; what each tier (T0–T3) means with cross-integration examples; default-deny risk policy and per-system policy that can raise but never lower a tier; protected targets; separation of duties; the read/write credential split; reversibility and truthful completion. Cross-link to the Proposals page for the workflow and to each integration page for its catalogue.

Ground in ADRs 0017, 0021, 0018, 0024, and the connector briefs. Operator audience, released capability only.