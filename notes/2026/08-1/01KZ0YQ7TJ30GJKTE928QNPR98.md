---
id: 01KZ0YQ7TJ30GJKTE928QNPR98
created: 2026-08-02T10:01:12.27474Z
updated: 2026-08-02T10:04:19.977583Z
type: task
title: 'Tag roles: bind dictionary keys to Application / Platform / Environment'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 464
sprint: s7j0986
blocked_by:
- 01KZ0YPSH1HNW638H24A56D6FC
assignee: steve
label: null
priority: high
task_status: backlog
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