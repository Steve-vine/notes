---
id: 01M1171HGA5ZXFS0EQ7P6B30DW
created: 2026-08-27T08:58:02.122115Z
updated: 2026-08-27T09:49:15.615226Z
type: task
title: 65 keyword-match mappings survive the crosswalk rebuild on existing deployments
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 458
sprint: s8cjs5n
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: backlog
---
Found while verifying the sprint 42 deploy. Staging holds **2,241** live mappings where the regenerated CSVs define **2,176**.

The 65 extra are rows from the old keyword-match crosswalk whose (control, requirement) pair no longer appears in any CSV. `import_mappings` inserts and updates by pair and never deletes, which is deliberate — ADR 0028 keeps the importer from clobbering a curator's work — so a row the rebuild dropped simply stays.

They are ungraded: `intersects_with`, no strength, spread across NIST CSF (18), PCI (11), and 9 each in ISO 27001, HIPAA, CIS v8 and SOC 2. A fresh install does not have them.

## Why it matters, and how much

Modestly. Verified on staging:

- None of the 15 requirements the rebuild recorded as genuinely uncovered has a leftover claiming cover for it, so the honest-gap reporting is intact.
- `derive_cover` only promotes on `equal` / `superset_of`, so a leftover cannot make a requirement read fully covered.

What it does do is put a phantom contributor on some requirement rows — a control showing "Overlaps with this" with no strength and no note, which is exactly the ungraded claim the sprint set out to remove. On the new cover/posture view (COM-429) that reads as a real contribution.

## The design question

Deleting them needs a rule that distinguishes "a seeded row the rebuild dropped" from "a mapping a curator created by hand", and the importer currently cannot tell the two apart — nothing records provenance on a mapping. Options worth weighing:

- Record provenance (seeded vs curated) and let the importer retire seeded rows absent from the CSV.
- A one-off migration that soft-deletes exactly these 65 by pair, with the list embedded as of that revision.
- Leave them and surface ungraded mappings in the UI as needing review, which turns the problem into a work queue rather than a cleanup.

The first is the durable answer and the third is the cheapest; the second fixes only this instance.
