---
id: 01KZVB2GTR18SGCMNQ60BJ618D
created: 2026-08-12T15:57:20.088362Z
updated: 2026-08-12T15:58:29.305712Z
type: task
title: Add explicit timing-leak assertion for login flow
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 95
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- follow_up
- tech_debt
priority: low
task_status: backlog
---
Relied on `DUMMY_HASH` to keep timings consistent for unknown-user vs known-user-wrong-password, but no explicit timing test (flaky on shared runners, not worth chasing without a proper bench).

Source: Obsidian To Do § From Brief 004.

---

Imported from Linear [DEV-34](https://linear.app/stevevine/issue/DEV-34/add-explicit-timing-leak-assertion-for-login-flow) · parent DEV-8