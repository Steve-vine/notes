---
id: 01KY5158M01K8TKPQC02NAAVAA
created: 2026-07-22T13:45:04.896032Z
updated: 2026-07-22T16:59:07.901546Z
type: task
title: Proposals queue — unified confirm surface + tag-mapping candidate detector
project: 01KX671DATY39VW6GWK3M2T3DN
number: 213
sprint: s5khymf
blocked_by:
- 01KY514VRBX9E4E7V7Q7ZSWAND
comments:
- id: 01KY5C8D2X2X9MBDT3Q7Q43T8P
  author: Steve Vine
  at: 2026-07-22T16:59:02.109356Z
  text: |-
    Done — PR #198 (feature/ise-213-proposals-queue), stacked on #197/ISE-212. Unblocks ISE-218 and ISE-220.

    **Model + migration 0044** as specified: kind (tag-mapping / edge / tag / alias), payload, source provenance (detector / incident / document / ai) with a free-text `source_label`, evidence text, status, decided-by/at. Plus one field the task didn't list — `occurrences` — because ISE-218 needs "a recurrence strengthens rather than duplicates" and that has to live on the row.

    **The unique constraint is on `(kind, fingerprint)`** — the identity of the *claim*, not the row. That single choice gives you both properties you asked for: the detector is idempotent (raising twice updates one row) and rejection is durable (a refused claim is still there to be recognised, so it's never raised again). `raise_proposal` returns None when the claim is already confirmed or rejected.

    **Confirm executes** as specified. A tag-mapping adds the spelling to the dictionary as an alias — never a pool rewrite — and re-resolves immediately by reusing ISE-212's `_reresolve`, so the two surfaces share one implementation of "an edit takes effect now" rather than drifting.

    **One deviation worth flagging:** you wrote "confirming an edge creates the `entity_edge` row with `ai_proposed`→confirmed provenance". I write it **`asserted`** instead. A human has just reviewed it, and ISE-216's impact panel treats `ai_proposed` edges as unconfirmed hints shown apart from fact — so leaving it `ai_proposed` would mean a confirmed relationship still displayed as "unconfirmed" forever. `asserted` is also what ADR 0041 §2 says confirmation does: it promotes the claim to tier 1.

    **Detector** — deterministic only, as scoped: case-fold, punctuation/whitespace variants, seeded synonym table. Matched across every variant of what the estate actually said, so `Pre_Prod` finds `preprod`. `pr0d` deliberately produces **nothing** — it obviously means production to a person but can't be *proved* to by a rule, and nothing unlisted maps silently (ADR 0041 §5). Runs post-sync where the pool has just changed, capped at 200 per pass with the cap logged.

    **UI** — own nav entry "Proposals", filterable by status/kind/source, defaulting to what's still waiting. The **evidence sentence is the main column**, not the payload: confirming should be reading a claim, not taking it on faith. Empty state explains what would put something in the queue. Operator-level writes — confirming a claim about the estate is the same class of act as annotating an entity, not the same as changing policy.

    Small extra: `pending` is returned unfiltered, so a future nav badge and a filtered view can't disagree about how much work is waiting.

    **Tests** — 14 backend integration covering all three you listed (confirm side-effects, rejection memory, detector idempotency) plus already-standard/ungoverned-key skips, double-decision refusal, recurrence strengthening, edges confirmed as assertions, unconfirmed never joining the graph, auditing, and the queue's default filter. 7 frontend.

    Backend 956 passed, ruff + mypy strict clean; frontend 319 passed, lint/build clean.
assignee: steve
label:
- feature
priority: high
task_status: review
---
The one place "ISE thinks it learned something — confirm?" lands (Canon: "The proposals queue"). Serves the Dictionary now; document claims and incident-learned edges plug in later in the sprint.

- **Model + migration**: proposal rows — kind (tag-mapping / edge / tag / alias), subject refs, payload, source provenance (integration/document/incident/detector), citation/evidence text, status `proposed|confirmed|rejected`, decided-by/at. **Rejection is remembered** — the same proposal never returns.
- **Confirm executes**: confirming a tag-mapping creates the dictionary mapping (audited, re-evaluates rules); confirming an edge creates the `entity_edge` row with `ai_proposed`→confirmed provenance. Unconfirmed proposals never join the graph.
- **Detector (deterministic first)**: case-fold equality, whitespace/punctuation variants, seeded synonym table over the live pool → tag-mapping candidates for values not already dictionary-listed (the `pr0d` escalation path). Runs post-sync, idempotent against remembered rejections. AI long-tail matching is a later enhancement, not this task.
- **UI (DoD)**: own nav entry ("Proposals"); list filterable by source/kind; one-click confirm/reject with the evidence rendered alongside; empty state.
- Tests: confirm-side-effects, rejection memory, detector idempotency.