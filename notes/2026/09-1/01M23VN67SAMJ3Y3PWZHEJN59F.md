---
id: 01M23VN67SAMJ3Y3PWZHEJN59F
created: 2026-09-09T19:52:28.153907Z
updated: 2026-09-10T09:41:22.058557Z
type: task
title: A decision reads as D-12, the same shape as R-14 and G-7
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 644
sprint: sa2t9sq
blocked_by:
- 01M23VP2S7E9EPTV5YM8K5JT5J
assignee: steve
label:
- improvement
priority: low
task_status: active
---
Once risks and gaps carry `R-14` and `G-7`, a decision showing a bare `12` under an "ADR" heading is the odd one out. Same shape everywhere: `D-12`.

- `ref: str` on the decision's API schema, derived from `number` in one place (`f"D-{number}"`), beside `number` for sorting and addressing. The frontend never builds the string itself.
- **Decisions register** (`DecisionsPage.tsx`): the first column becomes `Ref`, showing `D-12`, still sorting numerically.
- **Decision detail**: the page header carries `D-12` before the title. The "supersedes" / "superseded by" lines and the new-decision dialog's supersedes picker show `D-3 — title`.
- **Wherever a decision is named elsewhere**: `LinkedDecisions` chips on controls and content, search results, activity summaries.
- **Search**: "D-12", "d12" and "12" all find it — the same prefix-stripping the risk/gap task adds, applied to the decision fuzzy search's number match.
- Addresses stay `/decisions/{number}`. Nothing about how a decision is created or numbered changes; this is presentation and search only.
- Uses the shared `RefText` from the risks-and-gaps task so the three read identically.

Tests: the register renders `D-12`; search by `D-12` returns the record.