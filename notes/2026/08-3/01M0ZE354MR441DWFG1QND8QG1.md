---
id: 01M0ZE354MR441DWFG1QND8QG1
created: 2026-08-26T16:22:46.164556Z
updated: 2026-08-26T17:49:04.52738Z
type: task
title: Status pills are truncated on the Actions list — pills never truncate
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 433
sprint: sbph5q5
comments:
- id: 01M0ZK15GT7Y8VRJW4HREV0DCV
  author: Steve Vine
  at: 2026-08-26T17:49:03.897951Z
  text: |-
    Done — PR #418, merged to main.

    Pills show their whole label now, on Actions and everywhere else a status pill renders.

    The cause was worse than expected: Mantine clips a Badge from *both* ends — the root carries `overflow: hidden` + `text-overflow: ellipsis` alongside `width: fit-content`, and the label carries the same pair again. Inside a fixed-width cell, or as a flex item in a nowrap row, "fit-content" gets capped by whatever room is left and the ellipsis takes over.

    Fixed once in the theme rather than on StatusPill, because "pill" isn't one component — 48 files render a bare Badge, including the type badge and the "Overdue" badge sitting right beside the status pill on an Actions row. A fix on StatusPill alone would have sorted one of the three badges in that cell.

    The part that actually mattered was stopping them shrinking. Turning the overflow off on its own would let a squeezed pill spill its text over its neighbour; what you want is a pill that keeps its natural width and pushes the column out. Wrapping to two lines was the other option and I didn't take it — a pill that wraps stops looking like a pill.

    The Type and Status columns were pinned at 150 and 180px, which fitted "Gap" and "Open". They're minimums now, so the content decides. And since the columns can grow, the table is wrapped in a scroll container so a narrow window scrolls the table rather than the page — the pattern Admin ▸ Users already uses.

    All three new tests confirmed to fail without the theme rule. Worth an eye on the real thing though: this is CSS, and a test that queries by text passes happily while the pixels are clipped. The Actions list with an access manager account is where the longest labels land together.

    One thing I got wrong and caught: I initially overwrote the existing `StatusPill.test.tsx` instead of appending to it, losing four tests (the dark/light variant one from DEV-730 among them). Restored and amended before it merged, so all seven are there — but worth knowing it happened.
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: review
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