---
id: 01M006M7ECB2ZZNQQN9VZ83T3R
created: 2026-08-14T13:15:49.580542Z
updated: 2026-08-14T13:31:04.462158Z
type: task
title: 'ADR 0101: a playbook may run autonomously inside a published envelope'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 710
sprint: sevhjex
comments:
- id: 01M007G4WEX5BTGPJ34SE9XYVM
  author: Steve Vine
  at: 2026-08-14T13:31:04.462022Z
  text: |-
    CORRECTION 2026-08-14 — the draft's "blocked on escalation" framing was wrong and should not go into the ADR.

    It assumed voice/on-call (ISE-545..549) was the only escalation path. Steve: a Teams message, a FreshService ticket or an email are equally valid escalations — not every incident needs escalating in the middle of the night.

    Verified on origin/main, two routes exist and work today:
      - FreshService `create_ticket` — a T1 action already in the catalogue (ISE-442), so it passes the same publish-time validation `allowed_operations` uses.
      - Teams — NotificationChannel (ADR 0067/0069), destination_kind user | group_chat | assignee.
    Email does NOT exist — there is no SMTP path in the backend; every notification destination is Teams. Email as a route would be separate work.

    So ADR 0101 has NO external dependency. The Consequences section should say instead: escalation is a route chosen to match urgency — a ticket for something that can wait until morning, a message for something needing a person today, a call only when it genuinely cannot wait — and the voice route becomes one more option when it lands rather than a prerequisite.

    This also removes the fallback option ISE-713 previously offered ("scope the first release to playbooks whose failure path is leave-it-open-and-say-why"). That was a workaround for a block that does not exist.
assignee: steve
label:
- brief
priority: high
task_status: todo
tech: null
---
Write `docs/decisions/0101-autonomous-playbook-execution.md` (0101 is free — 0100 is the last on main). Docs only, no code. Draft below.

---

## Context

The Incident Loop's back bookend does not close. Measured on staging 2026-08-14: **143 terminal incidents, 0 with an executed fix, 5 with a diagnosis.** ISE has never applied a remediation to an incident it then resolved, so no playbook has earned efficacy and `compute_tier` can never return `rubber-stamp`. Meanwhile the operator's own account of what was done — mandatory since ISE-642 — is captured on every resolution and excluded from the learning path by construction.

The worked example is IN-1342: a Karpenter node expiring naturally, which an operator diagnosed and resolved by hand. Durable, recurring, and exactly the knowledge a playbook should carry — yet nothing about it can be automated today.

## Two paths considered

**Less prescriptive** — the AI analyses the estate and decides within guidelines and hard walls. Rejected as the primary shape, for one decisive reason: if the model judges both *applicability* and *validation*, it decides whether it was right, and that verdict feeds `efficacy_successes`, which is the number autonomy is gated on. The model would manufacture the evidence for its own licence to act. That is the same substitution seen twice this sprint — ISE-685 turned a 403 into "not installed", ISE-686 turned a 422 into "they may have changed under you".

**More prescriptive** — a fixed shape, decided at authoring time. Chosen. Three supporting reasons: the two compose in one direction only (a prescriptive step can call for judgement at a named point; a guideline-driven agent cannot be made deterministic afterwards); there is no evidence novelty is the bottleneck, and prescriptive runs are what generate the efficacy data that would prove otherwise; and a human approving an autonomous playbook can read exactly what will happen.

## Decision

**Autonomy is a third rung on the existing envelope, not a new mechanism.** `playbook_envelope.py` (ADR 0056 §1) already is the fixed shape: an operation allowlist capped at T1/T2, incident-derived target scope, run bounds, deterministic validation predicates evaluated by the runner rather than the model, prose escalation, and auto-demotion at 4 outcomes below a 0.5 ratio. Its own docstring states the governing principle — *"the interpreting model never certifies its own success."*

The fixed shape is: **precondition → act → wait → validate → close | escalate.** No loops, no arbitrary branching. Judgement is permitted only at named points, inside walls that already exist (the evidence catalogue for reads, the connector action catalogue and risk tiers for writes).

**Autonomy is earned, never declared.** Three gates, all required: the playbook is flagged eligible; it is proven by efficacy history; and its envelope's tier ceiling is within the autonomous bound. A new playbook can never run autonomously however it is flagged.

**What this supersedes.** ADR 0017 is default-deny — nothing auto-applies. This supersedes that for playbooks meeting all three gates. The governance change to state plainly: today a human approves a *specific proposed change*; publishing an autonomous playbook approves a *class of future changes*. That is defensible only because the class is enumerable at publish time, which is precisely what the prescriptive path buys and the guidelines path would not.

The precedent is Breakglass (ADR 0089) — time-boxed auto-approval, armed in the app. This differs: standing autonomy attached to a playbook rather than a window attached to a human's decision. Retraction therefore matters more, and the existing auto-demotion is the mechanism.

## Consequences

- Editing an autonomous playbook retracts autonomy, exactly as editing a desk-executable one retracts desk status.
- The safest first class of autonomous playbook changes nothing in the estate — it concludes and resolves. That requires the envelope to permit an empty operation list (ISE-711).
- Efficacy will conflate "fixed it" with "correctly dismissed it". Both are successes; they are not the same claim, and the ADR should say whether they are counted separately.
- The strong model belongs on judging ambiguous validation and deciding escalation, not on executing steps — a narrower allocation than "a better model for autonomous runs".
- Nothing is autonomous until manual playbook runs are routine enough to earn efficacy. Sequencing is a consequence of the design, not a project-management choice.

Implementation: ISE-711 (precondition + no-op outcome), ISE-712 (negation, `node_present`, wait anchor), ISE-713 (escalation route), ISE-714 (the autonomy rung).