---
id: 01M81A2WC8HSWADT9CR943R4AW
created: 2026-11-22T09:41:04.52049Z
updated: 2026-11-23T19:36:29.413125Z
type: task
title: Polaris adds and edits entries — add, update, archive with a reason, restore, link and unlink as the person; on a register's page "this register" is the one on screen
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2091
sprint: ssj8zkq
blocked_by:
- 01M81A2KFVFRYRDEBCDQ2FT208
comments:
- id: 01M847J05622SPTRWMXK927TZN
  author: Steve Vine
  at: 2026-11-23T12:54:37.478503Z
  text: |-
    Built and merged to main: PR #2096 (024f26294). No migration, no /api/v1 change.

    What people see:
    - Polaris changes entries where the person may edit them (owner, editors, administrators): add an entry, change values by field name, archive with a reason, restore, and link or unlink a control, gap, risk, SAP entry, document, decision, vendor, inventory asset or another register's entry.
    - Every change is recorded as the person: History reads "<name> via Polaris", and the activity log records the person, via Polaris.
    - It has no way to make, archive or delete a register, change fields or Mark as reviewed. It's told to say that's done on screen and give the link.
    - In the Polaris window, Registers, a register's page and an entry's page offer these tools and know "this register" and "this entry". The Entries list gains a tick column where Polaris is on, and ticked rows are "these entries". There are no ticks on a past As at day.

    Decisions made while building, for Steve to check:
    1. Links made on screen now appear in the activity log too. They weren't logged before.
    2. The five-entry rule is an instruction to Polaris, not enforced by Compass, as in the Library. Archive and unlink don't trigger a confirmation card, because both can be undone.
    3. "Via Polaris" is stored with the person's name on the history line, because its own column would need a migration. It therefore also appears in audit packs.
    4. Field names and choice values must match exactly. A link target named in words is linked only if one record matches, and the answer says which.
    5. Polaris can't reach an archived company's per-company entries, to read or change. The screen can still read them.

    Found while building: the activity log doesn't hide Restricted registers from people who can't open them. Confirmed in the code. Logged as its own task in this sprint.

    Tested against real Postgres: every write, each in History and Activity as via Polaris; all link kinds; a view-only person refused; a Restricted register reads like one that doesn't exist; a hidden record can't be probed by linking it; bad values list the valid ones; company rules. CI green.

    Not checked: a live AI provider or real Copilot agent, including the five-entry question, "add an entry to this register" and "these entries" in conversation; the tick column in a real browser; whether a Copilot agent picks up new tools by itself (check when setting up the Registers agent).
- id: 01M84EQJEPC14CT5YSBEYKHYDF
  author: Steve Vine
  at: 2026-11-23T15:00:00.086634Z
  text: |-
    Pre-UAT on staging e2248892e: PASSED in the Polaris window with the live AI provider. One line COULDN'T be checked.

    Account: E2E Admin A, E2E Test Company. Register E2E UAT 122 Import (UIM).

    - Polaris adds, edits, archives, restores, links and unlinks, each in history as via Polaris: PASSED. On UIM-8 it did all six, including a link to control INS.5 and a link to another register's entry (UPA-3), then unlinked that. The entry's History reads "E2E Admin A via Polaris" on each line. The Activity page shows the same, e.g. "created register entry UIM-8 · Polaris added (UAT) … via Polaris".
    - It refuses to change fields or mark a review, with the on-screen link: PASSED. "Add a field called Region": it says fields are changed on screen and links the Settings tab. "Mark this register as reviewed": it says that's done on screen and links the register's page. Neither happened.
    - "Add an entry to this register" works without naming it: PASSED, from the register's page. It made UIM-8 in UIM.
    - Someone who can only view a register can't change it through Polaris: COULDN'T CHECK. None of the non-admin test roles has Use Polaris. Steve should try it with a person who has Use Polaris and view-only access to a register.

    Also seen:
    - The Entries list has a tick column. With UIM-3 and UIM-5 ticked, Polaris read them as "these entries".
    - Asked to change all 7 entries, it stopped, listed each with its current value, noted the archived one would be skipped, and asked whether to do all 7 or the 2 ticked. I said no and nothing changed.

    Not tried: a real Copilot agent.

    Screenshots: ~/compass-uat/sprint-122/COM-2091/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint "Registers - Phase 2" (ADR 0167 §3, in COM-2087). Builds on "Polaris reads registers".

## What people see
- Polaris can, where the person may edit entries:
  - add an entry ("add the Data (Use and Access) Act 2025 to the obligations register, owner me, review in March")
  - change an entry's values
  - archive an entry with a reason, and restore one
  - link an entry to a control, gap, risk, SAP entry, document, decision, vendor, inventory asset or another register's entry, and unlink it
- It asks before changing more than five entries at once, listing them.
- It doesn't make, archive or delete registers, change fields, or Mark a register as reviewed. Asked to, it says that's done on screen and gives the link.
- Every change is in the entry's history and the activity log as made by the person, via Polaris.
- **Inside Compass**: the Polaris window on Assurance ▸ Registers, a register's page or an entry's page offers the Registers tools, and knows "this register" or "this entry". Ticked rows on a register's list are "these entries".

## Implementation notes (technical)
- Tools (write): `registers_add_entry`, `registers_update_entry`, `registers_archive_entry`, `registers_restore_entry`, `registers_link_entry`, `registers_unlink_entry`. Values keyed by field name in the tool input, resolved to field ids; unknown field or choice value → a clear error listing the valid ones.
- Polaris window: a `registers` section in `core/polaris/tools.py` `SECTIONS`, register and entry record kinds in `RECORD_SECTIONS`, and the `/registers` routes in `app/frontend/src/polaris/place.ts` `sectionOf`; send `on_screen` with the register or entry and ticked rows.
- Same permission checks as the screen (owner, editors, administrators).

## Done when
- Polaris adds, edits, archives, restores, links and unlinks entries, each showing in history as via Polaris.
- It refuses to change fields or mark a review, with the on-screen link.
- On a register's page, "add an entry to this register" works without naming it.
- Someone who can only view a register can't change it through Polaris.

Independent (no migration, no /api/v1 change beyond the Polaris context schema if needed — then on the chain).