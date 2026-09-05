---
id: 01M1PXRA1F0283XGZY23M7Z5VM
created: 2026-09-04T19:18:59.887523Z
updated: 2026-09-05T07:28:21.017156Z
type: task
title: No estate walk excludes retired entities — the graph canvas is half dead nodes
project: 01KX671DATY39VW6GWK3M2T3DN
number: 780
sprint: s7nj09w
comments:
- id: 01M1Q25YPDF4NKHQYWNME5RKBR
  author: Steve Vine
  at: 2026-09-04T20:36:21.325841Z
  text: |-
    Done — PR #720 merged to main.

    **Fixed once, in the traversal layer.** `traverse` / `traverse_many` gain `include_retired: bool = False`. The recursive step JOINs `entity` and never *enters* a retired node, so nothing reachable only through one is reached either — a path through a dead host is a dead path. The root is the caller's to judge (a retired root still has a graph).

    **Every caller inherits the exclusion:** `impact_of` (incident blast radius), `investigation_context` (AI + MCP evidence plan), the MCP `traverse_graph` tool, the agent's one-hop neighbour count, and the Business Application `blast_radius` (ISE-779's fix falls out here — its acceptance test is PR #722).

    **The graph opts in.** `GET /entities/{id}/graph?include_retired=true`, the switch the Estate list already has. `EntityRef` carries `retired_at`, so the canvas can draw a retired node as one: a persisted "Show retired" toggle beside "Collapse collections"; a retired node renders dimmed (0.55), dotted border, with a `retired` line under its type — distinct from ghosted (0.22, an operator's reading choice) and from an unconfirmed proposal (dashed).

    Verify on staging: root the graph at `deepgram-api`, depth 3, `both` — the 107 retired nodes are gone; flip "Show retired" and they come back dotted.

    Side finding while merging: five consecutive `setup-uv` "fetch failed" on this PR's lint job. Reproduced from a runner pod — the runner now executes actions on Node 24, which tries the AAAA address first and g5 has no IPv6 route. PR #721 sets `NODE_OPTIONS: --dns-result-order=ipv4first` workflow-wide.
assignee: steve
label:
- bug
priority: high
task_status: done
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
