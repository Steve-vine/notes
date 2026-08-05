---
id: 01KZ0YT9PF6KBGDF4HWYZXZXGQ
created: 2026-08-02T10:02:52.495337Z
updated: 2026-08-05T19:29:17.480368Z
type: task
title: Per-repo tag editing (wire up the existing endpoint)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 476
sprint: s7j0986
comments:
- id: 01KZ1EXWCKFN8R7RAA9P7XSVKR
  author: Steve Vine
  at: 2026-08-02T14:44:27.155728Z
  text: |-
    Built and up for review — PR #415 (feature/ise-476-per-repo-tag-edit), merged to staging. Frontend-only; no migration, no API change.

    - Edit action per repo row (operator+) opens the Status-Page-pattern modal (tags + description) calling the PUT /api/v1/repos/{repo_id} that existed with nothing calling it — one repo diverges from its batch's shared tag set without re-registering the lot. Saves invalidate the register queries so reach updates immediately.
    - 1 new component test driving the modal end-to-end (PUT body carries the diverged tag set); existing tests green.
assignee: steve
priority: low
task_status: done
---
Small gap found while auditing how tag-less sources get tagged (2026-08-02).

Repos are registered by ticking a list and applying **one shared tag set to the whole selection**, and there is no per-repo tag edit in the UI — the row actions offer only Claims and Deregister. So giving one repo a different `app:` tag from the rest of its batch means re-registering the batch.

`PUT /api/v1/repos/{repo_id}` already exists and calls `set_tags`; nothing in the frontend calls it.

Compare Status Pages and Documents, which both have an Edit modal on the register card — this is the odd one out rather than a deliberate difference.

**Acceptance**: a registered repo's tags can be edited individually from the repo register card or its detail page, matching the Status Page / Document pattern.