---
id: 01M23RHPNTNY1ZNJCMPCF9XB7D
created: 2026-09-09T18:58:08.186935Z
updated: 2026-09-09T18:58:44.175461Z
type: task
title: 'Posture ▸ Timeline — the page: six measures over time, with annotations'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 639
sprint: srtvjyn
blocked_by:
- 01M23RH9QVN7FPV7K03WVV6V69
assignee: steve
label:
- feature
priority: high
task_status: backlog
---
The screen. **Posture ▸ Timeline**, `/timeline`, read-only, for anyone who can see the Dashboard. It answers one question the Dashboard cannot: are we getting better?

**Layout** (screen conventions in `brief/information-architecture.md` first):

- Page header "Timeline", the company from the switcher, a **period picker** in the header row: 90 days · 12 months · All time. Grain follows the period (week / month / month).
- **Headline**: compliance % as one line, with the three tier lines beneath it in the same chart (Essential, Expected, Specialised — tier pill colours). This is the chart people will screenshot for a board.
- Then a grid of cards, one per measure: **Open gaps** (open and overdue, two lines), **Maturity** (average, with a per-domain sparkline row under it — small multiples, not a legend of twenty lines), **Frameworks** (one line per framework the company holds a scope statement for, others behind a "show all"), **Risks** (over appetite as a line; residual bands stacked beneath).
- **Annotations** as vertical markers with the event label on hover; a legend row lists them in date order under the headline chart.
- **Reconstructed** days shaded, with one line of explanation ("Points before 10 Sep 2026 are reconstructed from the change history"). Honest, once, not a warning banner.
- Empty state for a company with no rows yet: say the first point arrives tonight.

**Mechanics:**

- Adopt `@mantine/charts` (ADR 0070). Pin the version; theme colours from the Appearance palette so light/dark and the tuned pill colours carry through.
- `useTimeline(company, period)` React Query hook keyed on both; the company switch refetches like the Dashboard.
- Nav: `Timeline` joins the Posture section in `components/nav.ts`, after Risks, before Decisions; route in `App.tsx` beside `dashboard`.
- Tests: renders the six cards from a fixture series; period picker changes the query key; empty state.

Not in this task: authored notes on the timeline (next task), export, and a "vs last month" delta on the Dashboard tiles (follow-up).