---
id: 01KZVB170Y9GY4VRNA89E0ZT53
created: 2026-08-12T15:56:37.278959Z
updated: 2026-08-12T15:57:56.439445Z
type: task
title: Verify scanner toolchain requirements before pinning a version
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 83
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- follow_up
- chore
priority: medium
task_status: backlog
---
Brief 009 pinned httpx v1.9.0 and copied subfinder's `golang:1.23-alpine` builder image. httpx v1.9.0 requires Go ≥1.25.7 — the build failed during PR #18's smoke. One-line Dockerfile fix (1.23 → 1.25). Add to brief template's "References (read first)" section: "verify upstream toolchain requirements (Go version, libc, etc.) match the planned base image."

Source: Obsidian To Do § From Brief 009.

---

Imported from Linear [DEV-52](https://linear.app/stevevine/issue/DEV-52/verify-scanner-toolchain-requirements-before-pinning-a-version) · parent DEV-15