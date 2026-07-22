---
id: 01KY51638RPFFGZQ0YA2DQFKMT
created: 2026-07-22T13:45:32.184811Z
updated: 2026-07-22T13:46:17.406611Z
type: task
title: Incident "Affects" panel + what-if impact preview
project: 01KX671DATY39VW6GWK3M2T3DN
number: 216
sprint: s5khymf
assignee: steve
label:
- feature
priority: high
task_status: backlog
---
The flagship slice (Canon: "Impact & what-if") — the RDS scenario answered on the screen where it's asked: "Affects: Kora (production) — 3 dependent services".

- **Backend**: `GET /api/v1/entities/{id}/impact` — deterministic reverse traversal (incoming `depends-on`/`routes-to`/`part-of`, reuse `traverse()` in `estate.py`) returning: dependents with per-hop edge type and provenance; the entity's group memberships; its canonical `env:`/`service:` tags; and **unconfirmed edge proposals flagged distinctly** (never mixed in as fact).
- **Incident detail (DoD)**: an "Affects" panel for the incident's affected entity — headline line (groups + env), dependent list with provenance badges, link into the graph. Renders honestly when the graph is thin ("no known dependents — the graph may be incomplete", linking to edge assertion).
- **Entity page**: the same data as an "Impact preview" — this is the "what would happen if X failed?" answer from any entity, no incident needed.
- **Chat**: an assist/investigation tool exposing the impact query so "what would happen if X failed?" is answerable in conversation, AI narrating over the deterministic result (annotations, document summaries, criticality).
- Group membership becomes a first-class field on `EntityDetail` (it's currently graph-only) as part of this.
- Tests: traversal shape incl. cycles/depth; unconfirmed-hints separation; panel rendering states.