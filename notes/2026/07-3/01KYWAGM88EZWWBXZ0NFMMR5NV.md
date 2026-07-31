---
id: 01KYWAGM88EZWWBXZ0NFMMR5NV
created: 2026-07-31T14:51:06.37652Z
updated: 2026-07-31T14:52:25.524678Z
type: task
title: 'Docs: new section — Assist'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 434
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Write `src/content/docs/using-ise/assist.md`: the assist chat surface — what it is for, the kinds of question it answers well, streamed responses, and its deliberate boundaries (read-only tools; it observes and explains, it never mutates infrastructure — changes always go through a proposal). Cover the in-app issue chat as quick Q&amp;A versus the deeper Claude/MCP investigation surface for engineers, and global search / the command palette as the neighbouring way to find things.

Ground in ADRs 0022 (SSE streaming), 0023 (read-only tools), 0049 (chat investigation boundary), 0055 (Claude investigation surface). Operator audience, released capability only.

Depends on ISE-433 (sidebar group).