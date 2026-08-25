---
id: 01M0N7D2QY2CG7A6P0A8YX21XS
created: 2026-08-22T17:13:27.038767Z
updated: 2026-08-25T18:43:01.127558Z
type: task
title: Conditional questions — a child question asked only when its parent's answer triggers it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 366
sprint: sbph5q5
comments:
- id: 01M0NEK3NDV3H1KMA9JM158C1S
  author: Steve Vine
  at: 2026-08-22T19:19:04.621Z
  text: |-
    Done — PR #369, merged to main.

    **Model** — `parent_question_id` + `show_when` on `VendorFormQuestion` (migration 0099, FK `RESTRICT`, indexed). No new kind, as agreed.

    **Core** — new `core/vendor_conditions`, the single place that decides what a questionnaire is asking. Applicability is derived, never stored: it is a function of the answers so far, and a stored flag would go stale the moment somebody edited a parent. The progress denominator, submit validation and the save guard all ask it.

    **The two open questions, decided:**
    - **Removing a triggering option → blocked**, not warned. The follow-up could never be shown again — it sits in the bank looking live while being unaskable, and nothing would ever say so. The refusal names the stranded follow-ups, so it is actionable. (Changing a parent's *kind* away from an answerable one is blocked for the same reason.)
    - **Retiring a parent → cascades** to its follow-ups. One that cannot be triggered is not live whatever its flag says, and refusing would force a two-step for the ordinary case where the follow-up exists only to serve that parent. Un-retiring deliberately does **not** bring them back: retiring a question is a decision about that question.

    **Rest of the checklist**: one level enforced both directions (a follow-up cannot be a parent; a question with follow-ups cannot become one), `show_when` subset-validated (booleans use a fixed `true`/`false` vocabulary since they carry no options), form composition requires the parent present *and ahead* of the child, required-when-visible at submit, non-applicable answers rejected (409 incremental, 422 bulk), parent-answer change deletes the orphaned child answer, dynamic percentage, no answer row for a non-applicable child.

    **One thing worth flagging**: making the show/hide genuinely live needed a change to the portal's save-on-blur design. Fields kept their drafts privately, so a follow-up stayed hidden until focus moved elsewhere. Drafts are now lifted to the page (fields still keep their own for the cursor's sake), so picking a trigger summons the question immediately.

    **Tests**: 15 backend cases (bank rules, one-level both ways, blocked option removal, retirement cascade + no un-retire, delete guard, composition ordering, cannot-answer-before-triggered, parent change clears child, multi-select any-match, moving denominator, both submit paths) plus a frontend unit test of the client mirror and a portal test that a follow-up appears the moment its trigger is picked and leaves when unpicked.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
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