---
id: 01M1CKFCA17EFKWMDVVGQZ17SS
created: 2026-08-31T19:06:57.217943Z
updated: 2026-08-31T19:06:57.217943Z
type: task
title: A disabled integration must be silent
label: bug
priority: high
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 754
tech: null
---
Disabling an integration is meant to stop it doing anything. It doesn't stop everything.

**Evidence (staging, 2026-08-31).** All 21 real integrations were disabled on 2026-08-20 21:29 (`audit_event`, action `updated`, details `{"enabled": false}`). Every task type stopped that night except one: `summarise-repo-file` has run **6,525 times since**, ~600/day, and was still running 11 days later. Those runs carry `agent_run.system_id = NULL`, so they aren't attributed to any integration and appear nowhere as that integration's activity.

**Root cause.** The `enabled` guard lives in `repos.sync_repo` (`repos.py:405` — "source disabled"), which covers the fetch path only. `tasks/repos.py::_drain_file_summaries` (line 187) selects `RepoFile` rows purely by `summary == '' AND content != ''`, with no join back to `Repo → System`, so the guard never applies to it. The sweep keeps calling the model against files belonging to a switched-off integration.

**The general question, not just this one path.** `_drain_file_summaries` is the instance the data exposed; the task is to establish that *disabled means silent* as a property. Audit every scheduled/dispatched path that can reach a connector, a credential or the AI engine on behalf of a System, and confirm each one honours `enabled`. Anything working from a derived table (`repo_file`, `repo`, entity-derived work) is the risk shape — the guard sits on the parent and the query starts at the child.

**Also worth deciding:** work done for a System should carry `agent_run.system_id`, so "which integration is this spend for" is answerable and this class of leak is visible on the Agent runs screen rather than needing a SQL query.

**Done when** disabling an integration provably stops all work on its behalf — a test that disables a System with pending derived work and asserts zero agent runs and zero connector calls follow — and existing paths are audited against that rule.