---
id: 01M036ZYBNTQ0WQAK2J7HZHDAQ
created: 2026-08-15T17:19:56.789902Z
updated: 2026-08-15T17:19:56.789902Z
type: task
title: 'Incidents list: Status, Alert status and Source are truncated — they must read in full'
priority: medium
assignee: steve
label: bug
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 737
tech: null
---
On the incidents list the **Status**, **Alert status** and **Source** values are cut off, so adjacent columns read as one run of clipped text. These three carry the state of the incident and must always be legible in full. Reported 2026-08-15.

**Where it comes from.** The three columns are fixed-width — `w={130}`, `w={120}`, `w={120}` (`IssuesPage.tsx:538-546`) — and each renders a `StatusPill`, which is a Mantine `Badge` with no `tt` override (`components/StatusPill.tsx:7`). Badge uppercases its label by default and clips it rather than wrapping, so a value that does not fit is silently elided inside a column too narrow for it.

Longest rendered labels: **Acknowledged** and **Reactivated** for status, **Recovered** / **Recurring** for alert status, **Escalated** / **Promoted** for source — all uppercased, which is materially wider than the same text in sentence case.

**Scope**
- The three columns must show their full value at any sensible window width. Widening alone may be enough, but it competes with Title for room, so weigh it against the two cheaper levers below.
- **Drop the uppercase.** `tt="none"` costs nothing and reclaims a surprising amount of width — and other badges in the app already do this (the rollup badges in `ImpactPanel` and `MergePanel` both pass `tt="none"`), so `StatusPill` is the outlier, not the precedent.
- Check the change everywhere `StatusPill` is used, not just here — the incident header's state panel, the signals list and the dashboards all render it, and a shared component's restyle reaches every one of them.
- If a column still cannot fit its longest value, it should wrap rather than clip. A truncated status is worse than a two-line one: `Acknowledged` and `Acknowledged`-clipped-to-`Acknowl…` are distinguishable, but `Recovered` and `Recurring` clipped to eight characters are not — and those two mean opposite things.

**Verify in a browser, not vitest.** jsdom does no layout, so a truncation test asserts nothing — the text is present in the DOM whether or not it is visible. Check at a realistic window width, and at a narrow one. See [[ise-graph-canvas-measurement-trap]].