---
id: 01M0PV4QD0VSVMY3BTYQ6H2181
created: 2026-08-23T08:17:39.232516Z
updated: 2026-09-01T13:55:50.346493Z
type: task
title: One Assessments tab — questions authored on the assessment, the shared bank retires
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 380
sprint: sbph5q5
comments:
- id: 01M0QAMHVF4RSZ43N0C5W15E9T
  author: Steve Vine
  at: 2026-08-23T12:48:26.479321Z
  text: |-
    Done — PR #386, merged to main as de87313. One PR rather than the stack you expected; it held together.

    Model, API and UI as specified: `form_id` on the question, `vendor_form_items` gone, CRUD under `/vendor-forms/{id}/questions`, Vendor Questions retired and Vendor Assessments now **Assessments** — the list, then the picked assessment's question editor inline. `VendorFormQuestionCreate` also drops `company_id`: it comes from the assessment, so the two cannot disagree.

    Three decisions worth your eye:

    - **Unfiled questions.** You recommended dropping them. Unanswered ones are dropped with a count logged, as asked. **Answered** ones are parked on a retired "Unfiled questions" form instead — the answer tables' RESTRICT would refuse the delete anyway, and an answer whose question vanished is unreadable history. Dropping them is not something the schema permits.
    - **The onboarding fallback needed no replacement.** COM-190 had already moved questions off the onboarding request and onto assessments, so nothing was reading the bank for it — the fallback lived only in the docstring. "No onboarding form → nothing asked" is therefore already the behaviour, and `is_onboarding` is currently a column nothing sets and nothing reads.
    - **Which form keeps the original row.** Not in the brief, and it matters: answers point at that row by id. My first cut let it fall out of uuid ordering, which could leave a recorded answer hanging off a question belonging to another questionnaire. The keeper is now the form whose assessments have actually been answered; the earliest membership where none has; and where two have both been answered, only one can keep it, which the log says rather than passing over. The same test also caught a second case — a parent that moves to another form strands its follow-up, an original the duplication never touched — so re-pointing now covers every question, not just the copies.

    Both defects came from writing the migration test to assert identities rather than counts. Also: semgrep blocked the duplicating INSERT for interpolating into `sa.text`; it is built from SQLAlchemy constructs now. Full integration suite green (726).
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Today building an assessment is two tabs and two steps: author questions into the company-wide bank (**Vendor Questions**), then compose forms from it (**Vendor Assessments**). Decided 2026-08-23: collapse to a single **Assessments** tab — create an assessment, then create its questions directly on it. No pre-created bank, no membership step.

## Model

- [ ] Questions become **owned by their assessment**: `vendor_form_questions` gains `form_id`; the ordered membership link table goes. Ordering is the question's `position` within its form. Cross-form reuse is deliberately given up — duplication is cheaper than the two-step authoring it was buying.
- [ ] Everything on the question row survives unchanged: kinds, options, required, retire-don't-delete (`active=False` when answered), and the conditional fields (COM-366) — whose composition rule ("child's parent must be on the form") becomes automatic when both live on the same form.
- [ ] Answer rows still FK the question (RESTRICT) and snapshot prompts — the historical record is untouched by the restructure.
- [ ] **Migration**: a question on exactly one form gets that `form_id`; on several forms, it keeps one and is **duplicated** for the others (answers keep pointing at the original rows); bank questions on no form — decide: attach to nothing is no longer representable, so either drop them or park them on a "Unfiled" holding form. Recommend drop with a count logged (pre-live).
- [ ] The **onboarding form** designation (`is_onboarding`) stays; its questions are authored on it like any other. The old "fall back to the whole active bank when no form is designated" behaviour loses its meaning — decide the replacement: no onboarding form → the request modal asks nothing (recommended, and the Portal/admin UI should nudge that one be designated).

## API & UI

- [ ] Question CRUD moves under the form (`/vendor-forms/{id}/questions…`); the standalone bank endpoints retire.
- [ ] **Vendor Questions tab goes**; the **Vendor Assessments tab becomes "Assessments"**: list of assessments → an editor authoring questions inline (add/edit/reorder/retire, kinds and options, conditional "Only ask when…" picking parents from the same assessment). The Test button (COM-367) stays per assessment.
- [ ] Assessment Rules (COM-354) reference forms, not questions — unaffected beyond the tab rename around them.

- [ ] Tests: migration (single-form, multi-form duplication, unfiled handling); CRUD under the form; conditional parent scoping; onboarding behaviour with and without a designated form; retired questions stay on the form but out of new runs.

Sizeable — expect a small PR stack (model+migration, API, UI).