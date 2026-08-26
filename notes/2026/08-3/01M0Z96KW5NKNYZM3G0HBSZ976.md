---
id: 01M0Z96KW5NKNYZM3G0HBSZ976
created: 2026-08-26T14:57:16.677424Z
updated: 2026-08-26T18:28:37.026646Z
type: task
title: A framework has versions, and one of them is the one you are assessed against
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 416
sprint: s8cjs5n
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: todo
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
