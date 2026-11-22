---
id: 01M81D2XKBVVVQQB2X4N5N5QCF
created: 2026-11-22T10:33:31.499353Z
updated: 2026-11-22T10:33:52.046442Z
type: task
title: Reading groups — assign a document once to a group built from rules (everyone, roles, role-name phrase, Microsoft details, extras and exclusions); the role page's Content card goes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2097
sprint: sdy0mr7
blocked_by:
- 01M81D2CGW6Q47KBC0K7YG0WNZ
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint "Attestations - Tweaks and Improvements". Builds on the design note (COM-2096, ADR 0168). Raised by Steve while testing Attestations, 2026-11-22.

## What people see
- **Attestations ▸ Reading groups** (a new tab): a list of the company's groups with how many people are in each and how many documents they're asked to sign. **New reading group** opens a builder:
  - a name and a description
  - rules, combined: **Everyone in the company**; **Holds any of these roles**; **Holds a role whose name contains…** (e.g. "Team Manager"); **Department / Job title / Office / Employee type is…** (from Microsoft); **Also include** named people; **Leave out** named people
  - a live **preview**: who is in it now, and when editing, who the change adds and removes, before saving
- A group's page shows its rules, its members today (and why each is in it), and its **Content** card: the documents assigned to it, with assign date, deadline and cadence. This works exactly as the role's Content card did (add, change deadline or cadence, stop, restart).
- Membership keeps itself up to date: someone who joins, moves or leaves (or whose Microsoft details change) is added or dropped automatically. New members are asked straight away with their own deadline, the same as new role holders today.
- **The business role page loses its Content card.** In its place is a read-only line, "In reading groups: All staff, All managers", each a link. Content can't be assigned on a role any more.
- Everything about signing is unchanged: one request per document however many groups ask, the portal, chasing emails, overdue lists, evidence of operation.
- The Compliance tab's "by role" view becomes "by reading group".
- Existing role assignments (staging and the test company; production has none) each become a reading group named after the role, keeping their cycles and signatures.
- Polaris's attestations tools assign to and report on reading groups instead of roles.

## Implementation notes (technical)
- Migration: reading group + rule tables; stored membership refreshed on Entra sync, role-holder change and group edit (cycle membership and join dates must stay exact); assignment's role FK becomes reading-group FK, with a data step making a one-role group per existing assigned role. Append-only migration after the current head.
- Rule evaluation reuses the person attributes Compass already syncs; no new Graph reads unless the ADR says otherwise.
- Remove the role Content card and its write routes; keep a read route for "groups this role feeds".
- MCP: attestations_assign_content / list_role_* change to group-based tools (Copilot area tool count to be checked against the 128 limit).
- On the chain (migration + API change).

## Done when
- A group "All managers" built from "role name contains Team Manager" shows exactly the holders of those roles, and the preview shows who an edit would add or remove.
- Assigning a document to that group asks every member once. Someone also asked through another group still has one request.
- Giving someone a Team Manager role puts them in the group and asks them straight away. Removing it drops them from the counts but keeps their signatures.
- The role page has no way to assign content, and shows the groups it feeds.
- The staging role assignments appear as one-role groups with their history intact.