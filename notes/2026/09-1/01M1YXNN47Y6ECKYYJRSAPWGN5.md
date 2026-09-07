---
id: 01M1YXNN47Y6ECKYYJRSAPWGN5
created: 2026-09-07T21:51:28.391898Z
updated: 2026-09-07T21:56:17.02532Z
type: task
title: A control's gaps, in a box of their own — and the panel's box order
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 621
sprint: sa2t9sq
assignee: steve
label:
- feature
priority: high
task_status: todo
---
You can raise a gap from the assessment panel and then never see it again. The button sits in the corner of the Assessment box, the gap is created, the panel says "Gap raised" — and the control shows no sign that a gap exists against it, this time or ever. To find out, you leave the run and open the Gaps register.

A new **Gaps** box sits directly under the Assessment box, listing every gap raised against this control for this company. **Raise gap** moves out of the Assessment box's footer and into it, where the thing it produces is visible.

## What a reader sees

The box names itself and lists each gap on a line: its title, its status, who owns it and its target date. A gap is a link to its own page, where it is worked and closed. The list reads soonest-target-first with undated gaps last — the order the Gaps register already uses, so the same gaps do not appear in two different orders in two places.

With no gaps raised, the box says so rather than disappearing. A box that comes and goes is worse than an empty one, and its absence would read as "this control cannot have gaps".

**Raise gap** keeps the rule it has today: it appears only when the assessment is a shortfall — applicable, and either *not implemented* or *partial*. Raising remediation against a control you have just called implemented is not a thing to make easy. When the control is not in shortfall the box still renders and simply offers no button.

## The panel's box order

The assessment panel's boxes end up in this order, top to bottom:

1. **Assessment** — the work
2. **Gaps** — what the work produced
3. **Linked content** — the policies and procedures the control comes from
4. **Decisions** — what has been decided about it
5. **Frameworks** — who demands it

**Frameworks moves from first of the evidence boxes to last.** It is the longest box and the one least often read while judging a control: an assessor wants the policy and the prior decisions in front of them, and reaches for the framework list to answer "why does this matter" rather than "is it in place". Sending it to the bottom puts three shorter, more-used boxes above it and shortens the scroll to everything else.

This is the panel's order only. The Playbook control page keeps its own arrangement — there the frameworks and content are the page's subject and the assessment is the appendix, which is the opposite reading and deliberately so.

## The "Raise a gap" dialog

**It gets bigger.** It is the only modal in the app with no `size` at all, so it renders at Mantine's default — narrower than every other form dialog in Compass. It becomes `size="lg"`, which is what the app's form modals use (access requests, recertification schedules, group and device detail, adding people to a role). Not `xl`: that is reserved for the genuinely wide, multi-column forms like **New risk**, and this is four stacked fields.

**Both fields open empty.** The Title is prefilled with `${control.ref}: ` today; that goes, and the description is already blank.

Two reasons beyond the typing it saves. The Gaps register already carries a **Control** column, so the reference in the title is the same fact twice, and every gap title in the register reads with a redundant prefix. And the submit button is disabled on an empty title — but `"INS.1: "` is not empty, so today a gap can be raised whose entire title is a control reference. Removing the prefill closes that without adding a rule.

Keep `data-autofocus` on the Title. The cursor still lands in the field ready to type; only the reason in the comment beside it changes.

## Where

- New component beside the ones the two entry points already share — `FrameworksCard`, `LinkedContentCard`, `LinkedDecisions` — so it renders in both places, not just the queue.
- `pages/AssessmentsQueuePage.tsx` → `ControlAssessmentPanel`: the Gaps box goes immediately after `<AssessmentPanel />`, and `FrameworksCard` moves below `LinkedDecisions`.
- `pages/ControlDetailPage.tsx`: the Playbook control page renders `AssessmentPanel` too (line ~120). The Gaps box goes under it there as well — two entry points, one rendering; a gaps list on only one of them is exactly the drift the panel's own docstring warns about. Its existing box order is **not** changed.
- `components/AssessmentPanel.tsx`: the **Raise gap** button, the `gapOpen` / `gapForm` state, the `openGap` prefill and the whole "Raise a gap" `Modal` move out into the new component. The Assessment box's footer is left with **Save assessment** alone.

## The data is already there — no backend work

`GET /api/v1/gaps` already takes an `assessment` filter, and there is exactly one assessment row per (company, control) — a unique index enforces it, and revisions live in their own table — so the assessment's id identifies the control's gaps precisely.

Read it with the assessment the panel already fetches under `['assessment', companyId, control.ref]`; calling the same query from the new component is a cache hit, not a second request. A control with no assessment yet has no gaps and no shortfall: show the empty box.

**Edge, and deliberately not solved here**: if an assessment is ever soft-deleted and re-created, gaps raised against the old one keep their own `core_control_id` but fall outside this filter. `list_gaps` has no `control` filter today. If that case ever shows up in anger, adding one is the fix — it is a query parameter, not a redesign. Not worth carrying now.

## After raising

The new gap appears in the box without a reload. The existing mutation already invalidates `['gaps']`; the box's query must sit under that key so it is included.

Tests: the box lists a control's gaps and not another control's; a raised gap appears in the list without a refetch of the page; the button is absent when the assessment is implemented and present when it is partial; an empty box renders rather than nothing; the Assessment box no longer carries a Raise gap button; the panel's boxes render in the order above, with Frameworks last; the dialog opens with an empty Title and a disabled submit.
