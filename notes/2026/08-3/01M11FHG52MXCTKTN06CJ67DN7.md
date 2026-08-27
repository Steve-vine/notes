---
id: 01M11FHG52MXCTKTN06CJ67DN7
created: 2026-08-27T11:26:33.634312Z
updated: 2026-08-27T11:26:37.274853Z
type: task
title: A section heading is not an unmapped requirement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 460
sprint: s8cjs5n
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: todo
---
Twenty-one rows in the library are section headings rather than requirements:
PCI's twelve numbered requirements (1–12) and ISO 42001's nine annex objectives
(A.2–A.10). No other framework has any. They already carry `assessable = false`,
and the backend treats them correctly everywhere — out of every coverage total,
filtered from the SoA, refused for applicability.

The screens have not caught up. On the Crosswalk tab a heading is a card like any
other, wearing an orange **Unmapped** badge, and it sits in the denominator. PCI
reads "313 of 325 requirements mapped" when the truth is 313 of 313 — every
assessable PCI requirement is mapped and there is not one real gap in the
standard. The "Only unmapped" filter is the tool you would reach for to find
gaps, and in PCI it returns twelve rows of noise and nothing else.

## What changes for the reader

**A grouping node reads as a heading, on all three tabs.** Its ref and title,
styled as the band it is, with the requirements it groups sitting beneath it. No
Unmapped badge, no "add control", no invitation to map something that can never
be mapped.

**Counts stop including them.** "313 of 313 requirements mapped" — the number is
about requirements, and a heading is not one. Same on the Requirements tab.

**"Only unmapped" shows only requirements that could be mapped and aren't.**
Across the whole library that is ten rows: six in ISO 42001 (waiting on the AI
Governance domain, COM-431), three in HIPAA, one in NIST CSF 2.0. That list is
worth acting on. The current one is not.

**Coverage keeps its rolled-up answer.** A heading there already reports the
cover and posture of everything beneath it, and that is genuinely useful — it is
the section summary. Style it as a heading; keep the values. This is the one tab
where "the same approach" means presentation only.

**Depth becomes visible.** The coverage table indents any row with a parent by
exactly one mark, so 1.2, 1.2.1 and 1.2.1.1 all sit at the same depth. PCI runs
five levels deep and is the first framework where that shows. Indent by actual
depth.

## Implementation

- `app/frontend/src/pages/FrameworkDetailPage.tsx` only. No API change, no data
  change, no migration — `assessable` is already on the requirement and already
  correct in every backend path (`coverage.py`, `soa.py`,
  `requirement_applicability.py`).
- Three places: the Crosswalk tab's flat card list, `RequirementsPanel`, and the
  coverage table's `requirementRow`. The latter two already badge "Grouping" —
  they need the visual treatment, not the logic.
- Library writers must still be able to edit a heading's title and description,
  so the Requirements tab keeps Edit and its actions, presented on a heading
  rather than a card.
- Watch the denominators: `mappedCount` and `requirements.length` on the
  Crosswalk tab both count every row today.

Tests: a grouping node renders no Unmapped badge and no add-control affordance;
the mapped count excludes grouping nodes; "Only unmapped" excludes them; a
three-level ref indents deeper than a two-level one.

Coordination: another session is tidying the frameworks. This touches one
frontend page and no framework data, so it should not collide — confirm before
opening the PR.
