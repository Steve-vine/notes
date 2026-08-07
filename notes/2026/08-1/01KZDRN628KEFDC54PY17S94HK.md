---
id: 01KZDRN628KEFDC54PY17S94HK
created: 2026-08-07T09:25:21.096317Z
updated: 2026-08-07T10:09:30.780502Z
type: task
title: '"Ask Assist" contextual entry points — start a thread about this entity/system/incident'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 601
sprint: snk16ew
assignee: steve
label: null
priority: medium
task_status: backlog
---
Assist always starts cold: `AssistStore.system_id`/`issue_id`/`context` all return `None`, and no screen links into it. "What about *this* thing" should not require re-describing the thing.

- "Ask Assist" action on entity detail, system detail, and incident screens → opens `/assist` with a new thread bound to that subject.
- Thread carries the subject as context: the store's existing hooks get populated so the first turn's preamble includes the subject's investigation context (mirror issue-chat's preamble mechanism); subject shown as a chip on the thread header.
- Deep-linkable: `/assist?entity=…` (or equivalent) so links can be shared/bookmarked.
- Subject-bound threads remain read-only Assist threads — context changes what the agent sees first, never what it can do.

Screens: entity/system/incident pages gain the action; AssistPage renders the subject chip.