---
id: 01M78P2E65PTBXSZRSY680YY8S
created: 2026-11-12T20:09:32.101254Z
updated: 2026-11-12T20:09:33.892317Z
type: task
title: 'Menu group names: "People & privacy" becomes "Privacy", "Third parties & trust" becomes "Trust"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1779
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
## Why

Steve, testing on 2026-11-12: "Rename People and Privacy to just Privacy. Rename Third parties and Trust to just Trust."

## What changes

In the floating menu (ADR 0152 §5), two groups are renamed. Their pages, order, icons and access rules stay as they are:

| Was | Now | Pages (unchanged) |
|---|---|---|
| People & privacy | **Privacy** | Access Control, Attestations, Data Subject Requests, User Portal |
| Third parties & trust | **Trust** | Vendor Management, Trust Centre, DDQ, Contracts, and the public Trust Centre link when live |

The new names appear everywhere a group name shows:
- the menu's group list;
- Find a page, which searches by group;
- any heading or trail that names the group.

Pins name pages, not groups, so nobody's pins change. Page addresses don't change either.

## Notes for the build

- **Independent**, frontend only: the `NavGroup` names, order list and icons map in `app/frontend/src/components/nav.ts` (and its comment), plus `nav.test.ts`, `menu.test.ts` and `CompassMenu.test.tsx`.
- `git grep` for both old names across `app/e2e` and `scripts/e2e` in case the Browser smoke opens a group by name.
- Amend **ADR 0152 §5** with a dated amendment (append-only) giving the new names. Update the one-line ADR 0152 summary in `CLAUDE.md` only if it names the groups (it doesn't today).

## Done when

- On staging, the menu shows **Privacy** and **Trust** with the same pages as before. "People & privacy" and "Third parties & trust" appear nowhere in the app.
- Typing "privacy" or "trust" in Find a page still finds those groups' pages.
- The Browser smoke is green.
- The ADR 0152 amendment is in.