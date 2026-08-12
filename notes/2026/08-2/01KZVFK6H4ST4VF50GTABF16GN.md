---
id: 01KZVFK6H4ST4VF50GTABF16GN
created: 2026-08-12T17:16:20.900877Z
updated: 2026-08-12T17:18:30.508769Z
type: task
title: 'Workflow: async batched mode + source-of-truth + state reduction'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 331
assignee: steve
imported_from: linear
label: null
priority: medium
task_status: done
---
Refactor `docs/workflow.md` to support async batched Claude Code execution between Steve sessions.

**Motivation**

Today's per-issue synchronous flow has Steve gating every implementation step (live-watching Code, reviewing every PR, running every smoke). With \~2h of attention per day and \~1 issue/h throughput, the per-issue gates are the bottleneck — not Code, not chat-Claude. Goal is to move Steve to a management-by-exception model: chat-Cl…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-279](https://linear.app/stevevine/issue/DEV-279/workflow-async-batched-mode-source-of-truth-state-reduction)