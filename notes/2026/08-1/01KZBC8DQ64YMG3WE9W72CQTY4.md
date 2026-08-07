---
id: 01KZBC8DQ64YMG3WE9W72CQTY4
created: 2026-08-06T11:10:11.174163Z
updated: 2026-08-07T09:40:57.313577Z
type: task
title: 'MCP: chronological recent-commits retrieval — "what changed in repo X since T" from RepoCommit, not gh'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 587
sprint: sp337by
comments:
- id: 01KZBSDD50KX27JZ4CNS0HX7TQ
  author: Steve Vine
  at: 2026-08-06T15:00:05.920236Z
  text: |-
    Built — PR #503 (branch feature/ise-587-mcp-recent-commits).

    `recent_commits` is registered (viewer, session-required, read): newest-first over a time window, optionally scoped to one repo named by id, `owner/name`, or a unique substring. Ambiguity refuses rather than guessing — answering "what changed" about the wrong repo is worse than not answering at all.

    The satisfying part is how little new code it needed. `retrieval.search_commit_history` already falls back to recency ordering when the query has no lexemes, so passing an empty query gives exactly the chronological read that was missing, and the 25-row ceiling and truncation-honest shape come from the existing retrieval contract rather than a second implementation of both. The diagnosis in the task was right: the facts were in the database, only the retrieval shape was absent.

    The answer carries its own limits — registered repos only, default branch only, and the install's real `repo_sync_interval_hours` — so a stale window is never read as "nothing changed". That felt more useful than putting the caveat only in the tool description, where it is read once and forgotten.

    Session-required like the other reads, so the pull lands as `mcp_activity` on the incident timeline, which was the actual point: the check belongs on the ticket, not in a `gh` call nobody can see.

    Tests in `test_mcp_reads.py` cover chronology, the window as a real filter, both name forms, declared truncation, and the two refusals. ruff + mypy strict clean; the module's 9 integration tests green.

    ISE Test Plan memo: §11 checkbox to be added in one batched edit with ISE-589 and ISE-590 at the end of the sprint, rather than rewriting the whole memo body three times.
assignee: steve
label: null
priority: medium
task_status: done
---
Found during ISE Test Plan execution (2026-08-06): asked over MCP what changed in a GitHub repo in the last 24h, Claude answered from the GitHub API directly (`gh`) because ISE offered no way to ask — leaving the check off the incident timeline.

The data is already in ISE (ISE-311 / ADR 0051): `RepoCommit` rows carry sha, message, author, `committed_at` and touched paths per default-branch commit of every registered repo, FTS-indexed — and the repo sweep already writes `push`/`release` events to the Events screen with no GitHub webhook. The gap is **retrieval shape on the MCP surface**: `search_repos` is relevance-ranked FTS with no time ordering; `list_events` only shows "N new commits" granularity; nothing answers "recent commits for repo X since T" chronologically. A textbook miss against the zero-cost-retrieval pillar — the facts are in the database but not reachable the way the question is asked.

Scope:
- Add a chronological read over `RepoCommit` to the MCP surface: either a `recent_commits` query (repo, since/from_hours, limit → sha, message, author, committed_at, touched paths) or since/order parameters on `search_repos`. Read-only, viewer role, session-required like the other reads — so the pull is recorded as `mcp_activity` on the incident.
- Return shape must be truncation-honest (shortlist + count) per the retrieval contract.
- Note the honest limits in the tool description: registered repos only, default branch only, freshness = `repo_sync_interval_hours`.
- Integration tests alongside `test_mcp_reads.py`; update the ISE Test Plan memo §11 (GitHub) with a checkbox for it.

Done when: from a pinned session, "what changed in repo X in the last 24 hours" is answered from ISE data with the query on the incident timeline, no `gh` fallback.