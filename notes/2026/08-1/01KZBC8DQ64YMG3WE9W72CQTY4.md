---
id: 01KZBC8DQ64YMG3WE9W72CQTY4
created: 2026-08-06T11:10:11.174163Z
updated: 2026-08-06T14:34:44.023071Z
type: task
title: 'MCP: chronological recent-commits retrieval — "what changed in repo X since T" from RepoCommit, not gh'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 587
sprint: sp337by
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Found during ISE Test Plan execution (2026-08-06): asked over MCP what changed in a GitHub repo in the last 24h, Claude answered from the GitHub API directly (`gh`) because ISE offered no way to ask — leaving the check off the incident timeline.

The data is already in ISE (ISE-311 / ADR 0051): `RepoCommit` rows carry sha, message, author, `committed_at` and touched paths per default-branch commit of every registered repo, FTS-indexed — and the repo sweep already writes `push`/`release` events to the Events screen with no GitHub webhook. The gap is **retrieval shape on the MCP surface**: `search_repos` is relevance-ranked FTS with no time ordering; `list_events` only shows "N new commits" granularity; nothing answers "recent commits for repo X since T" chronologically. A textbook miss against the zero-cost-retrieval pillar — the facts are in the database but not reachable the way the question is asked.

Scope:
- Add a chronological read over `RepoCommit` to the MCP surface: either a `recent_commits` query (repo, since/from_hours, limit → sha, message, author, committed_at, touched paths) or since/order parameters on `search_repos`. Read-only, viewer role, session-required like the other reads — so the pull is recorded as `mcp_activity` on the incident.
- Return shape must be truncation-honest (shortlist + count) per the retrieval contract.
- Note the honest limits in the tool description: registered repos only, default branch only, freshness = `repo_sync_interval_hours`.
- Integration tests alongside `test_mcp_reads.py`; update the ISE Test Plan memo §11 (GitHub) with a checkbox for it.

Done when: from a pinned session, "what changed in repo X in the last 24 hours" is answered from ISE data with the query on the incident timeline, no `gh` fallback.