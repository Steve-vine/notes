---
id: 01M11YJVG8RTJW4ZPKNW24DJ9B
created: 2026-08-27T15:49:26.66485Z
updated: 2026-08-27T15:49:30.599468Z
type: task
title: The requirement list is in the order it was imported, not the order of the standard
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 464
sprint: s8cjs5n
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: todo
---
PCI DSS lists its requirements in this order, on all three tabs of the framework
page:

    1, 1.1, 1.2, 1.1.1, 1.3, 1.1.2, 1.4, 1.5, 1.2.1, 2.1 …

Verified against production, not inferred.

## Cause

Requirements are ordered by a stored position, set from the row's index in the
seed CSV — and only ever on insert. The importer is insert-missing-only by design
(ADR 0028): an existing requirement is never re-titled *or re-ordered*.

That holds fine while a framework's CSV keeps its shape. It breaks the moment one
grows. PCI was first imported at `x.y` — 63 rows, positions 1–63. COM-422
re-imported it at `x.y.z` — 325 rows. The 63 rows that already existed kept their
positions from the *old* file; the 262 new rows were numbered against the *new*
one. Two numbering schemes in one column, interleaved.

## Scope

Only the two frameworks that grew in place. Everything that arrived as a new
version — CIS v8.1, Cyber Essentials Danzell, ISO 42001 — got a fresh framework
row and never hit it.

| Framework | Requirements | Positions claimed twice | Order wrong from |
|---|---|---|---|
| PCI DSS 4.0.1 | 325 | 49 | position 3 |
| HIPAA 2013 | 72 | 13 | position 7 |

The other eight are in exact CSV order. HIPAA's is milder and reads as a standard
appearing *after* one of its own implementation specifications —
`164.308(a)(3)(ii)(A)` before `164.308(a)(3)(i)`.

## The fix

**Re-sequence the whole framework on every import.** The CSV is the authority on
what order a published standard is in. Nobody wants a hand-sorted PCI, and the
"never re-order" rule was protecting something that does not exist for imported
rows.

**Repair the two already in the database.** The importer will not touch rows it
has decided not to re-order, so a migration has to renumber them — the COM-457
precedent applies: this is exactly the populated-database transformation branch
that a fresh-DB CI run never exercises. Reproduce against a copy of staging
before deploying.

**Decide where hand-made requirements go.** A requirement added through *New
requirement* is in no CSV, and today lands at max+1. A blind re-sequence would
renumber it into the middle of the standard or drop it. They should keep their
relative order and sit after the imported rows.

## Notes

- Ordering is not the frontend's problem — all three tabs already order by the
  stored position, and the API returns it that way (`frameworks.py`,
  `coverage.py`, `mappings.py`). Do not fix this by sorting in the browser: refs
  are not sortable as strings, which is why the column exists, and HIPAA's
  `164.308(a)(1)(ii)(A)` would defeat any natural-sort heuristic that worked for
  PCI's dotted numbers.
- Stacks cleanly with COM-460 (grouping nodes render as headings). That task makes
  the hierarchy visible; this one puts it in the right order. Either can land
  first, but the two together are what make a long framework readable.

Tests: after import, a framework's stored positions match its CSV row order
exactly, for a framework seeded fresh *and* for one seeded at an earlier
granularity and re-imported; a hand-made requirement survives a re-import and
stays after the imported rows.
