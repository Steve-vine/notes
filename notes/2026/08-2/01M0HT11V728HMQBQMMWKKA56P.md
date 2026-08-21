---
id: 01M0HT11V728HMQBQMMWKKA56P
created: 2026-08-21T09:21:58.119599Z
updated: 2026-08-21T17:28:09.973433Z
type: task
title: Build backend and frontend images in parallel jobs
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 335
sprint: sspwpgk
blocked_by:
- 01M0HSZ4CJCS5AEBZV3RCXBRK5
- 01M0HT11RCTTCGVMAA8NTNX5PN
assignee: steve
label:
- improvement
priority: low
task_status: active
---
build-images runs the backend then frontend buildx builds as sequential steps in one job. Split into two parallel jobs (shared tag computed once, passed via outputs) — saves a few minutes per deploy with no policy change. Depends on runner concurrency (COM-326) to actually overlap; independently useful once COM-334 moves builds to main.