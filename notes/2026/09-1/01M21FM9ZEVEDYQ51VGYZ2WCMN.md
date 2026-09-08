---
id: 01M21FM9ZEVEDYQ51VGYZ2WCMN
created: 2026-09-08T21:43:47.43836Z
updated: 2026-09-08T21:56:46.763603Z
type: task
title: 'Assessments queue: plain rows, no alternate shading — a trial before the rest follow'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 630
sprint: sa2t9sq
assignee: steve
label:
- improvement
priority: low
task_status: active
---
Asked for by Steve while smoke-testing, 2026-09-08: *"I'm finding the alternate coloured rows on lists a little hard on the eye."*

**Change.** On the **Assessments** page only, the rows lose their alternating background shading. The thin line between rows stays, the hover highlight stays, and the selected row (the one whose panel is open) still stands out as it does now. Every other list in Compass is unchanged.

**Why only here.** It is a trial: Steve wants to see how one busy list reads without stripes before deciding for the rest. If it reads better, a follow-up task turns the shading off everywhere in one place — the app-wide table defaults — and removes this page's exception at the same time. If not, this task is reverted and nothing else moved.

---

*Implementation notes.* Striping comes from two places: the app-wide default in `theme.ts:191` (`Table.extend({ defaultProps: { striped: 'odd', … } })`) **and** an explicit `striped` on the Assessments queue's table at `AssessmentsQueuePage.tsx:274`. Change that one line to `striped={false}` — the explicit prop beats the theme default. Leave `highlightOnHover` and `stickyHeader`; `withRowBorders` is Mantine's default `true`, so the horizontal rules stay without being named. Check the `DomainHeadingRow` and the `selectedRowStyle` still read against a flat background (the selected-row colour was chosen against stripes). Do **not** touch `theme.ts` — that is the follow-up, if the trial is adopted. One-line change; the page test needs no update unless it asserts on the striped class.