---
id: 01M78ND8WKS99C99RSQNE3QWC9
created: 2026-11-12T19:57:58.547237Z
updated: 2026-11-12T21:51:53.801653Z
type: task
title: 'The vulnerability Register reads by issue: grouped by default and remembered, each issue row shows its progress and expands to its systems like the software register, with actions on the whole issue'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1778
sprint: spsp226
comments:
- id: 01M78VXSEWFJ21R8K08YPDPKGZ
  author: Steve Vine
  at: 2026-11-12T21:51:51.260481Z
  text: |-
    Built — PR #1767 (auto-merge set; no migration, no API change).

    - The Register opens grouped by issue; turning it off/on is remembered in this browser (if site data is blocked it still opens grouped and the choice lasts the visit). A ?issue= link still opens the plain list on that issue.
    - Issue row: CVE · title (or title) with "N systems" under it, Worst severity, Open ("2 of 3"), Overdue (warning colour when > 0), Owner (name, "Several" or "Unassigned"), Fix by (earliest open), Source ("Pen test: Example Security, 12 Sep 2026", "Nessus" or "Several"). Every column sorts; default worst severity, then most open. No asset pills.
    - Opening a row (caret or click) keeps the grouped view and lists one line per system: system (linked), reference (linked), state, severity when different, owner, fix-by, Overdue mark; fixed/closed after open ones, faded. Several can be open.
    - On an opened issue: Mark fixed on all open…, Assign all open…, Comment on all… — each the existing bulk change with its preview first. Accept stays one at a time. The row checkbox still selects the whole issue for the bulk bar.
    - At 390px only Issue and Worst severity stay as columns; the other figures fold under the title, no sideways scroll.
    - CSV export stays one line per vulnerability.
    - Hand-record bug fixed: recording by hand on several systems with no CVE now gives one shared issue key; old records untouched.
    - Polaris: vulnerabilities_list grouped=true returns one entry per issue with the same figures.

    Things to know:
    - When grouped, the State filter chooses which issues appear (any vulnerability in that state); the other filters decide what each issue counts. That's what lets "2 of 3, fixed one last and faded" show under the default Open filter.
    - The pen-test source date is the vulnerability's first-seen date (the day testing finished) with the tester's name.
    - The count line reads e.g. "4 issues · 7 shown". The old ?group=1 address flag is gone.
    - Company-wide line inside an issue comes with COM-1776.

    Checks: ruff, mypy, unit suite (2194), integration tests for the hand-record key and Polaris grouped; eslint/tsc/prettier; RegisterTab tests (14, 8 new). Full vitest: 6 load-related failures in untouched files that pass alone. Looked at desktop and 390px, light and dark, in a browser harness.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
## Why

Steve, testing on 2026-11-12: "When vulnerabilities are created from a pen test … a vulnerability affecting multiple assets is created as multiple vulnerabilities, one for each asset resulting in a long list. It would be easier to read if the list was of unique vulnerabilities with associated assets, similar to how the software assets register works."

**Keep one vulnerability per system underneath** (ADR 0129 §1). Each system's fix is tracked on its own: its owner, its state (fixed on one server, open on another) and a scanner's confirmation. What changes is how the list reads.

The Register already has a **Group by issue** switch (`RegisterTab.tsx`, `groupByIssue` in `register.ts`). It falls short in four ways:
1. It's off by default and kept only in the address, so every visit lands on the long list.
2. A row shows only Issue, Worst severity and a count of systems. It says nothing about progress: open vs total, overdue, owner, fix-by.
3. Clicking a row leaves the grouped view and filters the flat list to that issue. It doesn't open in place the way the software register's rows do (`inventory/SoftwareOnAssets.tsx`).
4. **Bug:** a vulnerability recorded by hand on several systems with no CVE gets a fresh issue key per system (`core/vulnerabilities/record.py`: `issue_key=key if cves else issue_key([])` inside the per-system loop). The copies never group. Pen-test findings group correctly (`pentest:<finding id>`), and so do CVEs.

Steve's call (2026-11-12): **no asset pills on the issue row**. Expanding the row, as the software register does, is enough.

## What the person sees

**Grouped by default, and remembered**
- The Register opens **grouped by issue**.
- Turning the switch off (or on) is remembered for that person in this browser. Every filter still applies to both views.
- A link with `?issue=` still opens the flat list filtered to that issue, as now.

**The issue row** (one per issue):
- **Issue**: the CVE and title, or the title.
- **Worst severity**.
- **Open**: "3 of 5", the open vulnerabilities out of all on the issue that the filters show.
- **Overdue**: a count, in warning colour when more than 0.
- **Owner**: the name when every open one has the same owner, otherwise "Several".
- **Fix by**: the earliest fix-by date among the open ones.
- **Source**: e.g. "Pen test: Example Security, 12 Sep 2026" or "Nessus", or "Several".
- Sortable on every column. Default sort is worst severity, then most open.

**Expanding a row** (chevron, or click anywhere on the row), as the software register does:
- One line per system: the system (linked to the asset), the vulnerability's reference (linked to its page), state, severity (when it differs from the issue's worst), owner, fix-by, overdue mark.
- Fixed and closed ones are listed after the open ones and faded.
- Several rows can be open at once. Opening a row doesn't leave the grouped view.

**Acting on the whole issue** (for people who can work vulnerabilities):
- An expanded issue offers **Mark fixed on all open…**, **Assign all open…** and **Comment on all…**. These use the existing bulk actions, with the preview first, as the bulk bar does now. Accept stays one at a time with its sign-off (ADR 0129 §5).
- The issue row's checkbox still chooses all of its vulnerabilities for the bulk bar.

**Fix the hand-record bug**
- Recording by hand on several systems with no CVE gives every copy **one** shared issue key, so they group.
- Existing hand records made before the fix stay as they are. No guesswork merging.

**Elsewhere**
- Company-wide vulnerabilities (COM-1776), when built, appear as their own line "Company-wide" inside the issue.
- Export (CSV) keeps one line per vulnerability, as now, whichever view is showing.

## Notes for the build

- **Independent**: the grouping is built in the browser from the register it already reads whole. The hand-record fix is one line in `record.py` (make the key once, before the loop). There's no migration and no API change.
- Remember the toggle in browser storage, wrapped so it works when storage is blocked.
- Screen conventions: SortableTh on every column, pills never truncated (`brief/information-architecture.md`). Check 390px width: the row's extra columns fold under the title on narrow screens.
- Polaris already has `vulnerabilities_where_is_issue`. Have `vulnerabilities_list` gain `grouped=true`, returning the same per-issue figures (open/total, overdue, owner, fix-by), so "what's open from the pen test, by issue" reads the same in chat.

## Done when

On staging, in E2E Test Company:
- The Register opens grouped. Turning it off and reloading keeps it off, and turning it back on keeps it on.
- A pen-test finding on three systems, one marked fixed, reads as one row with "2 of 3" open, its overdue count, owner (or "Several"), the earliest fix-by and the report as source.
- Expanding the row lists the three systems with reference, state, owner and fix-by, the fixed one last and faded, without leaving the grouped view.
- **Assign all open…** on that issue assigns the two open ones after the preview, and **Comment on all…** puts the comment on all three.
- A vulnerability recorded by hand on two systems with no CVE now shows as one issue with 2 systems.
- Filters (severity, system, owner, overdue, search) narrow both the issue rows and their counts.
- Via Polaris: "list the open vulnerabilities grouped by issue" returns one entry per issue with the same figures.