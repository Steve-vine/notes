---
id: 01M036ZYBNTQ0WQAK2J7HZHDAQ
created: 2026-08-15T17:19:56.789902Z
updated: 2026-08-16T09:49:08.392522Z
type: task
title: 'Incidents list: Status, Alert status and Source are truncated — they must read in full'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 737
sprint: sevhjex
comments:
- id: 01M03A81GEQD0PNFSRXVN2F6YW
  author: Steve Vine
  at: 2026-08-15T18:16:47.886134Z
  text: |-
    Built and merged as PR #687 (main fa96a4a2).

    Verified in a browser, not vitest, exactly as the task said — a dockerised playwright rig over a Vite harness mounting the real Incidents page, at 1600 / 1280 / 1024 in both themes. The numbers before the fix:

    - 1600: "Recovered 6h ago" clipped
    - 1280: FIVE values clipped across all three columns — Reactivated, Recovered 6h ago, Escalated, Promoted, Dismissed
    - 1024: ten clipped, including Active, Firing, Silenced, Manual

    So this was worse than "at a narrow window": the everyday value in Alert status was being elided at a full desktop width.

    After: nothing clips at any of the three widths, in either theme. Only "Recovered 6h ago" wraps, and only below 1600.

    Both cheap levers taken, in the order the task set out. `tt="none"` — StatusPill was indeed the outlier, ImpactPanel and MergePanel already passed it. Wrapping instead of clipping needs three overrides together (`h="auto"` plus `white-space: normal` and `overflow: visible` on the label), because Badge pins its height AND truncates its label. Sized so a one-line pill keeps the 20px capsule it always had.

    **One consequence the task did not anticipate.** Dropping the uppercase means the label carries its own casing — the pill had been leaning on CSS to make raw wire values like `critical` and `run_limit_exceeded` look deliberate, and without it they read as lowercase fragments. Added `statusTitle` for the raw fallback only; a caller passing an explicit `label` is untouched, since it has already been written the way it should read.

    Only Alert status is widened (120→150). Status and Source hold their longest values as they are once the pill is sentence case, so Title keeps the room.

    The shared-component blast radius showed itself as promised: six vitest assertions on the old lowercase text across four files failed, one of them ("Failed") because the capitalised pill now collides with a filter option's label and needed scoping to its row. The design-system brief carries the rule, and the note that a column of pills can never be verified in jsdom.
assignee: steve
label:
- bug
priority: medium
task_status: done
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