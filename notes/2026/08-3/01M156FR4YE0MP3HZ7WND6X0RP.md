---
id: 01M156FR4YE0MP3HZ7WND6X0RP
created: 2026-08-28T22:05:16.830613Z
updated: 2026-08-29T09:16:31.142889Z
type: task
title: Access Graph — Entra roles on the canvas
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 504
blocked_by:
- 01M156F1652AT5QGN99BB0EACF
comments:
- id: 01M169KBT11PYYTQ2PHGD41VPG
  author: Steve Vine
  at: 2026-08-29T08:18:55.42494Z
  text: |-
    PR #494 — https://github.com/Steve-vine/compass/pull/494 (branch feature/com-504-graph-entra-roles). CI fully green. Stacked on COM-503 (#493), so it targets that branch and merges after it.

    The chain is not flattened: a role's down-step yields the granting GROUP, never its members, and the ordinary walk expands that group on the next ring — so person → group → role draws itself with each hop a real row. Asserted both ways in the tests: `g-nested → dr-ga` is present and `u-ada → dr-ga` is provably absent.

    `holds` and `can_activate` are two edge values, not one with a flag. That fell out of the data as much as the design: edges are keyed by (source, target, type), so a single value would have silently deduped a principal who holds a role both ways down to one edge and lost the eligible fact. Same red, different stroke.

    An unnameable holder is drawn, counted, and labelled by its object id — a poor name and an honest one. It is deliberately NOT hideable in the object filter, unlike directory roles themselves: a reader may put privilege aside, but the canvas never offers to hide the holders it could not name.

    Eligibility is carried on the graph response only when a directory role is actually on the canvas, and is `null` otherwise — "eligibility could not be read" is not a fact about a walk with no roles in it, and null is not the same answer as "yes". Tested in all three states.

    One thing I found rather than was asked for, and fixed: stored reading preferences list which edge kinds are ON, so every existing reader would have got these two silently OFF — a canvas quietly missing privilege edges, which is precisely what this surface must never do. Preferences now carry a vocabulary version; their own choices are kept and anything added since is switched on, and writing any preference stamps the current version so the migration stops applying. There is a test for it.

    Vocabulary: `directory_role` is red and sharp-cornered, emphatically not business-role teal; `unresolved_principal` is grey with the question mark, which is what it is. Registry test extended to keep the model-layer and UI lists in step, as COM-323 did for object types.

    "View in graph" added to DirectoryRoleDetailPage. ADR 0048 amended for the new node and edge vocabulary. Read-only throughout — nothing here grants, revokes or requests a role.

    Tests: 31 in test_directory_graph.py (64 across the related backend suites), 816 frontend.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
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