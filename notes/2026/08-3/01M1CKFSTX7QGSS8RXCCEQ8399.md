---
id: 01M1CKFSTX7QGSS8RXCCEQ8399
created: 2026-08-31T19:07:11.069186Z
updated: 2026-08-31T19:07:11.069186Z
type: task
title: A repo file summary is computed, then thrown away
assignee: steve
priority: high
task_status: backlog
label: bug
project: 01KX671DATY39VW6GWK3M2T3DN
number: 755
tech: null
---
The repo-file summarisation loop never finishes, because it never saves its work. It has been re-summarising the same 35 files forever.

**Evidence (staging, 2026-08-31).** All 35 rows in `repo_file` have `summary = ''`, and `repo_file.updated_at` has not moved since 2026-08-18 — yet `summarise-repo-file` has 15,646 agent runs, ~600/day, and the recent ones **succeed** and return good summaries in `agent_run.outcome`. The output is correct and is discarded every time. Total spend on this task type to date: $29.84, still accruing at roughly $1.15/day on a staging environment with every integration switched off.

**Root cause.** `tasks/repos.py::_drain_file_summaries` (line 187) opens `with _session() as db:` per file and calls `repos.summarise_repo_file`, which sets `repo_file.summary` and calls `db.flush()` — but nothing ever commits. `_session()` (`sync.py`) returns a plain `Session`; its context-manager exit closes and therefore **rolls back**. The sibling `_extract_changed` in the same module does call `db.commit()`, so this is an omission rather than a pattern.

The result is self-sustaining: the file stays in the pending set (`summary == ''`), so the next sweep picks it up again, succeeds again, and discards again — permanently, at a fixed budget per tick.

**Fix** is a commit in the right place, but the interesting part is the guard: this ran for weeks producing a perfect success rate in `agent_run` while achieving nothing, and nothing surfaced it. Consider whether a drain that never drains — pending set not shrinking across N ticks — is an Observation the platform should raise about itself (ADR 0091). Related: ADR 0051 §2/§3's two-commit rule is what this code was meant to implement.

**Done when** a summarised file persists its summary and leaves the pending set, a test asserts the row is committed (not just flushed), and a repeatedly-failing or repeatedly-empty summary cannot loop indefinitely.