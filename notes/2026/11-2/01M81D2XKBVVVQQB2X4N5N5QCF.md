---
id: 01M81D2XKBVVVQQB2X4N5N5QCF
created: 2026-11-22T10:33:31.499353Z
updated: 2026-11-22T13:26:24.680505Z
type: task
title: Reading groups — assign a document once to a group built from rules (everyone, roles, role-name phrase, Microsoft details, extras and exclusions); the role page's Content card goes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2097
sprint: sdy0mr7
blocked_by:
- 01M81D2CGW6Q47KBC0K7YG0WNZ
comments:
- id: 01M81MD8ABBDETPCWMT6C6Z8MC
  author: Steve Vine
  at: 2026-11-22T12:41:30.187313Z
  text: |-
    Done: merged in PR #2079 (migration 0900_reading_groups, after Registers' 0893).

    What's in:
    - **Attestations ▸ Reading groups:** a new tab listing each group with who's in it, how many people, how many documents, and its status.
    - **The group builder:** rules (everyone, holds any of these roles, a role name contains…, Department / Job title / Office / Employee type / Company name is…), combined as any or all, then people included or left out by name, with leave-out winning. A live preview shows who the group holds now and who an edit adds and removes, before saving.
    - **A group's page:** its rules, its members with why each is in it, and its Content card (the role's card, moved). Archive and restore are on it. Delete is offered only if content has never been assigned.
    - **Kept members:** refreshed when the group is saved, when someone's roles change, after each directory read, and hourly. New members join any round running now with their own deadline. Leavers drop out of the counts and keep their signatures.
    - **The role page:** the Content card is gone. It shows "In reading groups: …" as links instead.
    - **Everywhere else:** Open, Compliance, exports and the portal's "why asked" are by reading group. Polaris reads groups and assigns, changes, stops and restarts content on them, but doesn't change a group's rules.
    - **Existing role assignments:** each became a one-role group named after its role, with rounds, people and signatures unchanged.

    Notes for Steve:
    - "Holds these roles" still counts a disabled role's holders. Only a deleted role stops counting.
    - "Everyone" means every enabled member account in the directory (no guests).
    - Old ?role= filter links on Attestations screens no longer filter.

    Done when: covered by integration tests. Those are: All managers by phrase, with the preview; sign once across groups; a new role holder joins and is asked straight away; a leaver drops out and keeps their signatures; the role page can't assign; and the migration test moves role assignments into one-role groups with history intact.
- id: 01M81PZFN8BXMWSGTZ4XJ5HB2E
  author: Steve Vine
  at: 2026-11-22T13:26:24.680337Z
  text: |-
    Pre-UAT on staging (f71fdd72e), E2E Test Company, as E2E Admin A: **Passed**, with one part I couldn't check. The mail catcher was on throughout.

    - **Phrase rule, preview, save: Passed.** New reading group "E2E Starters" with the rule "Holds a role whose name contains 'starter'". The preview showed 1 person, Compass Test (the E2E Starter role's holder). After saving, the group page showed its rule, its Content card, and Compass Test with why ("Holds a role whose name contains 'starter'", since 22 Nov).
    - **Edit preview: Passed.** Edit who is in it, then Leave out Compass Test. The preview said "Removes: Compass Test. Their signatures are kept." I cancelled.
    - **Sign once: Passed.** I assigned "Test document" to E2E Starters, made a second group "E2E Starter role" (rule: holds E2E Starter) and assigned the same document. Compass Test's attestations page shows **one** request, "In E2E Starter role and E2E Starters", with two rounds.
    - **Role page: Passed.** E2E Starter has no Content card. It has a Reading groups card: "In reading groups: E2E Starter role, E2E Starters", each a link.
    - **Existing role assignments: Passed.** Read-only check of staging's Test Company: its two earlier role assignments are now the groups "Service Desk Agents" and "Test Role 1", each with the rule "Holds <role>", 1 member, and their documents.
    - **Couldn't check: a role change moving someone in or out live.** That needs an access request that changes Entra, so it's covered by the integration tests only. Steve: give or remove a role for a test person and see the group follow.

    Cleanup: both test assignments are stopped (deadline 1 day). The groups are left in E2E Test Company for you to look at.

    Defect found and fixed forward in COM-2099: the menu still described Attestations as "each role".

    Screenshots: ~/compass-uat/attestations-tweaks/COM-2097/
assignee: steve
label:
- feature
priority: medium
task_status: review
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