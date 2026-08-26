---
id: 01M0Z95RFQ9FFZ3YAYPMTP7NAC
created: 2026-08-26T14:56:48.63112Z
updated: 2026-08-26T14:56:48.63112Z
type: task
title: A mapping says how much of a requirement it covers — not just that it touches it
company: moneypenny
label: feature
priority: urgent
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 414
---
ADR 0056. Foundation for the whole sprint — land this first so the crosswalk is
rebuilt once, not twice.

A mapping today records a pair and a free-text note. There is no way to say
whether a control fully discharges a requirement or clips one corner of it, so
both count the same and the derived framework score treats them as equal. That
would be academic if the crosswalk were dense. It isn't: **393 of the 407
covered requirements rest on exactly one Core control**. SOC 2 CC6.1 — the whole
logical access architecture — is satisfied today by ACC.2, "an access control
policy has been established".

## What changes for the reader

A requirement stops being covered-or-not and becomes **fully covered**, **partly
covered** or **not covered**. A partly-covered requirement says what is carrying
it and how far, instead of disappearing into a percentage.

Framework coverage on the dashboard will **fall** when this lands. That is the
point — the old number was not true, and nobody should start an assessment
believing it.

## The model

NIST IR 8477 Set Theory Relationship Mapping — what NIST uses for its own OLIR
crosswalks and what the Secure Controls Framework moved to in 2024.

- `relationship` — `equal`, `subset_of`, `superset_of`, `intersects_with`,
  read as "this Core control is _ this requirement".
- `strength` — 1–10, how much of the requirement this control carries.

A requirement is **fully covered** when any mapping is `equal` or `superset_of`,
or when a set of `subset_of` mappings has been marked jointly complete; **partly
covered** when it has mappings but neither holds; **not covered** otherwise.
Jointly-complete is a judgement made by whoever curates the crosswalk, so it is
recorded as a flag on the requirement with an actor and a date, not inferred.

## Implementation

- `control_mappings` gains `relationship` (enum, not null) and `strength`
  (smallint, nullable). `framework_requirements` gains `coverage_complete`.
- **Backfill every existing mapping as `intersects_with`, strength null.** Do not
  guess a better value: the 425 seeded rows are a self-declared starter set and
  the rebuild task re-derives them requirement-first. Anything stronger would be
  a fabricated claim sitting in an audit artefact.
- New Postgres enum — remember `postgresql.ENUM(create_type=False)` if the type
  is reused across migrations, or the deploy passes on a fresh DB and fails
  incrementally.
- Coverage derivation moves out of the count-based query into one function that
  the coverage API, the dashboard and the SoA export all call. Today the rule
  would be in three places.
- The seed CSVs under `data/mappings/` gain a `relationship` column; the importer
  stays idempotent and keyed on the pair.

Tests: each relationship type yields the right requirement state; three
`subset_of` mappings read partial until `coverage_complete` is set; a
backfilled row reads partial; the SoA export and the dashboard agree.
