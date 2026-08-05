---
id: 01KYAT3B04QJJRV1YQBDRFS1NX
created: 2026-07-24T19:37:08.356238Z
updated: 2026-08-05T12:02:53.776878Z
type: task
title: Map the AI interaction workflow end-to-end
project: 01KX671DATY39VW6GWK3M2T3DN
number: 263
sprint: svgrad3
comments:
- id: 01KYC7ZRAN780M55CQB11W5HJH
  author: Steve Vine
  at: 2026-07-25T08:59:05.428943Z
  text: |-
    Done. Deliverable: docs/briefs/ai-interaction-map.md — a code-grounded map of every AI interaction in ISE, written from the source rather than the design intent.

    What it covers:
    - The two execution engines (run_agent single-shot vs stream_chat streaming) and the shared machinery (AgentRun, AgentDeps, investigation_context, bound_payload, the cap table).
    - One section + one mermaid diagram per surface for all nine: summarise-state, diagnose, propose-remediation, analyse-issue, execution-followup, summarise-document, extract-document-claims, assist, issue-chat — each with its trigger, context assembled (with file:line refs), tools available, caps applied, and write path.
    - A caps table with every effective default (run 200k / 12 iters, chat 60k / 12 turns, ceiling $10, reserve 0.8, shares 0.5, thread cap $1, traversal depth 2/6, payload 40k chars, doc 60k chars) and where each lives.
    - Two cross-cutting sections that seed the next two tasks:
      * "Where the tokens go" (input to ISE-264): investigation_context bounds DEPTH not BREADTH — a depth-2 both-directions walk from a hub entity can pull hundreds of entities into one XML block carried through all 12 tool iterations; context accumulates across the loop; there is no cheap-verdict-first path for analyse-issue; per-stage attribution is coarse.
      * A tool-exposure matrix (input to ISE-265): confirms chat (assist + issue-chat) cannot pull Evidence, and analyse-issue carries the heaviest context for the cheapest question.

    Docs only, no code change. Committed to feature/ise-263-map-ai-interaction-workflow.
assignee: steve
label: null
priority: medium
task_status: done
---
The sprint's first deliverable, and the input to everything else: a complete map of how every AI interaction actually works today. For each surface — analyse-issue, diagnose, propose-remediation, execution-followup, summarise-state, assist, issue-chat, summarise-document, extract-document-claims:

- **Context assembled**: what goes into the prompt (investigation context / blast radius traversal, entity annotations, playbooks/memory recall, history replay, document summaries), from where in the code, and roughly how many tokens each part contributes.
- **Tools available**: which tools the agent may call (connector evidence, DB lookups, loop tools), and which surfaces get which — including what chat surfaces *cannot* reach.
- **Caps applied**: token/iteration/spend caps per surface and where enforced.
- **Trigger + write path**: what starts it, what it may write.

Deliverable: a document in the repo (docs/briefs/ or similar) with one diagram per surface — the workflow is complex enough that Steve has asked for it mapped, not described. This map is what the audit (token spend) and limitations-review tasks work from, and what the sprint's tuning decisions get made against.