---
id: 01KZDRNE6QVEXPCYQYJPPBX9XD
created: 2026-08-07T09:25:29.431993Z
updated: 2026-08-07T20:14:41.447491Z
type: task
title: Assist system prompt refresh — mission, freshness hierarchy, current tool surface
project: 01KX671DATY39VW6GWK3M2T3DN
number: 602
sprint: snk16ew
comments:
- id: 01KZEGMEBZYB5RSVH5VJMQKK07
  author: Steve Vine
  at: 2026-08-07T16:24:22.655101Z
  text: |-
    Done — PR #524 (feature/ise-602-assist-system-prompt).

    The prompt still described the Sprint 5 surface (systems, state, issues, proposals, history) and had never caught up with what Assist can now reach: estate predicate queries and counts, the identity directory, impact analysis, the document register, comprehended repos, ranked signal/event/history retrieval. The insight worth keeping: A TOOL THE PROMPT NEVER MENTIONS IS A TOOL THE MODEL REACHES FOR LATE OR NOT AT ALL — and that failure looks like an absence of FACTS rather than an absence of LOOKING. That is the same shape as ISE-540.

    Rewritten around the mission — read-only, surfaces information, never acts, never offers to act:
    - FRESHNESS HIERARCHY made explicit. Synced state by default (cheap, broad, joinable ACROSS integrations in a way no live pull is); live Evidence when the question says "right now", when the fact is one ISE never syncs (logs, metric series, sign-in history), or when last_synced_at says the state is too old. Attribution is mandatory: an answer resting on stale state that does not SAY so is a wrong answer even when the facts are right.
    - TOOL SURFACE taught: identity entity types (user, app-registration, identity-group, secret, policy, network) so "which accounts..." reads as an estate question; the tag-search rule; count_only + the truncated-page trap; estate_impact for "what if X failed"; documents/repos for what the writing says.
    - CROSS-INTEGRATION SYNTHESIS named as the job with worked examples (which repo builds the running image; does the runbook still match reality).
    - Kept: reason only from tools, cite before writing, untrusted external content (now enumerated across EVERY source that leaves ISE, not just evidence), check list_proposed_changes, route wanted changes through the proposal flow.

    tests/test_assist_prompt.py pins the load-bearing instructions — presence, not wording, so the prompt stays rewritable. Each guards a specific wrong answer: lost freshness attribution, ISE-540's "no reference exists anywhere", ISE-593's page-as-count, a monitor name read as an instruction, a softened read-only stance. Plus: every tool the prompt NAMES must exist in the assist tier, so a rename cannot leave the model hunting for something that is not there.

    Verification of the ANSWERS is the ISE-595 question bank against staging — that is the remaining step, not something this PR can prove.

    ruff + mypy strict + suite green locally.
assignee: steve
label: null
priority: medium
task_status: done
---
Rewrite the Assist agent's system prompt (ai/assist.py) around the agreed mission: a read-only surface for estate questions — surfaces information, never acts, never offers to act.

- Freshness hierarchy: answer from synced state by default (watch `last_synced_at`), reach for live Evidence when the question says "right now" or the sync is stale — and always say which source the answer came from.
- Teach the current tool surface: identity entity types (user, app-registration, identity-group), the tag-search rule, estate query v2's predicates/counts, impact analysis for "what if X failed", documents/repos for "what does the doc say".
- Cross-integration synthesis is the job: encourage combining graph + state + evidence + documents for open questions, citing each source (`cite` before writing stays).
- Keep: reason only from tools, check list_proposed_changes before recommending anything is pending.

Verified by the question bank (ISE-595) on staging.