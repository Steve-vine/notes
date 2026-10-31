---
id: 01M68M44WZ1YF1AZ9HTXB5P20S
created: 2026-10-31T09:19:49.151608Z
updated: 2026-10-31T12:59:21.067686Z
type: task
title: ADR 0137 — Actions is one list where every open thing has exactly one action, with an owner, a due date, a Type and an Action, and emails only inside its window
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1468
sprint: scpaa6p
comments:
- id: 01M68PVC84FKA5HMTZ5E137P3S
  author: Steve Vine
  at: 2026-10-31T10:07:27.492293Z
  text: |-
    Done — PR #1485 merged (e5924a82).

    - **ADR 0137** is in `decisions/0137-actions-one-list-one-action-per-thing.md`. ADR 0055 has a short amendment pointing to it.
    - **The per-type table** covers every module, giving each kind of work its Type, Action, what it's due on, its window and what closes it. These are the labels the screen, email and Polaris now use (COM-1470).
    - **Calls for you to confirm** are in the ADR's "Calls made" section. I added one beyond the task:
      - **Mail goes to owners only.** Before, the digest mailed everyone who could see a row. Managers now see others' work with My actions off.
    - **Starting point:** each type's default owner starts as its module's team (everyone who runs that module), so day one changes nothing about who sees what.

    To review: read the table in the ADR and tell me any Type or Action wording you'd change. Changing a label is a one-line edit.
- id: 01M690P43B5F3PTSRZ82TZAKWG
  author: Steve Vine
  at: 2026-10-31T12:59:21.067446Z
  text: 'Pre-UAT (staging, 31 Oct, 13:00 GMT): Couldn''t check. The "done when" needs you to agree the per-type table in ADR 0137. The labels as built are visible on Admin ▸ Actions on staging, which is the easiest place to read them.'
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint 100, Actions. Records Steve's design of 2026-10-30/31 and amends ADR 0055 (Actions is every module's work queue and the source of its mail).

## The rules

1. **One list.** Actions stays the single place for work. There's no separate "my work" list.
2. **One action per thing, until the thing is closed.** Steps that follow each other show one at a time: an incident is *Triage*, then *Decide notifications*, and so on, never two at once. Several of the same step on one thing roll up into one row ("Decide 3 notifications").
3. **Every action has an owner.** Generated work goes to the type's **default owner**, which is a person or a **Compass role**. An action owned by a role counts as "mine" for everyone who holds that role. Defaults are set once for every company, and a company can override them.
4. **Every action has a due date.** Work with no date of its own is due a set number of days after it arrives (set per type).
5. **Notification window.** Each type has one. An action emails only inside its window, or once overdue. Outside the window it's on the list but quiet.
6. **Type and Action.** Every row says what the thing is (*Gap*, *Risk*, *Incident*, *Vulnerability*, *DDQ*…) and what to do (*Remediate*, *Create a treatment plan*, *Triage*, *Fix*, *Answer questions*…). Incidents are called incidents, never "reports".
7. **One Status everywhere:** **Overdue** (past due) · **Due soon** (inside its window, so emails are going) · **Upcoming** (due within the horizon, 90 days unless changed) · **Later** (beyond it).
8. **Repeating reviews are always on the list.** Risks, control assessments, assets, vendors, policies and Q&A answers always show with their next review date, under **Later** until it gets close.
9. **The screen:** **My actions** (on by default) and **Upcoming only** (on by default). Sorted by due date, overdue and nearest first. Type chips appear only for types with something in them.

## The per-type table

The ADR lists every action type with its Type, its Action steps in order, its default owner and due date, its window, and what closes it. This task builds that table from the 70+ types in `core/actions/`. Steve agrees the table before the module tasks start.

## My calls (Steve to confirm)

- **Day one changes nothing about who sees what.** Each type's default owner starts as the built-in role that today's module-wide audience comes from (e.g. incident handlers, Access Admin). Administrators re-point them on Admin ▸ Actions.
- **Roles are for default owners only.** A gap, risk or incident is still owned by a person. Its action falls to the default owner only while it has no owner, or its owner has left.
- **Windows start at today's values** (risk review 30 days, plan activity 14, DSR 7…), and administrators can change them per type.
- **Company-wide roll-ups go** ("3 plan entries are overdue", "a company's overdue incidents"). Each item is already one row with an owner. Managers turn My actions off and filter to Overdue.
- **The Portal's Actions page gets the same columns and statuses.** Polaris's actions tool reports Type, Action and Status, so nothing reads "Other".
- **Creating something by hand needs an owner,** pre-filled with whoever is creating it.

**Chain:** independent (documentation only).

**Done when:** the ADR is merged and Steve has agreed the per-type table.