---
id: 01KZ0YQ7TJ30GJKTE928QNPR98
created: 2026-08-02T10:01:12.27474Z
updated: 2026-08-05T12:34:06.94548Z
type: task
title: 'Tag roles: bind dictionary keys to Application / Platform / Environment'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 464
sprint: s7j0986
blocked_by:
- 01KZ0YPSH1HNW638H24A56D6FC
comments:
- id: 01KZ1301X8Q9QFGZAVNG7HDJ7J
  author: Steve Vine
  at: 2026-08-02T11:15:55.432283Z
  text: |-
    Built and up for review — PR #403 (feature/ise-464-tag-roles), merged to staging. Stacked on #402 (migration 0085 revises 0084) — merge #402 first.

    - TagRole table: one row per role, key_id NULL = explicitly unset; unique-on-key + PK-on-role enforce the one-key-per-role / one-role-per-key contract in the schema. Binding a key that fills another role moves it, and the audit detail names the move (moved_from_role).
    - Seeded app/project/env but not baked: the shipped vocabulary gains app + project keys (app/application aliases removed from service — two keys claiming one alias is nondeterministic resolution; the ISE-327 cross-key test rewritten against dd_service). Migration and boot-time ensure_roles bind by exact canonical name only — never through an alias. A human unset (bound_by) survives every future boot seed.
    - API: GET /tag-dictionary/roles (viewer) with per-role affected-entity counts; PUT /tag-dictionary/roles/{role} (admin) audits role_bound/role_unset and re-derives synchronously via the existing _reresolve contract. 404s for unknown role/key.
    - UI: "Estate roles" panel above the dictionary in Settings → Tags with per-role selects, an Unset badge + "ISE derives nothing — nothing is guessed" statement, and a confirm modal warning "this will re-evaluate N resources" plus any key move.
    - 7 new integration tests + 0085 populated-DB migration test; 3 new panel tests. All gates green both sides; API types regenerated on-branch.
assignee: steve
label: null
priority: high
task_status: done
---
Everything above the Resource line is derived from three tags. Which *roles* exist is structural; which *keys* fill them is configuration.

Aliasing is not sufficient and this is the case that proves it: an estate using `platform` for the platform role **and** `project` for something else entirely cannot be served by aliasing `platform` → `project` — that corrupts a real key.

- **Three roles**: Application (which Application a Resource belongs to), Platform (platform-owned vs application-owned), Environment.
- **Bound to canonical dictionary keys by explicit selection**, seeded `app` / `project` / `env` but not baked in.
- **Exactly one key per role** — assigning a role moves it off whatever held it.
- **A role may be unset**, and ISE says so plainly rather than silently deriving nothing.
- **Rebinding is audited and warned** ("this will re-evaluate N resources") — it re-derives Application membership estate-wide.

**UI**: a visible panel in Settings → Tags stating "ISE builds the estate from these three tags" with the current bindings — discoverable on purpose, not three checkboxes someone finds while editing a key.

**Acceptance**: an operator can see which keys fill the three roles and change one; changing one re-derives membership and is audited; an unset role is stated, not silently ignored.