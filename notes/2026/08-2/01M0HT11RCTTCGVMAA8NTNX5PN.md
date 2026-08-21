---
id: 01M0HT11RCTTCGVMAA8NTNX5PN
created: 2026-08-21T09:21:58.028996Z
updated: 2026-08-21T09:21:58.028996Z
type: task
title: Build images on merge to main; staging deploy becomes retag + helm
assignee: steve
task_status: todo
priority: medium
label: improvement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 334
---
The staging push currently builds both images (11–18 min deploy latency). Build on every push to main instead (parallel with the backstop, tagged by SHA); the staging push then retags/promotes the existing image and runs helm + smoke (~2–3 min). Needs an ADR amendment: ADR 0008/0041 word the staging push as what builds — images stay immutable, only the build trigger moves. Keep the dispatch fallback for dropped push events.