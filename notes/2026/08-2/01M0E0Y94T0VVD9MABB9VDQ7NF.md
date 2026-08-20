---
id: 01M0E0Y94T0VVD9MABB9VDQ7NF
created: 2026-08-19T22:05:49.594765Z
updated: 2026-08-20T08:13:33.32996Z
type: task
title: Access Graph inception + ADR 0048
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 302
order: 3.0
sprint: sar11t4
assignee: steve
label:
- brief
priority: high
task_status: todo
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