---
id: 01KZYEQHZDS5TM5SEJ7GFH9KDH
created: 2026-08-13T20:58:58.413897Z
updated: 2026-08-14T11:03:50.345822Z
type: task
title: Stated impact should be in scope when the AI works the ticket
project: 01KX671DATY39VW6GWK3M2T3DN
number: 697
sprint: sevhjex
comments:
- id: 01KZZZ2HT9TTQZJETCFSJWFRYP
  author: Steve Vine
  at: 2026-08-14T11:03:50.345713Z
  text: |-
    BUILT + MERGED 2026-08-14 — PR #654 (squashed to main as 6de8dc7), CI green.

    `stated_impact_block` now rides on every surface that REASONS about an incident: diagnose, propose-remediation and analyse-issue (beside `_estate_header`, deliberately NOT inside it — the derived graph and a person's claim are different kinds of fact and the prompt has to keep them apart), the issue conversation's per-turn context, and the MCP incident brief Claude Code opens a session with. Recomputed per turn, so stating impact mid-conversation reaches the very next answer — which is the point, since it is typed during an outage into that box.

    THE THREE DECISIONS, taken and written into the code rather than left in this ticket:

    1. READS, NEVER ACTS. `match_playbooks` is untouched and stays keyed to the incident's own entity. Letting a hand-added entity broaden entity-scoped matching means an operator's outage-time claim could make a REMEDIATION playbook match — a governance change, not a presentation one, and precisely what ADR 0017's tiering exists to prevent. There is a test that pins it: it seeds a playbook scoped to the stated entity and asserts it does NOT match. If that ever needs to go the other way it wants an ADR, not a quietly flipped assertion. The impact rollups / headline badges stay derived-only for the same reason — a Business Application appearing in the headline because someone typed a name during an outage is the same category error.

    2. INCIDENT-SCOPED, unchanged. Nothing writes an edge; a recurrence starts blank. The durable-dependency answer is the entity page's Relationships card, where a claim is proposed, reviewed and confirmed.

    3. THE PROMPT SAYS WHOSE CLAIM IT IS. Each line names its author, and the block states plainly: "a person's claim about THIS event, not estate topology — the graph does not connect them, nobody has confirmed them as dependencies, and they are scoped to this incident alone. Treat them as evidence about what is hurting right now… never as a durable relationship you can reason from for anything else." Without that sentence a model has no way to weigh an outage-time guess differently from the graph and will restate it as fact — the ADR 0041 §3 reasoning about unconfirmed edges, one layer up.

    Empty when nobody has stated anything, so the ordinary incident's prompt is byte-for-byte unchanged and the cost is one indexed read.
assignee: steve
label:
- improvement
priority: medium
task_status: active
tech: null
---
Split out of ISE-691 decision 4, which flagged this rather than assuming it.

ISE-691 shipped `issue_affected_entity` (migration 0134): an operator can state that an incident affects an entity the estate graph does not connect. Today that statement is **display-only** — it renders in the Impact panel and nothing else reads it.

**What should consider it, and does not:**
- The AI's affected-entity context. `stream_issue_chat` / diagnose / propose reason from the incident's single `entity_id`; a stated entity is invisible to them, so an operator who told ISE "the reporting job is affected too" gets a diagnosis that has never heard of it.
- Entity-scoped playbook matching (`match_playbooks`), which keys off the incident's own entity.
- Impact rollups — whether a stated entity's Business Application should appear in the incident's headline badges.

**Decide before building, because they are not the same call:**
1. **Does stated impact change what ISE ACTS on, or only what it reads?** Reading is safe. Letting a hand-added entity broaden playbook matching means an operator's outage-time claim can make a remediation playbook match — which is a governance question, not a UI one.
2. **Does it survive the incident?** It is deliberately incident-scoped, so a recurrence starts blank. That is right for a transient claim and wrong for a real dependency nobody has recorded — and the answer to the second is the entity page's Relationships card, not this.
3. **Weight against derived facts.** A derived dependent is a fact about the graph; a stated one is a person's claim during an outage. If both feed the AI, the prompt should say which is which, or the model will treat an outage-time guess as topology.

Not urgent — nothing is broken, and the panel is honest about what it holds. This is about making the statement useful rather than decorative.