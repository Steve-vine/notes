---
id: 01M57VSQSH1S16GRE5WP9ECNW4
created: 2026-10-18T15:59:00.401411Z
updated: 2026-10-19T01:10:38.481821Z
type: task
title: Attestations appears in the Modules menu and opens on Open — every role's content that's running now, how many have signed, the % complete, days left, and who's overdue or can't be reached
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1099
sprint: s7s7mn9
blocked_by:
- 01M57VR859FTKHNPFBF5TXVK5X
- 01M57VSAVDZNB1HE3N99211QTG
comments:
- id: 01M58VBS97ADHDNA2WNPY0C2CB
  author: Steve Vine
  at: 2026-10-19T01:10:37.606877Z
  text: |-
    Done: PR #1089, all checks green. It's now on main and re-testing before merge.

    - Attestations is in the Modules section of the menu, after Incidents, for anyone with the new permission to view attestations. It follows the company switcher; without the permission it's hidden.
    - It opens on the Open tab, with four figures at the top: Running now, Signed % ("32 of 45"), Overdue (people) and Can't be reached (people).
    - Below them is one row per role and document round: Role, Content, Opened, Deadline, Days left ("6 days left", "Ended 3 days ago"), Signed ("31 of 40"), % complete with a bar, and Overdue. Rows ending soonest come first, and a "sign again" round is labelled "Opened by new version 5". Filter by role or content, or show only rounds with overdue people; filters stay in the address.
    - A round stays on Open until its deadline has passed and everyone has signed, or 30 days after its deadline, whichever comes first.
    - Clicking a row opens the round page. Everyone in it shows as Overdue, Outstanding, Signed late or Signed, with dates. Where someone's signature was made for another role, it says so, e.g. "Signed for Engineer on 3 Oct". People still to sign are flagged "No email address" or "Can't sign in", with the reason.
    - Assigned, below the table, lists every role's content that isn't running right now, with cadence, when it next opens, and Scheduled or Stopped.

    Calls I made:
    - Rounds of deleted content or a deleted role are left off Open.
    - The figures at the top cover every open round and don't change with the filters.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 78, Attestations (ADR in COM-1092; Steve's decision: its own section). Builds on the portal section (COM-1095), because signatures are what fill the percentages, and on the new-version rounds (COM-1098).

## What people see

**Attestations** in the Modules section of the menu, for anyone with `attestations.view`, per company (company switcher as usual). It opens on the **Open** tab:

- Headline tiles: **Running now** (rounds open), **Signed** (overall % across open rounds), **Overdue** (people), and **Can't be reached** (people).
- A table of **open rounds**, one row per role and content: **Role**, **Content**, **Opened**, **Deadline**, **Days left** ("6 days left", "Ended 3 days ago"), **Signed** ("31 of 40"), **% complete** (a bar), **Overdue**. Rows ending soonest come first. A round opened by a new version is labelled so.
- **Clicking a row** opens the round: everyone in it with **Signed** (date, "late" where it was), **Outstanding** (due date) or **Overdue** (by how long). Where it applies, it also shows **No email address** or **Can't sign in** (no Entra account).
- **Assigned** sits below the table: every role's content that isn't running right now, with its **Next opens**. That covers "what is assigned by role", including what's scheduled or stopped.
- Filters: role, content, and "only with overdue". They're kept in the address (URL-backed list filters).

A round stays on Open until its deadline has passed and everyone has signed, or until 30 days after its deadline, whichever comes first. After that its final numbers live on in Compliance (COM-1100).

## Rules

- Counts follow COM-1094's rules: leavers drop out, new starters count from when they joined, and someone signed via another role counts as signed.
- Clicking a role or content goes to its own page. Clicking a person goes to their compliance history (COM-1100).

## Notes (technical)

- Read-only. New router under `/api/v1/attestations/…` gated on `attestations.view`.
- Add it to the sidebar's Modules group and the IA (`brief/information-architecture.md`). It needs a page header and tab titles per the screen conventions, `SortableTh` throughout, and breadcrumbs.

**Done when:** an admin sees what's running per role and content, with % complete and time left, and can drill into any round to see who's done, who's late and who can't be reached.