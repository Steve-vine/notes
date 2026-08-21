---
id: 01M0HT11V728HMQBQMMWKKA56P
created: 2026-08-21T09:21:58.119599Z
updated: 2026-08-21T20:16:32.634169Z
type: task
title: Build backend and frontend images in parallel jobs
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 335
sprint: sspwpgk
blocked_by:
- 01M0HSZ4CJCS5AEBZV3RCXBRK5
- 01M0HT11RCTTCGVMAA8NTNX5PN
comments:
- id: 01M0JZFKVTDSWAP580WBYVGJ57
  author: Steve Vine
  at: 2026-08-21T20:16:32.63386Z
  text: |-
    Done — PR #326, squash-merged to main 2026-08-21.

    The backend and frontend builds share nothing — different Dockerfile, different context, different layer cache ref — so running them one after the other was purely an accident of living in the same job. They are now a matrix and run at the same time.

    The tag is computed once, in its own small job, and passed to both legs via outputs. Each leg computing its own timestamp would drift across a minute boundary and give the two halves of one release different tags — the kind of thing only ever noticed while trying to debug something else.

    fail-fast is off deliberately: if the backend build breaks, whether the frontend also breaks is information worth having on the same run rather than after a fix-and-retry.

    Because the cache refs were already per-image, the two builds do not contend for the buildx cache when concurrent — which is what makes this free rather than a wash.

    Stacked on COM-334, so both land before this sprint's deploy and the first promote-not-rebuild staging run exercises the pair together.
assignee: steve
label:
- improvement
priority: low
task_status: active
---
build-images runs the backend then frontend buildx builds as sequential steps in one job. Split into two parallel jobs (shared tag computed once, passed via outputs) — saves a few minutes per deploy with no policy change. Depends on runner concurrency (COM-326) to actually overlap; independently useful once COM-334 moves builds to main.