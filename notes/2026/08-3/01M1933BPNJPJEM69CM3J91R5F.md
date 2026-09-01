---
id: 01M1933BPNJPJEM69CM3J91R5F
created: 2026-08-30T10:23:02.869261Z
updated: 2026-09-01T13:55:51.971337Z
type: task
title: Assessing a control happens where you started — the control opens beside the queue
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 527
sprint: sz42uhw
comments:
- id: 01M199XJQG63W38ZEND74QJM2M
  author: Steve Vine
  at: 2026-08-30T12:22:13.485246Z
  text: |-
    Shipped — PR #535, merged to main as bbeb63d.

    The control opens beside the queue. `AssessmentPanel` is reused exactly as the Playbook control page uses it — a second copy is how the two would start disagreeing about what an assessment is — with a new context block carrying only the reference, title and what good looks like. Frameworks, linked content and decisions stay in Playbook, one click away; repeating them here would make this a second control page that drifts from the first.

    The queue keeps its filters, its scroll position and a mark on the row you are on. Previous/next step the **filtered** rows, and the panel says where you are in the run.

    The two inline dropdowns are gone, as decided — status through `StatusPill` with the colours it already had, maturity as a neutral pill, "Not assessed" in grey for a control with no assessment. The room goes back to the title column.

    `/assessments/:ref` gives the panel an address, so it is linkable and Back closes it rather than leaving the section — the behaviour the hand-off broke. A ref that is not in the filtered run (a stale link, or one the current filters exclude) leaves the queue readable with no panel rather than erroring.

    The old viewer test went with the dropdowns it described: nothing in the queue is editable now, by anyone. Five replace it, including prev/next with the ends disabled and Close returning to the queue.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Opening a control from Assessments hands you off to Playbook. You land on the control's library page, the sidebar switches section, and the way back reads "← Controls" — not back to the run you were part-way through. The domain and status filters you set, and your place in the list, are gone. Every control assessed costs a round trip and a re-filter.

Decided 2026-08-30: from Assessments, a control opens **in place**, in a panel beside the queue, so Assessments becomes what it is meant to be — a walk-through of the controls.

Mock-up (before / after): https://claude.ai/code/artifact/67e3db5d-0c39-423c-af94-982d7c0a9038

## What changes for the reader

Click a control in the queue and a panel opens on the right. It holds the whole assessment record — applicability and its justification, status, maturity, owner, evidence links, evidence files, notes, the review dates and the history — plus enough of the control to judge it: its reference, title, and what good looks like. Save and Raise gap stay pinned at the bottom while the form scrolls.

The queue stays on screen throughout, with its filters, its scroll position, and the row you are on marked.

**Previous / next step through the filtered list** from inside the panel, so you never return to the table between controls. The panel says where you are in the run — "4 of 8 · Identity & Access Management".

**Open in Playbook** is the deliberate way out to the library page — frameworks, linked policies and procedures, linked decisions. That material stays in Playbook; the panel does not repeat it.

## The queue reads, the panel edits

The two inline dropdowns come out of the list. Status and maturity stay, as **read-only pills in their own two columns** — so a run still reads at a glance as a column of colour, and you can see how far you have got without opening anything. Editing happens in the panel, in one place.

- Status takes the colours it already has in `statusColors.ts`, through `StatusPill`. A control with no assessment reads "Not assessed" in grey.
- Maturity is a neutral pill carrying the level; a dash where nothing has been assessed.

A pill is far narrower than the select it replaces, so the room goes back to the control's title, which is the column that was suffering.

## The panel has an address

The open control is in the URL, so a panel is linkable and the browser's back button closes it rather than leaving the section. That is what makes back behave the way people expect, which is the defect being fixed.

## What does not change

The Playbook control page keeps its "Assess for …" section — the same form, a second entry point. Its "← Controls" link is correct there, because that is where you came from.

## Notes

- `AssessmentsQueuePage.tsx` gains the panel and a routed child for the open control; `AssessmentPanel.tsx` is reused unchanged for the form itself. The control-context block (ref, title, "what good looks like") is new.
- The queue's two `Select`s become `StatusPill` (status) and a plain `Badge` (maturity) — `buildUpsert` stays, but the queue no longer calls the upsert mutation; the panel is the only writer.
- Prev/next steps the **filtered** row set the page already computes, not the unfiltered control library.
- Screen conventions apply (`brief/information-architecture.md`): no field or pill truncates — a column width is a minimum, not a cap. The narrowed layout must widen or scroll rather than clip a value.
