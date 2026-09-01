---
id: 01M0Z96KW5NKNYZM3G0HBSZ976
created: 2026-08-26T14:57:16.677424Z
updated: 2026-09-01T13:55:52.090063Z
type: task
title: A framework has versions, and one of them is the one you are assessed against
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 416
sprint: s8cjs5n
comments:
- id: 01M0ZTYC7KMRHPXJ8XWDAYAK5Y
  author: Steve Vine
  at: 2026-08-26T20:07:21.075451Z
  text: |-
    Done — PR #422, merged to main.

    ADR 0058 is in `decisions/0058-a-framework-has-versions.md`.

    **What shipped**

    - `frameworks` gains `effective_from` and `superseded_by` (self FK). The current version is the row with **no successor** — not an `is_current` flag, which two rows could both claim, leaving "which is current" with two answers that can disagree.
    - The slug already carried the version (`cis-controls-v8`), so a new version was already a new row by accident. This makes it deliberate.
    - A **superseded** version stays fully readable — its requirements, mappings, applicability decisions and any report made against it are exactly as they were. Coverage and the SoA still work on it. What it loses is the ability to take *new* per-company decisions (409). Deliberately not a new `status` value: `status` is what an operator sets, superseded is what the import sets, and folded together, un-disabling a superseded version would silently make it assessable again.
    - `carried_from` on the requirement records continuity **explicitly at import**, not by matching refs at read time. Refs get reused with different meanings — Cyber Essentials `UAC5` exists in both Willow and Danzell and means something materially different (Danzell makes MFA mandatory on all cloud services, and it is an auto-fail). It drives the carried / added / withdrawn diff at `GET /frameworks/{slug}/diff`.
    - `POST /frameworks/{slug}/carry-forward` copies the requirement-level applicability decisions for requirements that carried over. Explicit and never automatic — a version change is exactly the moment somebody should look. Idempotent and non-destructive: anything already decided on the new version is **skipped**, so someone part-way through scoping it keeps their own answers. The result reports `carried` / `skipped` / `left_undecided`.
    - A Versions tab shows the three sets and the carry-forward action; a Superseded badge sits on the page header so "why does our March report say Willow?" is answerable from the UI.

    **What this unblocks**

    COM-418 (Cyber Essentials → Danzell) and COM-419 (CIS v8.1) can now land beside their predecessors instead of overwriting them. CIS is the clean case — the refs are unchanged, so every requirement carries and the carry-forward is genuinely one click; it is a good first exercise of that code path before Cyber Essentials, where the answer is interesting.

    **Nothing was backfilled.** Every existing row is the current version of its framework, so `superseded_by` is correctly null everywhere. `effective_from` was left null rather than guessed — a plausible invented date in a governance tool reads as a fact until somebody checks. The one exception is PCI 4.0.1 (11 June 2024), which is known.

    **Tests**: `test_framework_versions.py` — 10 cases building a real successor with two carried, one added and 91 withdrawn. Full CI green.
assignee: steve
label:
- feature
priority: high
task_status: done
---
ADR 0058.

A framework carries a `version` string and nothing else — no sense of when it
took effect, what it replaced, or whether it is still the one certification
bodies assess against. So when a framework moves, there is nowhere to put the
new one except on top of the old one, and every historic assessment silently
re-points at text it was never made against.

This is not hypothetical. Cyber Essentials moved from Willow (Requirements v3.2)
to Danzell (v3.3) on **27 April 2026** — four months ago. Compass still holds
Willow, and there is no way to hold both.

## What changes for the reader

A framework shows which version is current, and from when. An assessment records
the version it was made against and keeps it — a report from March 2026 still
says Willow, because that is what was assessed.

When a new version arrives, the old one is marked superseded rather than
overwritten, and the framework page offers to carry an assessment forward,
showing which requirements changed, were added or were withdrawn.

## Implementation

- `frameworks` gains `effective_from` (date), `superseded_by` (self FK, null) and
  keeps `status` — a superseded framework is readable, not assessable.
- The `slug` already carries the version (`cis-controls-v8`), which is why a new
  version is currently a new row by accident. Make that deliberate: a version is
  a row, and rows are linked by `superseded_by` into a chain.
- Requirements are per-version, as now. Requirement continuity across versions is
  a `carried_from` FK on the requirement, set at import where the ref is
  unchanged — that is what drives the changed/added/withdrawn diff.
- Carrying an assessment forward copies the per-company state for requirements
  that carried over, and leaves the rest unassessed. It is an explicit action,
  never automatic — a version change is exactly when someone should look.
- The framework importer's tuple gains `effective_from`; it stays
  insert-missing-only (ADR 0028).

Tests: two versions of one framework coexist; a superseded version is readable
and not assessable; the diff names added, withdrawn and carried requirements;
carrying forward preserves state only for carried requirements.
