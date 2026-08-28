---
id: 01M156FR4YE0MP3HZ7WND6X0RP
created: 2026-08-28T22:05:16.830613Z
updated: 2026-08-28T22:05:28.42513Z
type: task
title: Access Graph — Entra roles on the canvas
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 504
blocked_by:
- 01M156F1652AT5QGN99BB0EACF
assignee: steve
company: null
label: feature
priority: medium
task_status: backlog
---
Put mirrored **Entra directory roles** (COM-444/445) on the access graph as a node kind and a new edge kind, and make a role rootable.

Why the graph rather than the list: privilege that arrives *through a group* is what a table hides. Somebody is a Global Administrator because they're in a role-assignable group, itself nested inside a group they were added to for an unrelated reason — on `DirectoryRolesPage` they appear as a Global Administrator with no explanation; on the canvas it's a chain you can follow and point at in a review. And a privileged role rooted is a naturally *small* graph (a handful of holders), so it doesn't hit the fan-out that makes a user-rooted canvas unreadable.

* **Vocabulary** (`graphMeta.ts` + `core/directory_graph.py`): node kind `directory_role` with its own glyph, colour and shape — distinct from business-role teal, these are different things and must not read as one. Edge kind `holds`, principal → role, with its own chip in the edge filter and an entry in the object filter.
* **Traversal**: `DirectoryRoleAssignment` stores **direct** assignments only. A person holding a role via a role-assignable group is derived at read time by joining the group's membership — so don't flatten it: draw person → group → role and let the chain do the explaining. Cycle guard, depth bound and vanished-object exclusion as everywhere else in `directory_graph.py`.
* **Active vs eligible must not blur.** Two `assignment_type` values, two visual treatments (solid vs dashed stroke) and two spoken phrases — "holds" and "can activate". The same principal can legitimately hold one role both ways; that's two edges, not a contradiction. One line style for both would merge "is a Global Administrator" with "could become one", which is the whole point of the distinction.
* **Holders the mirror can't name.** `principal_type = other` (service principals) must draw as an unresolved holder node — honest and counted, never dropped. Under-reporting privilege is the exact failure the COM-444 table exists to prevent, and a canvas that silently omits a service principal is that failure with a picture on top.
* **Eligibility read failure travels too.** When `eligible_available` is false, the canvas carries the same `EligibilityWarning` the roles list shows (reuse the exported component). A graph showing only active holders, without saying so, is worse than no graph.
* **Rootable**: `/access/graph?root=<role_definition_id>`, and "View in graph" from `DirectoryRoleDetailPage`. Note Entra roles are **tenant-wide, not company-scoped** — unlike the business-role overlay there is no company gate, and the Access section's own permission boundary (ADR 0045 §9) is what protects them.
* Read-only, like the rest of the directory roles surface: nothing here grants, revokes, or requests a role.
* ADR 0048 amendment for the new node + edge vocabulary; registry test keeping the model-layer and UI lists in step, as COM-323 did for object types.
* Tests: role-rooted walk, inherited-via-group chain, active and eligible drawn distinctly, unresolved holder rendered not dropped, eligibility warning surfaces on the canvas, filter chips.

Refs: ADR 0048 §4, ADR 0045 §9; `models/directory_mirror.py` (`DirectoryRole`, `DirectoryRoleAssignment`), `core/directory_graph.py`, `api/v1/directory.py`; `src/access/graph/graphMeta.ts`, `DirectoryRolesPage.tsx` (`EligibilityWarning`), `DirectoryRoleDetailPage.tsx`.