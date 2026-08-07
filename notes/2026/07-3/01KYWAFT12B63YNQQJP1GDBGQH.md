---
id: 01KYWAFT12B63YNQQJP1GDBGQH
created: 2026-07-31T14:50:39.522353Z
updated: 2026-08-07T10:56:11.272634Z
type: task
title: 'Docs: Concepts — playbooks'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 430
order: 0.0
sprint: sp3en5k
comments:
- id: 01KYWBFVVXE5C21TDT220WDQ8T
  author: Steve Vine
  at: 2026-07-31T15:08:09.981876Z
  text: |-
    Done on feature/ise-430-docs-playbooks — PR #25, left OPEN for review.

    Full V2 model: body vs envelope with "only one of them is the safety boundary", and the deliberate why-prose-not-a-step-grammar note (brittle when reality deviates, costly to author, DSL creep); envelope table (allowed ops T1/T2 only + never T3 desk-executable, incident-derived target scope never from prose, run bounds, deterministic validation predicates, escalation = stop and summarise) followed by the key line — worst case = allowed ops × bound targets within bounds, enumerable AT PUBLISH TIME regardless of the prose, which is what makes pre-approval reviewable; publishing with the second-engineer-not-sole-author gate, SoD moved from execution to publish, pre_approved_via provenance, execution-time guard re-check so retraction/demotion stops approvals instantly, protected targets unchanged, out-of-envelope falls back to per-change approval; validation decided by the runner not the interpreter, with human confirm where judgement is genuine; semi-supervised streamed execution, transcript as audit artefact, halts-and-escalates, never rolls back (rollback is a new change), replayable narrative not replayable execution; the responder rung and its bounded surface; efficacy decay auto-demoting (track records not vibes); one format two readers. Facts from ADR 0056. Build/lint green.
assignee: steve
priority: medium
task_status: done
---
Replace the stub at `src/content/docs/concepts/playbooks.md` with real content: what a playbook is (freeform natural-language body inside a server-enforced envelope); the envelope's hard limits (allowed catalogue operations T1/T2 only, incident-derived target binding, run bounds, deterministic validation predicates, escalation path); authoring and the second-engineer publish gate (approval spent once, at publish — the standard-change model); who can execute (the responder role) from the guided incident page; efficacy tracking and decay; the run transcript as the audit artefact.

Ground in ADRs 0056 and 0029, plus `../ise/docs/briefs/playbooks-v2.md`. Operator audience, released capability only.