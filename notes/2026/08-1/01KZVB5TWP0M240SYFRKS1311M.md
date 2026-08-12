---
id: 01KZVB5TWP0M240SYFRKS1311M
created: 2026-08-12T15:59:08.694209Z
updated: 2026-08-12T15:59:08.694209Z
type: task
title: Markdown auto-link mangles email addresses in copied commands
imported_from: linear
assignee: steve
label: chore
priority: low
task_status: backlog
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 98
---
Chat clients render `you@example.com` as `[you@example.com](mailto:you@example.com)`. When copy-pasted into a terminal as a CLI argument, the literal bracketed string is passed as the `--email` value, causing user-not-found errors on subsequent commands. Mitigation: always wrap email addresses in commands inside literal blocks. No code fix possible; this is a chat-rendering UX issue.

Source: Obsidian Issues Tracker #30 (P4 Low, Open).

---

Imported from Linear [DEV-31](https://linear.app/stevevine/issue/DEV-31/markdown-auto-link-mangles-email-addresses-in-copied-commands)