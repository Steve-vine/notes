---
id: 01M657JZ0BBH18E6H8PPWKXKRK
created: 2026-10-30T01:42:59.851998Z
updated: 2026-10-30T01:42:59.851998Z
type: task
title: A test person in the directory for E2E Test Company, so the browser journeys can raise an access request and have a second administrator reject it
priority: low
assignee: steve
task_status: backlog
label: follow_up
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1458
---
Follow-up to COM-1451 (sprint 99, ADR 0135).

Journey 5 is waiting on this. Every access request names real directory people (a group's owner, a membership's member) or a business role that places a new account somewhere in the real directory. The directory is shared by every company, so E2E Test Company has no person of its own.

## What it needs

- One clearly named test account in the directory (e.g. "E2E Test Person"), and perhaps one test group, that nobody relies on.
- A business role in E2E Test Company that uses only them.

The journey then raises a request naming only those, shows Admin A can't approve their own, and has Admin B **reject** it. It never approves, validates or expedites, so the directory is never changed.

## For Steve

Whether to create the test person and group in Entra (cloud-only, so Compass reads it straight away), and what to call them.

**Chain:** independent.