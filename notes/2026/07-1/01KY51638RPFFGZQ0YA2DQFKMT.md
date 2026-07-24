---
id: 01KY51638RPFFGZQ0YA2DQFKMT
created: 2026-07-22T13:45:32.184811Z
updated: 2026-07-24T13:29:19.242402Z
type: task
title: Incident "Affects" panel + what-if impact preview
project: 01KX671DATY39VW6GWK3M2T3DN
number: 216
sprint: s5khymf
blocked_by:
- 01KY515PBJZDA2XB0J4E9JSK9Z
- 01KY514VRBX9E4E7V7Q7ZSWAND
comments:
- id: 01KY59AFXPSVBWZPEAY54N85AM
  author: Steve Vine
  at: 2026-07-22T16:07:44.822091Z
  text: |-
    Done — PR #196 (feature/ise-216-impact-panel), top of the batch-1 chain (#193 ← #194 ← #195 ← this).

    **`GET /entities/{id}/impact`** as specified — reverse traversal reusing `traverse()`, returning dependents with per-hop edge type and provenance, group memberships, canonical env/service tags, and unconfirmed proposals flagged separately. One endpoint serves both readings, which is why the incident panel and the entity preview are one component.

    **Two deliberate narrowings of the edge set you listed.** The task said incoming `depends-on`/`routes-to`/`part-of`; I dropped `part-of` from the walk and handle groups separately:

    - `part-of` upstream finds an entity's *members*, not its groups — membership points the other way (`X part-of group`). My first version had exactly this bug and a test caught it.
    - More importantly, containment isn't consequence. A group is a lens over the estate, not a casualty of it, so it belongs in the headline as context ("this is Kora") rather than in the dependent list. `runs-on` is excluded too — a node failing takes its workloads, but a workload failing doesn't take the node, and the reverse walk would claim it did.

    Depth capped at 2. Three hops is a claim built from a mostly-discovered graph that reads as alarming rather than useful.

    **Unconfirmed separation** as specified, and slightly further: `ai_proposed` dependents are excluded from the summary count as well as from the list, so the headline number is only what ISE actually knows. That's the seam ISE-218 and ISE-220 will feed.

    **Headline tags resolve through the Tag Dictionary**, so an estate spelling it `env:Prod` still answers "production" — which only works because ISE-211 landed first.

    **Surfaces.** Incident: "Affects" panel in the *header*, where triage happens, rather than in the feed — and only for a promoted incident, since a manual one names no estate entity. Entity: same component as "Impact preview". Chat: `estate_impact` assist tool whose docstring tells the model to report the deterministic result rather than reason to a different list, and to flag unconfirmed items as hints. The frozen assist allow-list test caught the addition exactly as it's designed to, and I updated it deliberately.

    **Two supporting changes.** `EntityDetail.groups` is now a field (it was graph-only — the one fact an operator most wants was the hardest to get to), and `IssueRead.entity_id` is derived at read time like `alert_status`, so the incident screen can ask "what does this affect" without fetching the signal first.

    **Thin-graph honesty** — "No known dependents. The estate graph may simply be incomplete", linking to where to add what you know. "Nothing depends on this" and "ISE doesn't know what depends on this" look identical from the panel, and conflating them lets someone read safety into ignorance.

    **Tests** — 10 backend integration (the RDS scenario end to end producing "Kora — env:prod — 2 dependent entities"; runs-on not propagating either way; depth cut-off; cycle termination; unconfirmed separation; direct-vs-deeper provenance; thin graph; group membership as a field) and 4 frontend for the panel's states.

    Backend 933 passed, ruff + mypy strict clean; frontend 307 passed, lint/build clean.

    One implementation note: the panel renders nothing rather than half of itself if the payload isn't a full impact — it's context, and a context panel that can't say anything true shouldn't take up screen.
assignee: steve
priority: high
task_status: done
---
The flagship slice (Canon: "Impact & what-if") — the RDS scenario answered on the screen where it's asked: "Affects: Kora (production) — 3 dependent services".

- **Backend**: `GET /api/v1/entities/{id}/impact` — deterministic reverse traversal (incoming `depends-on`/`routes-to`/`part-of`, reuse `traverse()` in `estate.py`) returning: dependents with per-hop edge type and provenance; the entity's group memberships; its canonical `env:`/`service:` tags; and **unconfirmed edge proposals flagged distinctly** (never mixed in as fact).
- **Incident detail (DoD)**: an "Affects" panel for the incident's affected entity — headline line (groups + env), dependent list with provenance badges, link into the graph. Renders honestly when the graph is thin ("no known dependents — the graph may be incomplete", linking to edge assertion).
- **Entity page**: the same data as an "Impact preview" — this is the "what would happen if X failed?" answer from any entity, no incident needed.
- **Chat**: an assist/investigation tool exposing the impact query so "what would happen if X failed?" is answerable in conversation, AI narrating over the deterministic result (annotations, document summaries, criticality).
- Group membership becomes a first-class field on `EntityDetail` (it's currently graph-only) as part of this.
- Tests: traversal shape incl. cycles/depth; unconfirmed-hints separation; panel rendering states.