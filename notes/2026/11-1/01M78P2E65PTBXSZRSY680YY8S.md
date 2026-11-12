---
id: 01M78P2E65PTBXSZRSY680YY8S
created: 2026-11-12T20:09:32.101254Z
updated: 2026-11-12T20:40:58.098565Z
type: task
title: Menu regrouped into nine groups (Risk split out of Posture; People; Trust; User Portal to Overview), each with a one-line description in the menu foot
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

Steve, testing on 2026-11-12. He first asked to rename "People & privacy" to "Privacy" and "Third parties & trust" to "Trust", then asked for a better way to slice the groups, keeping simple one-word names. He agreed this regrouping: "Yes, update COM-1779 with that".

What was wrong with the eight groups (ADR 0152 §5):
- **Posture** held eight pages doing two jobs: measuring against the playbook, and risk.
- **People & privacy** mixed Access Control, policy sign-offs, privacy requests and a person's own portal.
- **User Portal** is a person's own view, not a privacy tool.

He also asked for **one line of text per group** in the menu's bottom panel, on the right opposite the version, starting from his own wording. The lines below are his, with changes where marked; he reviews them on staging.

## The nine groups, in this order

| Group | Pages | Foot line | Icon |
|---|---|---|---|
| **Overview** | Dashboard, Actions, Initiatives, Reports, **User Portal** (moved in) | What needs doing | House (as now) |
| **Playbook** | Frameworks, Domains, Controls, Content, Decisions | How we intend to work *(Steve: "How we work")* | Books (as now) |
| **Posture** | Assessments, Gaps, Checks, Compliance | How we measure up *(Steve: "How we measure ourselves")* | Gauge (as now) |
| **Risk** *(new)* | Risks, Risk Assessments, Exceptions, Continuity (all moved from Posture) | How we plan for the unexpected | a warning/shield icon from the set already used |
| **Exposure** | Inventory, Vulnerabilities, Secrets, Security Feed, Incidents | What we have, and where it's at risk *(Steve: "How we keep things secure")* | Hard drives (as now) |
| **People** *(was People & privacy)* | Access Control, Attestations, Data Subject Requests | Who has access, and what we hold about people *(Steve: "How we keep people safe")* | Users (as now) |
| **Trust** *(was Third parties & trust)* | Vendor Management, Trust Centre, DDQ, Contracts, and the public Trust Centre link when live (last, as now) | Who we trust, and how we earn it *(Steve: "How we build trust")* | Handshake (as now) |
| **Assurance** | SAP, Audits, Evidence | How we prove it's all working | Stamp (as now) |
| **Admin** | Admin, Integrations, Activity, System status | How Compass is set up *(Steve: "Managing everything")* | Gear (as now) |

Within a group, pages keep their current order. User Portal goes last in Overview, and the four Risk pages go in the order above.

- Page names and addresses don't change.
- Who sees which page doesn't change (ADR 0026). A group with nothing the person can see is hidden, as now.
- Pins name pages, so nobody's pins change.

## The foot line

- The menu's bottom panel keeps the environment and build line on the left (ADR 0152 §1, COM-1749). On the **right**, opposite it, it shows the description of the group **currently shown**: the one pointed at, clicked, or reached with the arrow keys.
- When the menu opens on the current page's group, that group's line shows.
- While Find a page has text in it, the line is blank, or shows the highlighted match's group.
- Style: muted, the same size as the version line, never wrapping onto two lines at desktop width. On narrow screens (the stacked layout, §6) it is hidden rather than squeezed.
- The menu keeps one fixed height (COM-1749). With nine groups, check the groups column still fits without scrolling at 768px height.

## Notes for the build

- **Independent**, frontend only:
  - `app/frontend/src/components/nav.ts`: the `NavGroup` union, `NAV_GROUPS` order, `NAV_GROUP_ICONS`, each page's `group`, the comment above (rewrite it to the nine), and a new `NAV_GROUP_LINES: Record<NavGroup, string>`;
  - `CompassMenu.tsx`: the foot, `data-menu-foot`;
  - tests: `nav.test.ts`, `menu.test.ts`, `CompassMenu.test.tsx`. The group lists and the "public Trust Centre under …" tests change.
- `git grep` the old group names across `app/e2e` and `scripts/e2e` in case the Browser smoke opens a group by name.
- Amend **ADR 0152 §5** with a dated amendment (append-only): the nine groups and their pages, why they moved (Posture's two jobs; People; User Portal), and the foot line per group. Update the ADR 0152 line in `CLAUDE.md` ("eight groups" → "nine groups").
- Polaris has no menu, so nothing changes there.

## Done when

On staging:
- The menu shows the nine groups in the order above, each with exactly the pages listed. "Posture" has four pages, "Risk" four, and User Portal is under Overview.
- "People & privacy" and "Third parties & trust" appear nowhere in the app.
- Pointing at each group shows its line on the right of the foot, opposite the version. Arrow keys change it too.
- Opening the menu on the Risks page opens on **Risk**, showing "How we plan for the unexpected".
- Find a page still finds every page. Typing "risk" lists the Risk group's pages.
- Pins are unchanged for Admin A (8 pins), and number keys 1–6 still open the first row.
- The menu height is the same for every group, and the foot line is hidden at 390px.
- The Browser smoke is green, and the ADR 0152 amendment is in.