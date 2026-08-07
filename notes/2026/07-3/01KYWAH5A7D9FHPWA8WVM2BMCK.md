---
id: 01KYWAH5A7D9FHPWA8WVM2BMCK
created: 2026-07-31T14:51:23.847607Z
updated: 2026-08-07T10:37:53.961866Z
type: task
title: 'Docs: new section — Proposals'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 437
order: 0.000244140625
sprint: sp3en5k
blocked_by:
- 01KYWAGFZMYHV2Y0WHXM8W7N8G
comments:
- id: 01KYWBZHY55ZM21YNKBF6EWCNZ
  author: Steve Vine
  at: 2026-07-31T15:16:44.10107Z
  text: |-
    Done on feature/ise-437-docs-proposals — PR #32 (stacked on ISE-436), left OPEN for review.

    The workflow as an operator meets it, opening with "nothing changes in your infrastructure without a proposed change first" and explicitly deferring the tier model to the concepts page. Covers: the three doorways (AI diagnosis, system actions panel or typed prompt, playbook run auto-approved with provenance) all reaching the SAME governed entry point with tier/protected-targets/SoD applying regardless; what a proposal shows before you approve (target, exact parameters "no summarised intent, the real values", tier badge, rationale + evidence links, expected effect + rollback note, proposer linked to the agent run) plus AI-proposed marking and self-approval blocking; approving from either the Approvals queue or inline in the incident timeline — same governance either way — with rejection comments as "the useful half of the record six months later" and the admin self-approval distinctly-audited note; execution (exact frozen parameters, no model in the loop because approval froze them, LRO polled so succeeded means it actually did, failures recorded not silently retried unless provably idempotent, nothing auto-rolls-back because undoing is itself a new change); and the afterwards — timeline post, audit trail, AI follow-up suggestion, signal recovery. 25 pages build. Facts from ADRs 0017/0021/0024/0060/0056.

    That completes phase 3: ISE-423..437 all in Review, PRs #18–#32.
assignee: steve
label: null
priority: medium
task_status: done
---
Write `src/content/docs/using-ise/proposals.md`: the proposed-change workflow as an operator actually meets it — where proposals come from (AI diagnosis during an incident, the connector-generic propose-action panel on a System, a playbook run), what a proposal shows (target, operation, parameters, tier, reversibility, expected effect), the approve/reject path and who may approve, what happens on execution (including long-running operations reported truthfully on completion), failure handling, and where the result lands on the incident timeline and audit trail.

Cross-link to Concepts → Actions &amp; approvals for the tier model rather than restating it. Ground in ADRs 0017, 0021, 0024, 0060 §UI (ActionsPanel), 0056. Operator audience, released capability only.

Depends on ISE-433 (sidebar group).