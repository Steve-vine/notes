---
id: 01M0N7D2QY2CG7A6P0A8YX21XS
created: 2026-08-22T17:13:27.038767Z
updated: 2026-08-22T17:13:27.038767Z
type: task
title: Conditional questions — a child question asked only when its parent's answer triggers it
assignee: steve
priority: medium
label: feature
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 366
---
Dependent questions for the vendor question bank, approach agreed 2026-08-22: **no new kind** — a visibility condition on the child. Any existing kind can be a follow-up; a select's outcomes fan out to different children. This keeps every question a first-class bank row, so answer identity, prompt snapshots, the (assessment, question) unique constraint and percentage-complete all work untouched.

## Model

- [ ] `VendorFormQuestion` gains `parent_question_id` (FK, nullable) and `show_when` (JSONB list of the parent's option values that trigger the child; boolean parents use their two values; multi_select parents trigger on *any* match).
- [ ] Parent must be an answer-picking kind (`select` / `multi_select` / `boolean`); **one level only** for now — a parent may not itself have a parent (server-validated; chains + cycle guards are a later decision, not an accident).
- [ ] `show_when` values must be a subset of the parent's `options`; editing the parent's options re-validates children (removing a triggering option — block or warn, decide in review).
- [ ] Retiring a parent retires its active children (or is blocked while it has any — pick one and say why).

## Composition & validation

- [ ] A form containing a child must contain its parent, ordered before it — validated at form save.
- [ ] **Required means required-when-visible.** Submit validation checks a child only when its condition is met, and **rejects** answers to non-applicable children (a changed parent answer must not leave a contradictory orphan). The incremental upsert clears a hidden child's draft when the parent's answer changes away from its trigger.
- [ ] **Percentage complete is dynamic**: denominator = currently applicable questions. Correct that it shifts as answers arrive.
- [ ] A non-applicable child has no answer row — the record stays interpretable with zero snapshot changes.

## UI

- [ ] Question builder: an optional "Only ask when…" (parent picker limited to eligible kinds, then trigger-option multi-select).
- [ ] `FormBuilder` and both fill surfaces (Vendor Portal + internal) render children indented under their parent, shown/hidden live as answers change.

- [ ] Tests: trigger/untrigger shows, hides and clears; required-when-visible at submit; non-applicable answer rejected; multi_select any-match; one-level and subset validation; form-composition ordering; retirement rule; percentage with hidden children.