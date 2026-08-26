---
id: 01M0ZSABMGBTNNK5CRRH7NB30B
created: 2026-08-26T19:38:56.528313Z
updated: 2026-08-26T19:40:02.983534Z
type: task
title: Sweep the whole site for pills that still clip their label
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 435
sprint: smnkt3k
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: backlog
---
Follow-up to COM-433. That task stopped the badge itself from clipping — a theme-level rule so every pill keeps its natural width and pushes its column out. Pills are still being cut off in places, so the rule is not reaching everything that reads as a pill.

## What changes for the reader

**A pill shows its whole label, on every screen.** No ellipsis, no word cut mid-way, no pill squeezed to a stub by whatever sits next to it. Where the pill cannot fit, it is the layout that gives — the column widens, or the table scrolls — never the text.

## Scope

This is a sweep, not a single fix. Walk the app and find them, rather than fixing only the one that was reported:

- Every list and table carrying a status, type, severity, maturity, criticality or count — assessments, gaps, risks, decisions, content, treatments, actions, vendors and engagements, access requests, roles, recertification, devices, groups, users, notifications, search results, the dashboard tiles, and both portals.
- Detail pages and modals as well as lists — a pill in a header row beside a title is the classic squeeze.
- Anything pill-shaped that is not the shared pill: bare Mantine `Badge`s, `Chip`, `Pill`, filter tags, tab count badges, and any hand-rolled rounded `<span>`. COM-433 fixed `Badge` in the theme; a component that is not a `Badge` never saw that fix.

Two causes to look for, and fixing one without the other still leaves a clipped pill: the pill's own overflow rule, and a fixed-width column or a `nowrap` flex row that leaves it no room. COM-433's answer to the second was to turn fixed widths into minimums and let the table scroll — the same answer should hold here.

Prefer one shared definition of "this is what a pill looks like" over a fix per call site, so a new screen cannot reintroduce the problem.

## Tests

A rendering assertion on the longest label is worth having wherever a new rule lands, but the honest check is visual — this is CSS, and a test that queries by text passes happily while the pixels are clipped. List the surfaces checked in the PR so the sweep is auditable.