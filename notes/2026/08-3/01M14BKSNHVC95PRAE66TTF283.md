---
id: 01M14BKSNHVC95PRAE66TTF283
created: 2026-08-28T14:15:37.905958Z
updated: 2026-08-28T18:21:51.898809Z
type: task
title: Annex A reads as nine headings and then seventy controls — each heading belongs above its own
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 483
sprint: s31sysr
comments:
- id: 01M14QKBX5DMRJ2T80FVTQT1DG
  author: Steve Vine
  at: 2026-08-28T17:45:06.725062Z
  text: |-
    Done — PR #478, merged as 64bf76c.

    Annex A now reads the way the standard prints it: `A.2`, `A.2.2`, `A.2.3`, `A.2.4`, `A.3`, `A.3.2` … instead of nine headings followed by seventy controls.

    Data only, and it repairs itself: requirements are listed in the order of the vendored library and the importer re-sequences display order from it on every import, so staging and production renumber on the next deploy. No migration, and nothing scores against a heading so coverage and assessments were never affected.

    **The test is the real deliverable.** No framework had anything pinning a heading against its children, which is why this survived COM-430 — the existing tests pin *what* is in Annex A and *what* is non-assessable, and neither notices order. The new one asserts a depth-first walk of the tree reproduces the file, and runs against every framework with a tree, PCI's three levels included. I checked it fails on the old ordering and names `A.2.2` as the first divergence.

    Left alone as agreed: the clauses, the controls starting at `.2`, and the `A.6` flattening.

    One note for the record: CI's `deps-scan` failed twice on this PR before passing on rerun. It was the npm registry's audit endpoint erroring on all three retries — with CI's own flags (`--omit=dev`) there are zero vulnerabilities, and the identical lockfile passed on the sibling PR. Nothing to fix.
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: done
---
Defect in COM-430, found reading the 42001 requirement list.

Annex A currently reads `A.2, A.3, A.4 … A.10`, then `A.2.2, A.2.3, A.2.4, A.3.2 …` —
every heading first, then every control. A heading should sit directly above the
controls it groups.

PCI is the shape to copy, and it is already right:

```
1        Install and Maintain Network Security Controls   (heading)
1.1        Processes and mechanisms … defined and understood
1.1.1        Security policies and operational procedures …
1.2        Network security controls configured and maintained
1.2.1        Configuration standards …
```

42001 should read `A.2`, `A.2.2`, `A.2.3`, `A.2.4`, `A.3`, `A.3.2`, `A.3.3`, `A.4`,
`A.4.2` … which is also the order the standard itself prints them in.

**Cosmetic only.** The headings carry no answer of their own and nothing scores
against them, so coverage, mappings and assessments are untouched. This is the reading
order of a list, nothing more — which is why it is worth an hour and not a day.

## The fix

Reorder the vendored 42001 requirement list so each heading precedes its children.
That is the whole change: the importer re-sequences display order from the list on
every import (COM-464, after PCI hit a worse version of this), so the rows already in
staging and production renumber themselves on the next deploy. **No migration.**

**Add the test that would have caught it** — that within a framework, a heading is
immediately followed by its own children rather than by another heading. There is no
such test today, in any framework, which is exactly why this survived: the existing
42001 tests pin what is in Annex A and what is non-assessable, but nothing pins the
order. `test_the_missing_standards_are_added_in_cfr_order` is the nearest precedent.
Worth writing so it holds for every framework with a tree, not just this one.

## Leave alone

- **The clauses.** 4.1 through 10.2 already match the standard; there are no headings
  in the management system half.
- **Controls starting at `.2`.** There is no `A.2.1` in the standard — the `.1` under
  each heading is the objective statement, which is the heading. Not a missing row.
- **The `A.6` flattening.** `A.6.1.2`, `A.6.2.2` and the rest hang directly off `A.6`
  rather than off `A.6.1` and `A.6.2`. COM-430 flattened that deliberately rather than
  introduce a third tier for one heading out of nine, and it should stay flattened.