---
id: 01M0Z95RFQ9FFZ3YAYPMTP7NAC
created: 2026-08-26T14:56:48.63112Z
updated: 2026-09-01T13:55:51.633618Z
type: task
title: A mapping says how much of a requirement it covers — not just that it touches it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 414
sprint: s8cjs5n
comments:
- id: 01M0ZQHH251CE94BNV3853GWDY
  author: Steve Vine
  at: 2026-08-26T19:07:54.30923Z
  text: |-
    Done — PR #420, merged to main.

    ADR 0056 is in `decisions/0056-a-mapping-says-how-much-of-a-requirement-it-covers.md`.

    **What shipped**

    - `control_mappings` gains `relationship` (NIST IR 8477: equal / subset_of / superset_of / intersects_with, not null) and `strength` (1–10, nullable, advisory — deliberately not an input to the coverage rule).
    - `framework_requirements` gains `coverage_complete` with its actor and date. Declaring it on a requirement with nothing mapped is rejected: "complete" is a statement about a set, and the empty set covers nothing.
    - Cover and posture are now separate questions (§3). Cover — does the Core library satisfy this requirement at all — is a property of the shared library. Posture — is this company doing it — is per company. Fully covered + unmet is an implementation gap; partly covered + met is a library gap. They are reported side by side, never multiplied into one number.
    - One derivation, in `core/coverage.py`. The coverage endpoint, the SoA export and the dashboard call it. Previously the rule was inline in the coverage endpoint and the SoA imported two private names from it. The SoA gains a **Cover** column and a test asserts the two surfaces cannot drift.
    - The crosswalk editor asks for the relationship; the field is required, so Add stays disabled until a curator chooses. Worded as consequences ("Does exactly this" / "Does part of this — the requirement stays partly covered") rather than the set-theory terms.

    **The backfill, and the number moving**

    All 425 seeded mappings became `intersects_with` with a null strength — not `equal`, and not a guessed number. They came from a keyword match, so anything stronger would have been a fabricated claim in an audit artefact.

    The consequence, asserted in `test_seeded_crosswalk_leaves_nothing_fully_covered`: **nothing in any framework currently reads fully covered.** Framework coverage drops on deploy before a single control changes. That is §6 working as intended — COM-428 re-derives the crosswalk requirement-first and the number comes back up honestly. COM-429 puts the explanation next to the figure so it does not read as a regression.

    **Two things worth knowing for the rest of the sprint**

    - The new Postgres enum is created explicitly and referenced with `create_type=False`. An implicit `CREATE TYPE` passes on a fresh CI database and fails on an incremental deploy.
    - Check constraints: bare name on create, rendered name on drop, and **no `type_` argument** on the drop — passing it applies the naming convention a second time, which only fails on downgrade.

    **Tests**: 23 unit (the truth table directly, no DB) + integration across mappings, coverage, SoA and migration up/down. Full CI green.
assignee: steve
label:
- feature
priority: urgent
task_status: done
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
