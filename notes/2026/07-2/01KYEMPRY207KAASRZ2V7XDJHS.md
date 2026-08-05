---
id: 01KYEMPRY207KAASRZ2V7XDJHS
created: 2026-07-26T07:19:51.490147Z
updated: 2026-08-05T11:55:25.484653Z
type: task
title: list_open_findings is unbounded — one call fed 424 findings (43k tokens) into a recheck
project: 01KX671DATY39VW6GWK3M2T3DN
number: 300
sprint: svgrad3
comments:
- id: 01KYEPN3X3PC7ER77E6H9XZ0YW
  author: Steve Vine
  at: 2026-07-26T07:53:54.339542Z
  text: |-
    Done — PR #268 (feature/ise-300-bound-findings-listing → main), CI running. Deploying to staging next to verify the acceptance on bb74cd9d.

    - list_open_findings now returns a bounded summary: total_open + by_severity + the 25 most-recent listed individually WITHOUT details. The 424-finding / 43k-token dump → ~small. get_issue_under_diagnosis still carries the one-under-investigation's detail.
    - bound_payload no longer no-ops on bare lists (the 'if not isinstance(dict)' short-circuit) — top-level lists are capped like a dict's list values. Audit: list_system_issues (limit 50) now also runs through bound_payload defensively; get_state_slices / evidence lists are small by nature.
    - Nice property: this bug was CAUGHT by ISE-295's partial breakdown (its first real catch) and confirmed by ISE-294's guard doing exactly its job — the sprint validating itself. Did NOT raise the 60k cap.
    - Tests: test_open_findings_bounded.py (424 → bounded, no details) + test_ai_tool_bounds.py (oversized bare list capped; small passes through) + diagnose/analyse regression. Backend ruff+mypy(321 fresh) green.

    Side note (not this task): 424 open findings on the DataDog system is worth signal-hygiene attention (ignore rules / severity overrides) separately.
- id: 01KYEQ9EBRBT8028ZVB9XENCXM
  author: Steve Vine
  at: 2026-07-26T08:05:00.408281Z
  text: |-
    ✅ Acceptance VERIFIED on staging (image staging-20260726-0801). Re-ran Analyse on bb74cd9d (finding still firing → hits the model path, exactly what was killed before):

    - STATUS: succeeded (was run_limit_exceeded)
    - FRESH tokens: 15,367 — well under the 60k cap (was 88,242)
    - list_open_findings tool result: 4,572 chars / ~1,143 est tokens (was 173,552 chars / ~43k) — the 424-finding dump is now a bounded summary
    - verdict: still_present (a real verdict)

    The 424 open findings still exist on that system, so the fix is doing exactly its job — bounded summary in, real answer out, no cap kill. Ready to merge on your word.
assignee: steve
priority: high
task_status: done
---
**Sprint 24, live-found (2026-07-26).** First analyse-issue after the batch (issue `bb74cd9d`) was killed `run_limit_exceeded` at **fresh=88,242 vs the 60k cap** — and the ISE-295 partial breakdown (its first real catch) shows exactly why: `list_open_findings` returned **173,552 chars (~43k tokens) in one call**. The DataDog system has **424 open findings** and the tool returns every one, with full `details`. The fresh-token guard (ISE-294) worked as designed — the run genuinely assembled ~88k fresh; cache was cold (2.5k read) only because the run died on hop ~2. The cap is not the problem; the haystack is. Do NOT raise 60k.

Two defects:
1. **`list_open_findings` (`ai/tools.py`) has no limit and serialises full `details` per row.** Assist's `list_findings` (assist_tools.py) is the pattern to follow: capped limit, recency-first, **no details in the listing**. For the single-shot set: cap the list (recency-first, truncation-honest note), trim or drop `details` (or top-N with details + summary counts by severity/kind for the rest — "424 open: 12 high, 380 medium…" is the fact a recheck needs, not 424 payloads).
2. **`bound_payload` no-ops on non-dict payloads** (`if not isinstance(payload, dict): return payload, None`) — any tool returning a bare list bypasses the 40k-char cap entirely. Fix bound_payload to bound top-level lists too, and audit the other bare-list returns in tools.py (`get_state_slices`, `list_system_issues`, evidence source lists) for the same bypass.

Retrieval-layer lens (ADR 0050): "what's open right now?" answered as a full dump is the raw-pile anti-pattern; the bounded summary + drill-down is the contract. Consider (separately) exposing `search_signals` (ISE-289) to the single-shot DIAGNOSIS_TOOLS as the drill-down.

Side observation, not this task: 424 open findings on the DataDog system may itself warrant signal-hygiene attention (ignore rules / severity overrides).

Acceptance: re-run Analyse on issue `bb74cd9d` — completes within the 60k cap, with the breakdown showing a bounded findings result.