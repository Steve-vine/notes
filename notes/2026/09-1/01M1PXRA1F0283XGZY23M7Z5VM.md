---
id: 01M1PXRA1F0283XGZY23M7Z5VM
created: 2026-09-04T19:18:59.887523Z
updated: 2026-09-04T19:31:27.645691Z
type: task
title: No estate walk excludes retired entities — the graph canvas is half dead nodes
project: 01KX671DATY39VW6GWK3M2T3DN
number: 780
sprint: s7nj09w
assignee: steve
label:
- bug
priority: high
task_status: todo
tech: null
---
Companion to ISE-779, which is scoped to the Business Application blast radius.
The same root cause reaches four other surfaces, and one of them cannot even
display the problem.

**The root cause is the traversal layer.** `estate.py` and `impact.py` contain
**zero** references to `retired_at`. Every walk built on `traverse` /
`traverse_many` returns retired entities, and each caller then does
`select(Entity).where(Entity.id.in_(...))` with no filter of its own.

**Measured on staging**, rooted at `deepgram-api` (a live member of
`deepgram.test.us`), depth 3:

```
graph downstream    10 nodes     3 retired
graph upstream       2 nodes     0 retired
graph both         225 nodes   107 retired    ← 48% of the canvas
```

**Affected surfaces**

| Surface | Filters retired? |
|---|---|
| `GET /entities/{id}/graph` — the canvas | **No** |
| `impact.impact_of` — incident blast radius | **No** (`impact.py:234/246`, `397/407`) |
| `estate.investigation_context` — AI + MCP evidence plan | **No** |
| `business_applications.blast_radius` | **No** — ISE-779 |
| `GET /entities` — the Estate list | Yes (`include_retired=False`) |
| MCP entity lookup / listing | Yes (`tools_read.py:196, 320`) |

The AI one is worth calling out on its own: `investigation_context` is described
as turning "explore until you find what's related" into "here is exactly what's
related and how to look it up". Handing a model retired entities as evidence
targets spends tokens querying things that no longer exist, and invites a
confident answer about a host that was deleted three weeks ago.

**The canvas cannot even mark them.** `EntityRef`
(`api/v1/entities.py:138-144`) carries `id`, `type`, `name` and nothing else —
no `retired` flag — so a retired node is drawn identically to a live one. The
blast-radius list at least renders a "Retired" badge; the graph has no way to.
`stale_edge_target_ids` is not a substitute: it judges the *edge's* freshness,
only for direct neighbours of the root, and says nothing about the target
entity's retirement.

**Proposed**

- Fix it once, in `traverse` / `traverse_many`: an `include_retired: bool = False`
  parameter, defaulting to excluding them. Every caller inherits the right
  behaviour and each can opt in deliberately.
- **Exclude by default, but let the graph opt in.** These are not the same
  question. A dependency count must exclude a retired node — 51 dependencies
  that are really 19 is unusable. A topology canvas is the one place where
  seeing what something *used to* run on has real value, so the graph should
  keep the option and a toggle, the way the Estate list already has
  `include_retired`.
- Add `retired` to `EntityRef` and render it on the canvas — a dimmed or dashed
  node. Required whichever way the toggle defaults, because a shown retired node
  that looks live is worse than one that is hidden.
- `impact_of` and `investigation_context` take the default and exclude. An
  incident's blast radius and a model's evidence plan are both statements about
  what is true now.

Do this and ISE-779's own fix falls out of it; keep them separate only if the
traversal change proves too broad to land in one go.
