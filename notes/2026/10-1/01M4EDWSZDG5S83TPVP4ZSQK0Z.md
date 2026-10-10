---
id: 01M4EDWSZDG5S83TPVP4ZSQK0Z
created: 2026-10-08T18:55:00.077469Z
updated: 2026-10-10T17:26:26.479052Z
type: task
title: HITRUST's 156 controls are mapped to the Compass controls that satisfy them — readiness comes from assessments already made
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 877
sprint: sfkkkex
blocked_by:
- 01M4EDWB7JZG4NSWXHHX7X6V34
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 66, HITRUST Framework (ADR in COM-875; the library is COM-876). This is the bulk of the sprint's content work. Nobody assesses anything again: each HITRUST control is tied to the Compass controls that satisfy it, and a company's existing assessments turn into a HITRUST readiness figure.

## What people see

- **Each HITRUST control lists the Compass controls behind it**, graded as on every other framework (does this, does this and more, does part of this), with a note saying why.
- **HITRUST gets a coverage figure** on its own page and on the Dashboard's compliance by framework.
- **A control in Compass shows HITRUST** among the frameworks it answers to.
- **Where nothing in Compass reaches a HITRUST control, it shows as unreached**, not papered over. Those are reported to Steve as a list, to decide whether the Compass library should grow. This task adds no Compass controls.

## Notes (technical)

- **Data file.** `data/mappings/hitrust-csf-v11-8.csv` with `core_key,requirement_ref,relationship,strength,note,coverage_complete`, keyed on the control's `key` (ADR 0059 §5).
- **Built requirement-first** (COM-428): for each of the 156, which set of Compass controls together satisfies it. Not a keyword match, and not control-first.
- **A HITRUST control is broad.** Each stands for many requirement statements Compass does not hold, so expect mostly `subset_of` and `intersects_with`, with `equal` rare. Set `coverage_complete` only where the set has been judged to close the control, and say why in the note (ADR 0056 §2).
- **Cross-checks, not copies.**
  - HITRUST categories 01 to 12 descend from the ISO 27002 structure, so the ISO 27001 crosswalk is a useful second opinion on each row.
  - HITRUST's published mappings to ISO, NIST and HIPAA are a third.
- **Every row resolves.** A test in the shape of `test_mappings.py`: no row whose `core_key` or `requirement_ref` is skipped by the importer.
- **Tiers do not move** (ADR 0069 §2: stored, not computed). Run the tier drift report with HITRUST present, attach what it would change as a comment, and apply nothing.
- **Report in the task comment:** covered / partly covered / unreached, overall and per domain, plus the list of unreached controls. Expect category 13 (Privacy Practices) to be the thinnest.

**Done when:** staging shows a HITRUST coverage figure derived from existing assessments, every HITRUST control lists its contributing Compass controls or shows as unreached, and Steve has the unreached list.