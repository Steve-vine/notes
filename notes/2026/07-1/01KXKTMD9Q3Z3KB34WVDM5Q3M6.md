---
id: 01KXKTMD9Q3Z3KB34WVDM5Q3M6
created: 2026-07-15T21:23:55.831642028Z
updated: 2026-07-19T13:25:17.377020102Z
type: task
title: Registry retention — prune the Zot image accumulation
project: 01KX671DATY39VW6GWK3M2T3DN
number: 79
sprint: sd1gs0p
assignee: steve
label:
- chore
- tech_debt
priority: low
task_status: backlog
---
**ADR 0008 names this gap explicitly:** "The registry accumulates tags; a retention policy (prune untagged/aged non-`main` images) is needed eventually." Eventually is Sprint 8.

## The situation

Images push to the private Zot `zot.citops.net`. Every push to `main`/`staging` writes **two immutable tags per image** (`<branch>-yyyymmdd-hhmm` and `<short-sha>`), for both backend and frontend. No prune job exists — only `ci.yml`, no second workflow.

## Scope

- A retention policy: prune untagged and aged non-`main` images. Either Zot's own config (it's cluster infra, managed outside this repo) or a scheduled workflow hitting the registry API.
- **Must distinguish ISE's own repos from mirrored content**: Zot also acts as a pull-through mirror for docker.io and caches test images (`postgres:16`, `redis:7-alpine`, `ryuk`) — retention must not evict those.
- Keep the `main` release tags; the mutable `:buildcache` tags are already exempt from the immutable rule.

`chore`/`tech-debt`. Low urgency but named in an accepted ADR.