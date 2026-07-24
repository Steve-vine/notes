---
id: 01KXH1VZV34ZQA7XCBYG2YJRNJ
created: 2026-07-14T19:32:40.931231141Z
updated: 2026-07-24T12:49:43.175879Z
type: task
title: Estate-wide read-only assist tools + ADR 0023
project: 01KX671DATY39VW6GWK3M2T3DN
number: 63
sprint: syz8rn1
blocked_by:
- 01KXH1T5E9JTBHHW772V2HM6KF
- 01KXH1VEB2V61291GN26DC0QP5
assignee: steve
priority: high
task_status: done
---
**Every existing AI tool is single-system-scoped** — `ai/tools.py` raises "no system in scope" if `deps.system_id` is None. An estate-wide assist has no tool that works as-is.

## New tools (`ai/tools.py`), all taking explicit ids, all opening their own session

| Tool | Reads |
|---|---|
| `list_systems()` | `System` — the entry point |
| `get_system(system_id)` | one system + its state-slice names/summaries |
| `get_slice(system_id, slice)` | latest `StateSnapshot.payload`, through the existing `bound_payload()` |
| `list_findings(system_id=None, ...)` | open `Finding`s, estate-wide when `system_id` is None |
| `list_issues(system_id=None, ...)` | `Issue`s, estate-wide |
| `get_issue(issue_id)` | detail + evidence + linked `Finding` + latest `diagnose` outcome |
| `list_proposed_changes(system_id=None, status=None)` | lets assist say *"there's already an approved change for that"* |
| `search_audit(entity_type, entity_id)` | *"who approved that, and when"* |

Reuse `bound_payload()` — do not reimplement the 40k cap.

## ADR 0023 — the assist tool surface is read-only at the DATABASE boundary

Strengthens ADR 0017's containment. Every assist tool session issues `SET TRANSACTION READ ONLY`, so an assist tool **physically cannot write — enforced by Postgres**, not by an allow-list comment. This is meaningfully stronger than the comments currently guarding `READ_ONLY_TOOLS`/`DIAGNOSIS_TOOLS`/`PROPOSAL_TOOLS`.

The producer's own writes (`AgentRun`, messages) use a **different, normal** session — so the read-only constraint applies to exactly the tool surface and nothing else.

## The boundary must be assertable — three layers

1. **Structural:** `SET TRANSACTION READ ONLY` (above).
2. **`test_assist_tools_cannot_write`** — exercise each tool against a seeded DB, assert `db.new | db.dirty | db.deleted` is empty. Then assert a deliberately-writing **probe** tool *does* raise `ReadOnlySqlTransaction` — proving the guard is live and not silently absent. (A test that only checks "nothing was written" passes just as well when the guard was never installed.)
3. **`test_assist_allow_list_is_frozen`** — `{t.name for t in ASSIST_TOOLS} == EXPECTED`, and `get_action_catalogue not in ASSIST_TOOLS`.

**`get_action_catalogue` is NOT in the assist tool set, and no mutating tool exists to add.** Assist describes and suggests; the ui-brief is explicit that suggestions link into the proposal flow rather than acting.

Use `Tool(fn, sequential=True)` per ISE-60.

Blocked by: ISE-60, ISE-62.