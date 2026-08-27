---
id: 01M0ZSABMGBTNNK5CRRH7NB30B
created: 2026-08-26T19:38:56.528313Z
updated: 2026-08-27T21:46:32.473668Z
type: task
title: Sweep the whole site for pills that still clip their label
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 435
sprint: smnkt3k
comments:
- id: 01M12DFYS3AB407F24J78N4KJW
  author: Steve Vine
  at: 2026-08-27T20:10:00.35581Z
  text: |-
    Done — PR #454, merged to main as 807a1dc.

    The sweep found two things pill-shaped that COM-433's Badge rule never reached, and each failed a different way.

    Pill is the one nobody writes by hand: Mantine renders it for every value selected in a MultiSelect or TagsInput, which is 14 screens including the vendor data-entity and data-type pickers, approval areas, SSO role mappings, the assessment panel and the form builder. It clipped harder than Badge ever did — the label carried overflow:hidden with an ellipsis, and the root carried a shrinkable flex plus a max-width of 100%, so a value like "Special category personal data" was cut twice over.

    Chip failed inside out. It has no overflow rule at all, so squeezing it did not clip — its label is nowrap, so the text spilled straight across whatever sat beside it, which is worse than an ellipsis. The access graph's six edge filters share one row, which is where that showed.

    Both are now theme rules, alongside COM-433's, so a new screen inherits them.

    One hard width left in the app: a vendor flag's colour preview was pinned to 90px, so a flag named "Awaiting evidence" rendered its text straight out of its own outline. Now a minimum, not a cap.

    No table needed changing, and it is worth writing down why so the next sweep does not redo it: a fixed column width is a preference, not a cap. Before COM-433 a pill could clip itself to nothing, so its minimum content width was zero and the fixed width won. Now that a pill refuses to clip, its minimum width is its full label and an auto-layout table simply widens the column. All 118 fixed-width columns were checked against this.

    Also checked and clean: hand-rolled rounded spans (none exist — the only rounded thing is the SVG graph node), and tab count badges (none exist; Tabs has no overflow rule of its own).

    Tests assert both rules against a real MultiSelect and Chip.Group rather than against the theme object, so they still fail if a future Mantine renames a part and the override silently stops landing — which is the failure mode a theme override actually has.
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: done
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