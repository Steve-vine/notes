---
id: 01M1TSTPJ75B129G0MD5T3GM1B
created: 2026-09-06T07:27:21.671718Z
updated: 2026-09-06T08:31:24.135702Z
type: task
title: a mapping's strength says how much, not how sure — and the crosswalk says otherwise
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 567
sprint: s2fcksg
comments:
- id: 01M1TVE7FVFK3F63MBY4MJ7265
  author: Steve Vine
  at: 2026-09-06T07:55:30.170951Z
  text: |-
    Done — PR #575, merged to main.

    1. The coverage table's tooltip now copies the edit form's wording verbatim: "How much of the requirement this control accounts for, 1–10. Advisory — it does not move the coverage figure."

    2. 979 `equal`/`superset_of` rows regraded to 10 across all ten CSVs (pci-dss 312, cis-v8.1 152, cis-v8 152, nist-csf 105, iso-27001 92, hipaa 57, soc-2 39, cyber-essentials-3-3 27, iso-42001 22, cyber-essentials 21). A regeneration of the data files, not a migration — the seed import updates grading in place on every deploy and would undo a migration. Verified mechanically that only the strength column moved: all 979 changed lines differ in field 3 alone. Notes, relationships and coverage_complete are byte-identical.

    Including the two superseded sets (cis-controls-v8, Willow), which COM-428's grading standard excludes. That exclusion is about re-mapping — Danzell restructured the questions — and this changes no claim about what maps to what, only what the number means. It means the same thing in a historic assessment as in a live one.

    3. Third point taken: strength is now left off the row when it is 10. Keyed on the value rather than the relationship, so a curator who hand-grades an `equal` mapping at 7 still sees it — the surprising case worth showing.

    The alternative (make it confidence) was not taken: that is a second dimension and would need ADR 0056 superseded, not edited. The data was the thing that was wrong.

    A new file-level test holds the invariant over every slug rather than just the rebuilt ones.

    Smoke test: a framework's Coverage tab — a requirement satisfied outright by one control should now show the relationship badge with no number beside it, and a partial contributor should still show e.g. 6/10 with the corrected tooltip on hover.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Raised by Steve, 2026-09-06, after asking what the "7/10" beside a contributing control means. The honest answer turned out to be that the app gives two different answers, and the seeded crosswalk was built to the wrong one.

## The number means one thing

ADR 0056 §1 is unambiguous: strength is **how much of the requirement this control carries**, 1–10, advisory, never an input to the coverage figure. The mapping edit form says the same. **The coverage table's tooltip says something else entirely** — *"Confidence in this mapping, 1–10"* — which is a different question. How *much* of a requirement a control covers and how *sure* we are the mapping is right are independent: a control can carry the whole requirement on a mapping nobody is certain of, or a corner of one on a mapping that is beyond doubt.

## Which is why nothing ever reads 10/10

Steve's second observation, and it is the same bug wearing its other face. In the seeded crosswalk, of 2,329 mappings only **three** are strength 10:

| relationship | strengths in use |
|---|---|
| equal | **9** (493 rows), 8 (14), 10 (3) |
| superset_of | 8 (316), 7 (111), 9 (44), 6 (1) |
| subset_of | 3–8, mostly 5–6 |
| intersects_with | 3–5 |

`equal` means the control **is** the requirement. `superset_of` means it does the whole job and more. Under the ADR's definition both carry *all* of the requirement, so both are 10 by construction — and yet 493 `equal` mappings are sitting at 9.

That is not a curator being cautious about extent. It is a curator answering the *confidence* question: "very sure, but not certain". The crosswalk was graded to the tooltip's meaning rather than the ADR's, which is why a requirement satisfied outright by a single control still reads 9/10 and looks like something is missing.

It also means **strength carries no information at all for `equal` and `superset_of`** — it should be 10 on every one of them. The number only says anything for `subset_of` and `intersects_with`, which is exactly where a reader wants it.

## What changes

1. **The coverage table's tooltip matches the ADR** — how much of the requirement this control carries, advisory, not part of the coverage figure. The wording on the edit form is already right; copy it rather than inventing a third phrasing.
2. **Regrade the seeded crosswalk** so `equal` and `superset_of` are strength 10. The CSVs under `data/mappings/` are the source of truth and the import updates grading in place, so this is a regeneration of those files — **not a migration** (a deploy re-runs the seed import and would undo it).
3. Consider whether strength should be shown at all beside `equal` and `superset_of` once it is always 10. A number that never varies is furniture; the relationship badge has already said the control does the whole job.

## The alternative, so it is a decision and not a drift

If what Steve actually wants on that table is **confidence**, that is a legitimate thing to want — but it is a *second* dimension, not a re-reading of this one, and ADR 0056 would need superseding rather than editing. Do not resolve the ambiguity by quietly redefining the field to match the data: the data is the thing that is wrong.

## Related

- ADR 0056 — a mapping says how much of a requirement it covers.
- COM-428 — the requirement-first crosswalk rebuild that graded these rows.
- COM-458 — retiring seeded rows the crosswalk no longer claims; the same import path.
