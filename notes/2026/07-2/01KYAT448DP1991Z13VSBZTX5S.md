---
id: 01KYAT448DP1991Z13VSBZTX5S
created: 2026-07-24T19:37:34.221307Z
updated: 2026-08-07T10:06:39.365567Z
type: task
title: Audit context assembly and token spend — why does analyse-issue need 200k+?
project: 01KX671DATY39VW6GWK3M2T3DN
number: 264
sprint: svgrad3
comments:
- id: 01KYC84ZPNZGWAQFMCA7KH0VN5
  author: Steve Vine
  at: 2026-07-25T09:01:56.821712Z
  text: |-
    Done. Deliverable: docs/briefs/ai-token-spend-audit.md — traces where analyse-issue's 200k+ tokens actually go, grounded in the code.

    Key framing: the 200k cap is a token-COUNT runaway guard, NOT the cost control (the $10/day ceiling is). Prompt caching (ISE-107) cuts the dollars but not the counted total — so raising the cap "fixes" cost and still leaves a giant run. The fix is to reduce tokens assembled/re-carried, not raise the wall.

    Four confirmed suspects:
    - A (primary): investigation_context bounds DEPTH (2) not BREADTH — related_entities has no count cap (estate.py:201). A hub entity (a K8s node with 131 workloads part-of it, a shared DB, a cluster) at depth-2 both-directions pulls hundreds of entities into a ~10-40k-token XML block appended to every prompt.
    - B (multiplier): that block is re-carried across up to 12 tool hops; pydantic-ai retains prior tool results. Sub-finding: the estate context is included TWICE — the prompt block AND the get_affected_entity_context tool.
    - C (the specific waste): no cheap-verdict-first path. "Has the signal recovered?" is deterministically knowable (Finding.resolved_at / signal no longer firing) before any model call, but analyse-issue assembles the full context regardless — the common self-resolved case is the most expensive, inverting the Canon self-tiering principle.
    - D (instrumentation gap): AgentRun records a token TOTAL, not a decomposition — this audit reasons structurally because per-stage instrumentation doesn't exist yet.

    Token model: ~99% of a hub-rooted analyse-issue run is assembling/re-carrying context to answer a question a deterministic check often settles for free.

    Recommendations (as follow-up implementation tasks — this is the audit, no code here): (1) bound traversal breadth + summarise hub fan-out, (2) cheap-verdict-first for analyse-issue, (3) de-duplicate the estate context, (4) per-stage token instrumentation on the run-detail screen, (5) per-task-type caps sized from the measured numbers AFTER 1-2 shrink the footprint. Explicitly does NOT recommend raising 200k. Proposed the five follow-up tasks in the doc.

    Docs only, no code change. Committed to feature/ise-264-audit-context-token-spend.
assignee: steve
priority: medium
task_status: done
---
Motivating case (2026-07-24): two analyse-issue runs burned 216,560 and 209,208 tokens — killed by the 200k run cap — to conclude an issue had **resolved itself**. That is the cheapest possible verdict at the most expensive possible price, and it coincided with the estate doubling (second cluster + Rollouts: 131 workloads / 171 services).

Working from the ISE-263 map, find where the tokens actually go and bound it:

- Instrument per-stage token contribution (investigation context size, tool-result sizes, iteration count) so a run's spend is decomposable — not just a total. Consider persisting this on the run for the run-detail screen.
- Check the obvious suspects: does investigation_context/traverse scale with estate size (blast radius over 300+ entities)? Are tool results (evidence slices) uncapped or oversized? Does the agent loop re-fetch what it already has?
- Cheap-verdict-first: "signal recovered, nothing firing" should be determinable deterministically or in one small model call before assembling a full investigation context — self-resolution is the *common* case and should be the cheapest, per the Canon's self-tiering principle.
- Output: fixes where clear (context bounding, result caps), and right-sized per-task caps grounded in real numbers rather than raising `ai_run_max_tokens` until the errors stop.

Depends on ISE-263 (the map).