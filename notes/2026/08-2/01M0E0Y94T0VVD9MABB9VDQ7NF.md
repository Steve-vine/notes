---
id: 01M0E0Y94T0VVD9MABB9VDQ7NF
created: 2026-08-19T22:05:49.594765Z
updated: 2026-08-20T08:33:56.667477Z
type: task
title: Access Graph inception + ADR 0048
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 302
order: 3.0
sprint: sar11t4
comments:
- id: 01M0F4WCKE9QVZHAYEWZVFTCQD
  author: Steve Vine
  at: 2026-08-20T08:33:56.334179Z
  text: |-
    Done — PR #295 merged to main (squash 8adb4d9).

    Wrote **ADR 0048 — Access relationship graph** (decisions/0048-access-relationship-graph.md) recording all seven planned decisions: the ISE copy-adapt (@xyflow/react v12 + elkjs, model/canvas split preserved, explicitly not a shared package), the spanning-tree-plus-edges endpoint shape, the global-mirror read boundary with the company-scoped business-role overlay, the member_of/owner_of/grants edge vocabulary, transitive membership computed at read time via the shared expansion helper (COM-300 option 1), the users+groups scope cut with apps/service-principals deferred, and the IA amendment.

    The IA amendment is recorded in ADR 0045 itself as "Amendment (2026-08-20, COM-302)" following the repo's append-only amendment convention (the 0040/0026 pattern), pointing back at ADR 0048 for the graph's own decisions.

    Docs-only PR — the CI changes filter skipped the code jobs; secret scan green.
assignee: steve
label:
- brief
priority: high
task_status: review
---
Write **ADR 0048 — Access relationship graph**, recording the sprint's architectural decisions before any code lands (the ADR 0039/0045 shape: the whole domain decided once, delivered task by task).

**Decisions to record:**

* **First graph visualization in Compass.** Adopt `@xyflow/react` v12 + `elkjs`, **copy-adapted from ISE** (`EntityGraphView.tsx`, `lib/graphLayout.ts`, `EstateGraphPanel.tsx`) — sister app, same stack (Mantine 8, openapi-typescript, react-query), so the port is near-direct. Explicitly *not* a shared package: two repos with divergent domains; the thing to preserve is ISE's **split between a DOM-free model layer** (`graphLayout.ts` — all filter/collapse/truncation/warm-start logic, unit-tested without mounting the canvas) **and the canvas components**.
* **Endpoint shape** (ISE's hard-won lesson): traversal returns `nodes` as a spanning tree (one parent per node, with `depth`/`via_edge_type` for layout) *plus* `edges` as a separate list of **every** real edge between on-canvas nodes — reachability and drawing are different questions.
* **Boundary**: the graph reads the **global** directory mirror (ADR 0045 §3); company enters only through the optional business-role overlay (`BusinessRoleGroup`). Read-gated `require_access_read`; mirrors stay un-audited (inventory, ADR 0045 convention).
* **Edge vocabulary**: `member_of` (user→group and direct group→group nesting), `owner_of`, `grants` (BusinessRole→group, company-scoped).
* **Transitive membership is computed, not stored** — COM-300 option 1: `directory_group_nested_members` holds only the direct group→group edge; a shared recursive expansion helper walks it at read time, serving the graph endpoint, the member counts / group modal, and the recert snapshot (COM-300 lands on it).
* **Scope cut**: users + groups only. Enterprise apps / service principals are live Graph reads today, not mirrored — the graph reaching real resources needs an app-assignment mirror first, deferred to a follow-up sprint (note it as future work in the ADR).
* **IA amendment**: `/access/graph` joins the ADR 0045 §10 Access section (record as an amendment to §10, plus "View in graph" entry points on the group/user detail modals).

Refs: ADR 0045, 0046, 0009, 0017; ISE `app/frontend/src/components/EntityGraphView.tsx`, `src/lib/graphLayout.ts`, backend `api/v1/entities.py` graph endpoint.