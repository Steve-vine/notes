---
id: 01KZ0YT9PF6KBGDF4HWYZXZXGQ
created: 2026-08-02T10:02:52.495337Z
updated: 2026-08-02T14:13:48.99609Z
type: task
title: Per-repo tag editing (wire up the existing endpoint)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 476
sprint: s7j0986
assignee: steve
priority: low
task_status: todo
---
Small gap found while auditing how tag-less sources get tagged (2026-08-02).

Repos are registered by ticking a list and applying **one shared tag set to the whole selection**, and there is no per-repo tag edit in the UI — the row actions offer only Claims and Deregister. So giving one repo a different `app:` tag from the rest of its batch means re-registering the batch.

`PUT /api/v1/repos/{repo_id}` already exists and calls `set_tags`; nothing in the frontend calls it.

Compare Status Pages and Documents, which both have an Edit modal on the register card — this is the odd one out rather than a deliberate difference.

**Acceptance**: a registered repo's tags can be edited individually from the repo register card or its detail page, matching the Status Page / Document pattern.