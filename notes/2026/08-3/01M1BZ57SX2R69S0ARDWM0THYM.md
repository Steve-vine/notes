---
id: 01M1BZ57SX2R69S0ARDWM0THYM
created: 2026-08-31T13:11:53.405583Z
updated: 2026-08-31T14:55:11.387256Z
type: task
title: The assessment panel shows the control's frameworks, linked content and decisions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 552
sprint: s2fcksg
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: active
---
Assessing a control means judging whether it is in place — and the evidence for that judgement is the policy it comes from, the frameworks that demand it, and the decisions taken about it. Today the panel beside the queue carries only the reference, the title and what good looks like; the other three sections live on the control's Playbook page, one click and a lost place in the queue away. Add them to the panel.

**Expected** — under the assessment form: **Frameworks** (the requirements this control answers), **Linked content** (the policies, standards and procedures it comes from), **Decisions** (what has been decided about it). The same three sections, saying the same things, as the control's page in Playbook.

**This reverses a deliberate choice, and that is fine — but knowingly.** COM-527 split them out on purpose: the panel was to carry "only enough of the control to judge it", with everything else staying in Playbook so this did not become a second control page drifting from the first. That risk is real and the fix for it is not to leave the sections out, it is to **share the components**: extract `FrameworksCard` and `LinkedContentCard` from `ControlDetailPage` into shared components and use them in both places, as `LinkedDecisions` already is. Two entry points, one rendering — the same discipline `AssessmentPanel` itself already follows. If it is copied instead of shared, this task has made the problem COM-527 was avoiding.

**Implementation**
- `pages/AssessmentsQueuePage.tsx` `ControlAssessmentPanel`: its rewritten doc comment currently states the omission is deliberate. Rewrite it — code that argues against what it does is worse than no comment.
- The panel holds the list-shaped control, which has no requirements or content on it. Fetch the control detail when a control is opened, keyed by ref so React Query caches it across next/previous and back again.
- The three sections go **below** the form: the assessment is the work, and it stays at the top where the eye lands. The panel already scrolls independently (COM-539), so length costs nothing but scrolling.
- Extract the two cards out of `ControlDetailPage` and use them in both; that page should end up shorter, not longer.
- Tests: the sections render in the panel with the same content as the control page; an empty section reads as empty rather than vanishing; stepping to the next control replaces them rather than showing the previous control's.

**If the panel feels long once it is on screen**, the answer is collapsing the three sections with the frameworks open by default — not dropping one of them again. Worth a look during smoke testing.
