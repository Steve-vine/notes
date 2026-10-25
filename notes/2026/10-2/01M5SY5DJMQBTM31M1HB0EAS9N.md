---
id: 01M5SY5DJMQBTM31M1HB0EAS9N
created: 2026-10-25T16:26:40.084932Z
updated: 2026-10-25T16:26:43.254509Z
type: task
title: A DDQ's History card starts folded — a heading with a count, opened with a click
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1312
sprint: ssgnel8
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Smoke test of sprint 86 round 2 (DDQ-5 on staging, 2026-10-25). Found by Steve: "The History section gets very big, collapse this by default."

**Chain:** independent (frontend only).

## What's wrong

The **History** card at the foot of a DDQ's page lists every change to the DDQ and its files, and it is always open. On a working DDQ that is many rows. On DDQ-5 that came from 31 questions, each set up, drafted, assigned, submitted and approved. It pushes everything else up and makes the page very long.

## What people see after the fix

- The History card starts **folded**: just its heading, a chevron and how many entries it holds ("History 148").
- A click opens it and shows the trail as it is today, newest first. Another click folds it again.
- It starts folded every time the page opens. It doesn't remember being opened.
- Unchanged: who can see it and what it lists.
- The question window's own History (versions of one answer) already starts folded, so it doesn't change.

## Notes (technical)

- `ddq/requests/cards.tsx` ~282, `DdqHistoryCard`: `<Panel title="History">` around `<AuditTrailTable>`.
  - Wrap the table in the kit's folding `Section` (`components/kit/Section.tsx`, `defaultOpen={false}`, `count={history.length}`), inside the Panel or in place of its title, whichever matches the page's other cards.
  - Or give `Panel` a collapsible option, if the shared CollapsedList from COM-1304/1305 lands first.
- Optionally load the history only when it's opened (`useDdqHistory(ddq.id, open)`). The count would then need the summary, so keep the eager fetch unless it's slow.
- Test: vitest on DdqRequestPage. History is folded by default, and the rows show after a click.
- Out of scope: the same History or Audit trail cards on Incidents, Data Privacy, SAP entries, Q&A entries and Risk Assessments (all `AuditTrailTable`). Say if they should fold the same way.
