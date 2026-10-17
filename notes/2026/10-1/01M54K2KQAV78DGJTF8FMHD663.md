---
id: 01M54K2KQAV78DGJTF8FMHD663
created: 2026-10-17T09:28:50.666882Z
updated: 2026-10-17T12:43:54.063597Z
type: task
title: 'ADR: the Security Assurance Plan — a company''s schedule of security work, each entry tied to the controls it proves, and "Evidence of operation" as the one place a control shows it is working'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1041
sprint: sxflvhs
comments:
- id: 01M54Y7QZY4AD9819Z7W85HV0N
  author: Steve Vine
  at: 2026-10-17T12:43:53.214771Z
  text: |-
    Done: ADR 0115 merged (PR #1041).

    Two changes from the brief above, both found in the code:
    - SAP-NN references come from one sequence across all companies, like every other reference in Compass (G-, R-, AST-, ACR-). Gaps aren't numbered per company as the brief assumed, and per-company numbering would be a new mechanism with no precedent.
    - The new permissions go to the built-in Admin role only. The starter roles (Viewer and the rest) keep the bundles they were frozen with, as when Inventory arrived. A test pins those bundles. Tick sap.view into Viewer in Admin ▸ Roles if you want it there.
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint 75, SAP - Schedule. Scoped with Steve on 2026-10-17. This record is the first task, and the rest wait for it.

## What the SAP is

A new module, **Security Assurance Plan**, shown in the Modules section of the menu as **SAP**. It holds a company's schedule of security work: training, testing, reviews and audits. It records each piece of work being done, with its evidence. It exists to satisfy SOC 2 and ISO 27001's asks around a security programme and regular training.

## What Steve decided (2026-10-17)

- **Entries:** title, description, type, owner, start and end date, status, a comments thread like Gaps, and evidence uploads (reports, screenshots).
- **Seen as a list, a timeline or a calendar.**
- **All ten suggested features are in this sprint:** recurring entries; links to controls; a completion record; owner nudges; activity types; findings become gaps or risks; a starter plan; an auditor export; a plan summary; assistant tools.
- **A. Training is evidence only.** You upload the completion export from the training system. Compass does not track each person's attendance; that would be a sprint of its own.
- **B. Delete only before an entry is done.** A done entry is audit evidence and stays. A skipped entry is **cancelled with a reason**, never deleted.
- **C. Annual sign-off.** Management approves a year's plan, recorded as who, when and a note.
- **D. The calendar also shows the reviews Compass already schedules:** access recertifications, asset recertifications and content reviews. They are read-only and link through to where they live.
- **E. Entries link to controls, not to framework requirements.** You can search by requirement ("A.6.3") and get the controls mapped to it. Framework coverage then follows from the existing mappings, so one link counts for ISO, SOC 2, NIST, CIS and HITRUST at once.
- **F. An overdue or cancelled entry only shows.** It appears on the control's assessment and in the plan summary. It never changes a control's status, raises a gap or moves compliance by itself. Status stays a person's judgement.
- **G. "Evidence of operation" is the pattern.** A company's assessment of a control gets an **Evidence of operation** list: every activity that proves the control is working, when it was last done with its evidence, when it is next due, and anything overdue or cancelled. This sprint, only SAP feeds it. Vendor reviews, access recertifications, asset recertifications and content reviews connect later (backlog COM-1060).

## What the record has to settle (Claude's calls, not confirmed by Steve)

- **One plan per company**, like Vendors and Inventory. The company picker in the top bar decides which one you see.
- **Every entry has a reference, `SAP-12`**, numbered per company like gaps. It's searchable in ⌘K and used by the assistant.
- **Types are a fixed list:** Training, Testing, Review, Audit, Other. Each has its own colour on the timeline and calendar.
- **Statuses:** Planned, In progress, Done, Cancelled. **Overdue is worked out** (the end date has passed and it isn't Done or Cancelled). Nobody sets it.
- **Recurring entries are laid out 12 months ahead**, so the calendar and the sign-off show the whole year. Each occurrence is its own entry: you can move, re-own or cancel one without touching the rest. Changing the series changes only occurrences that haven't started yet. (This replaces "the next one appears when one finishes" from the discussion, so the whole year is visible.)
- **Once done, an entry is frozen** except for comments, added evidence, findings, and a correction to its outcome note or completion date by someone who manages the plan. Every correction is kept in its history. Evidence can be added to a done entry, but never removed from one.
- **An owner works their own entries** without needing SAP permissions: comment, add evidence, mark done. They do this from the User Portal, like asset owners. Changing dates, owner or links, cancelling or deleting needs the plan permission.
- **Permissions:** `sap.view`, `sap.manage_plan` (add, edit, delete, cancel and complete any entry; run the starter plan) and `sap.approve_plan` (the annual sign-off). All three are added to the built-in roles where they fit.
- **The sign-off keeps a copy of the plan as it stood**, so the auditor sees what was approved. Later changes show as "changed since approval".
- **Coverage shows no headline percentage.** Most of a framework is technical controls that never need a scheduled activity, so a percentage would always look low. The view lists which requirements have planned activity and which don't, and the reader judges.
- **Evidence is files only**, under the same file rules as assessment evidence. A link to an outside report goes in a comment.
- **Content reviews belong to the shared Playbook**, so they show on every company's calendar, marked as Playbook.
- **The assistant can do what the screen does, except upload, download or export files** (ADR 0109).

## Notes (technical)

- Write the next free `decisions/NNNN-*.md`. **0114 is taken** by the software discovery sprint (`0114-discovery-finds-the-software-on-technology-assets.md`, not yet on main), so this is 0115 unless more have landed. Check every branch, not just main.
- Record the "Evidence of operation" contract generically: a source declares "this activity evidences control X for company Y, with last done, next due, evidence and warnings". Later sources (COM-1060) plug in the same way action sources do (ADR 0055).
- Most tasks add a migration, so the chain forces a serial stack (memory: stacked PR migration chains). Build in the order below; each task's blockers are set.

## Tasks (build order)

1. COM-1042 SAP in the menu: entries, add, edit, delete (first)
2. COM-1043 comments
3. COM-1044 evidence uploads
4. COM-1045 mark done / correct / cancel
5. COM-1046 repeating entries
6. COM-1047 timeline and calendar
7. COM-1048 other Compass reviews on the calendar
8. COM-1050 links to controls
9. COM-1051 Evidence of operation on a control's assessment
10. COM-1052 Coverage
11. COM-1053 Overview (plan summary)
12. COM-1054 owner nudges and the portal
13. COM-1055 findings become gaps or risks
14. COM-1056 annual sign-off
15. COM-1057 the standard plan
16. COM-1058 auditor export
17. COM-1059 assistant tools (last)

(COM-1049 doesn't exist: a failed write in Notuvia used the number.)

**Done when:** the record is accepted and the tasks above match it.