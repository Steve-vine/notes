---
id: 01KZYEQHZDS5TM5SEJ7GFH9KDH
created: 2026-08-13T20:58:58.413897Z
updated: 2026-08-14T07:59:46.210529Z
type: task
title: Stated impact should be in scope when the AI works the ticket
project: 01KX671DATY39VW6GWK3M2T3DN
number: 697
sprint: sevhjex
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
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