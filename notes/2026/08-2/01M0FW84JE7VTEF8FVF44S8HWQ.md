---
id: 01M0FW84JE7VTEF8FVF44S8HWQ
created: 2026-08-20T15:22:18.574062Z
updated: 2026-09-01T13:55:50.404696Z
type: task
title: Group kinds look apart on the canvas — per-type icon and colour
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 322
sprint: sar11t4
comments:
- id: 01M0GKJB3NZR9B3FTVMJZNKD1P
  author: Steve Vine
  at: 2026-08-20T22:09:50.197741Z
  text: |-
    Done — PR #311 merged to main, full CI suite green.

    Backend: the graph payload now says what kind of group each node is — group_type (nullable, groups only) on DirectoryGraphNodeOut and DirectoryGraphRefOut, populated from the existing names batch fetch (no extra query); schema.d.ts regenerated; integration tests assert it on group nodes and None on users/roles.

    Frontend: graphMeta.ts names each DirectoryGroupType once — security keeps the incumbent grape/IconUsersGroup; m365 is cyan/IconCloud, distribution orange/IconMailForward, mail-enabled security green/IconShieldLock. Distinct silhouettes at 18px (one deliberate substitution: IconMailLock doesn't exist in our Tabler version, and a second envelope variant would have been the two-near-identical-glyphs mistake — the shield-lock silhouette keeps the families apart). Colours all work as pale fills with dark text and stay clear of user-blue and role-teal. nodeAppearance(kind, groupType) resolves everything a node draws: shape still says the category (user pill / group box / role sharp), colour + glyph say the specific kind, and the node's second line reads "Microsoft 365 group" / "distribution list" instead of just "group". Unknown or absent type falls back to the generic group look — honest, never borrowing.

    Tests: registry distinctness (no two group types share a colour or icon, reserved colours respected), appearance fallback, model-layer passthrough, canvas label render.

    Note for the smoke test: this session's work moved to a dedicated git worktree mid-task — the primary checkout briefly carried my uncommitted edits while the sprint-37 session switched branches under it; recovered from the autostash with nothing lost, and the two sessions now work in separate worktrees.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Sprint 36 follow-up (graph improvements, 2026-08-20). Every group on the canvas draws identically (grape, IconUsersGroup) — a security group, an M365 collaboration group and a distribution list read as the same object, which is exactly the ISE-515 mistake ADR 0048's port was meant to avoid. Give each `DirectoryGroupType` its own glyph and colour.

* **Backend first**: the graph payload doesn't say what kind of group a node is. Add `group_type` (nullable — groups only) to `DirectoryGraphNodeOut` and `DirectoryGraphRefOut`; populate from the existing names batch fetch in `directory_graph` (no extra query). Regenerate `schema.d.ts`. Extend the integration tests.
* **Frontend registry** (`graphMeta.ts`, the named-once rule): per group type an icon + colour, all distinct by eye at 18px — security keeps grape/IconUsersGroup (the incumbent); m365, distribution and mail-enabled security each get their own (verify the chosen Tabler glyphs exist in our version; distinct silhouettes, not variants of one shape). Colours must work as pale fills with dark text (the light-fill/dark-text rule) and stay clear of user-blue and role-teal.
* **The node's second line** says the specific kind, reusing `GROUP_TYPE_LABELS` from `directoryLabels.ts` — "Microsoft 365 group", not just "group" (the kind must not live only in the hover title).
* Canvas + model: node styling keys off `group_type` when present, falling back to the generic group treatment for an unknown/absent type (honest fallback, never borrowing another kind's look).
* Tests: registry distinctness (no two group types share an icon or colour), node renders the specific label, backend graph test asserts `group_type` on group nodes and null on users.

Refs: ADR 0048 §1/§4; `api/v1/directory.py` (`directory_graph`), `api/v1/schemas.py`, `src/access/graph/graphMeta.ts`, `DirectoryGraphView.tsx`, `src/access/directoryLabels.ts`.