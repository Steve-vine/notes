---
id: 01M115CT24B0AGKKX2XKHCPDWZ
created: 2026-08-27T08:29:14.180799Z
updated: 2026-08-27T08:29:14.180799Z
type: task
title: The sprint's migrations can upgrade a database that already has the library
task_status: review
assignee: steve
company: moneypenny
label: bug
priority: urgent
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 456
---
Fix-forward from the sprint 42 staging deploy, which failed at the Helm pre-upgrade hook and rolled back. Staging was left safe — database untouched at 0112, previous build still serving — but nothing from the sprint was deployed.

## Why CI could not see it

CI only ever migrates a **fresh** database, and on a fresh database the whole domain consolidation returns early: migrations run before the seed, so there is no library to transform. Every defect lives on the other branch of that `if` — the one only a deployment that already holds the library ever takes.

Reproduced by building a faithful replica of staging: fresh Postgres, `alembic upgrade 0112`, seed the pre-sprint 35-domain library, run the chain. Same error, same migration.

## Three defects

**A VARCHAR bound into an enum column (0119).** `domains.status` is the `domain_status` enum but the table literal declares it `sa.String`, so Postgres rejects the insert of the two new domains. The comment on the line above warns about exactly this for `function`.

This is the one edit to a merged migration, taken deliberately: 0119 has never applied anywhere, so append-only was protecting history that does not exist, and no fix-forward was possible because `upgrade head` aborts at 0119 before reaching anything new. The `migrations` gate flags it and was overridden once.

**A retired control squatting on a ref (fixed forward, 0124).** `ix_core_controls_ref` was a plain unique index over every row, so the thirteen retired controls kept their numbers and no live control could move onto one. The rest of the schema already uses partial unique indexes for this reason. Narrowed to `WHERE deleted_at IS NULL`, which fixes the class — retiring a control now frees its number.

**A renumbering that disagreed with the library (fixed forward, 0124).** 0119 numbers the survivors one way; the regenerated controls.csv numbers 62 of the 256 differently, and the CSV's refs are the ones the 101 new controls were allocated around. The seed tried to insert `s42.INS.1` at `INS.11`, where the DLP control sat. 0124 realigns the 62.

## Verified

On the replica after the full chain and seed: 23 domains, 359 live controls, 13 retired, 2,176 mappings, no control without a description, no orphan mapping, zero refs disagreeing with the CSV. Re-seeding is stable, and a fresh database reaches the identical state.

## Follow-up worth having

CI still has no test that migrates a populated database, which is why three rounds of this went unseen. Vendor the pre-sprint library as a fixture and exercise the upgrade path in the suite.
