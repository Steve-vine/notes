---
id: 01M1YQ9HPHK8C1QK2GFV1CYVBM
created: 2026-09-07T20:00:00.209725Z
updated: 2026-09-07T22:02:32.03876Z
type: task
title: 'Every list sorts: the shared sort and the convention'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 608
sprint: sa2t9sq
comments:
- id: 01M1YY9X76KR60REDGN7TGVR6H
  author: Steve Vine
  at: 2026-09-07T22:02:32.038397Z
  text: |-
    Done — PR #618 merged to main (09045ff).

    What landed:
    - components/sort.ts: useClientSort / sortRows beside the server-side SortState pair. Per-column accessor + kind (text | number | date | rank); rank takes an explicit order array so pills sort by meaning. Blank last in both directions; text is case-insensitive, locale-aware and numeric-aware (AC.10 after AC.9); `within` keeps a grouped table's groups intact. SortableTh unchanged.
    - brief/information-architecture.md → Screen conventions → "Every list sorts": the rule, in the voice of the sections already there.
    - pages/ControlsPage.tsx is the worked example (ref/title as text, tier and status by rank, sorted within each domain block). library/tiers.ts exports TIER_ORDER; library/status.ts holds LIBRARY_STATUS_ORDER.

    Tests: components/sort.test.ts (each kind, blank-last both ways, unknown rank values, within-group, unknown column, toggle cycle); ControlsPage.test.tsx (click reorders within block, second click reverses, aria-sort, numeric-aware ref, tier by rank).

    Staging deploy follows once the sprint's other tasks are in review.
assignee: steve
label:
- brief
priority: high
task_status: active
---
Every table in Compass can be reordered by clicking a column heading. The treatment already exists on the Access Control directory tabs (COM-272 — `components/SortableTh.tsx`, `components/sort.ts`); this task makes it usable everywhere and writes the rule down, so the rest of the sprint is a sweep rather than fifty separate decisions.

## What a reader sees

Every column showing a value you could line rows up by carries the sort chevron. Click: ascending. Click again: descending. Click a different column: that one starts ascending. There is no third click and no "unsorted" state — the table opens in its natural order and stays sorted once you touch it. The sort is forgotten when you leave the page, which is what the directory tabs already do.

## Decided

- **Client-side by default.** Nearly every list endpoint returns the whole list, so the browser already holds every row; sorting it is instant and costs no backend work. The few lists that page on the server sort on the server — see *Sorting the long lists* — because a sort must reorder the whole list, never just the page you happen to be looking at.
- **A pill sorts by its meaning, not its spelling.** Severity runs Critical → Low, maturity 0 → 5, a status follows its lifecycle. Alphabetical on a pill column is a defect, not a shortcut.
- **Blank sorts last** in both directions. An absent owner or a missing due date is not "before A".
- **Columns of buttons and icons do not sort** — consistent with *Row actions live in their own column*.
- **What counts as a list**: a table listing many rows of the same kind. A two-column facts panel on a detail page is not a list and gets nothing.
- Text compares case-insensitively and locale-aware; numbers as numbers, dates as dates — never as strings.

## Work

- `components/sort.ts` gains a client-side hook beside today's server-side `SortState`/`toggleSort`: given rows and a per-column accessor plus kind (`text` | `number` | `date` | `rank`), it returns the sorted rows and the click handler. `rank` takes an explicit order array — that is how pills get their meaning.
- `SortableTh` keeps its current API unchanged; it already renders the chevron and `aria-sort`, and the sweep tasks reuse it as-is.
- The rule goes into `brief/information-architecture.md` → *Screen conventions* as its own section, in the voice of the sections already there.
- One worked example (Controls) lands in this task so the sweeps have something to copy. Everything else follows in the per-section tasks.
