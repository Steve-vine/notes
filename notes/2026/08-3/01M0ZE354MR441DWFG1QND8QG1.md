---
id: 01M0ZE354MR441DWFG1QND8QG1
created: 2026-08-26T16:22:46.164556Z
updated: 2026-08-26T16:28:59.068366Z
type: task
title: Status pills are truncated on the Actions list — pills never truncate
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 433
sprint: sbph5q5
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: active
---
Follow-up to COM-409. The Actions queue went from five kinds of work to thirteen, and the labels that came with them are longer than anything the pill was sized for — "Unrequested change", "Access validation", "Waiting on a reply", "Pending validation". They are cut off mid-word.

## What changes for the reader

**A pill shows its whole label, everywhere.** Not just on Actions — the same pill renders statuses on assessments, gaps, risks, decisions, content and treatments, and a status you cannot finish reading is no better on any of them.

Sizing is what should give, not the text: a pill grows to fit its words, and the column grows to fit the pill.

## Implementation

Two things are clipping, and fixing one without the other still leaves a truncated pill.

`components/StatusPill.tsx` wraps Mantine's `Badge`, whose label carries `overflow: hidden; text-overflow: ellipsis` and a `max-width` by default — that is the ellipsis itself. Fix it on `StatusPill` rather than at each call site, so every pill in the app inherits it and a new screen cannot reintroduce it.

The plain `Badge`s in `actions/ActionsTable.tsx` are the same component and need the same treatment: the type badge, the "Overdue" badge and the "Waiting on a reply" badge. Worth asking whether they should just *be* `StatusPill`, or whether the shared styling belongs somewhere both can read — one place that says "this is what a pill looks like" is the outcome to aim for.

Then the columns. `ActionsTable` fixes Type at 150px and Status at 180px, which was fine for "Gap" and "Open" and is not for the current labels. Relax them so the content decides, and check the table still reads at a narrow window — the wide-content rule is that the table scrolls, not that the words disappear.

## Tests

A rendering assertion on the longest label is worth having, but the honest check here is visual — the failure mode is CSS, and a test that queries by text passes happily while the pixels are clipped. Worth a look at the Actions list with an access manager account, which is where the longest labels land together.