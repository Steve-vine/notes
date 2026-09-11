---
id: 01M29401CR8VT2PDZ8HXAGCYNR
created: 2026-09-11T20:54:24.408114Z
updated: 2026-09-11T21:55:49.976119Z
type: task
title: Data asset modal — "Data entities", "Technology assets", lawful basis as a list of six
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 677
sprint: skdc1az
blocked_by:
- 01M293Z1H0B3WJCES8PTN449DP
- 01M293ZAG3CW35D99XA206T2R0
assignee: steve
label:
- improvement
priority: high
task_status: active
---
Smoke findings on the add/edit data asset modal, 2026-09-11 (Steve). The owner picker, review months and row alignment (COM-679 — descriptions stay above the input) are their own tasks; the *Held in* rename is covered by the wording task but is listed here so this modal is checked as a whole.

1. **"Data subjects" is labelled "Data entities"** — the field draws from the data rubric's data entities vocabulary (ADR 0072 §4) and should say so; description "Whose data this is — from the Data Rubric."
2. **"Containers" → "Technology assets"** on the *Held in* field and the mapped-asset rows (the wording task does the rest).
3. **Lawful basis becomes a select** of the six UK GDPR Article 6 bases: **Consent · Contract · Legal obligation · Vital interests · Public task · Legitimate interests**. Store as an enum `data_asset_lawful_basis` (`consent | contract | legal_obligation | vital_interests | public_task | legitimate_interests`), nullable. Migration: add the enum column, map existing free text case-insensitively where it matches a label (or the obvious variants — "contractual", "legal", "LI"), **log every value it cannot map and clear it** (the ADR 0042 §5 rule: nothing cleared silently), drop the text column. The CSV template lists the six words; the importer accepts labels or identifiers. `processing_purpose` stays free text. ADR 0072 §14 gains a one-line amendment.
4. **Review interval (months)** — arrives via the months task; this modal's field label follows.

Tests: the label, the six options with a stored value round-trip, the migration's mapping and logging. Regenerate `schema.d.ts`.

**Acceptance**: the field reads "Data entities"; lawful basis offers exactly six values and the detail page shows the label; an unmappable legacy value is logged in the migration output and left blank.