---
id: 01KZVF0827X7FYKNMQ2VY6ZQ5X
created: 2026-08-12T17:05:59.879458Z
updated: 2026-08-12T17:06:07.443873Z
type: task
title: 'katana: ship headless crawl mode — engine-only build (chromium + `headless` param)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 277
assignee: steve
imported_from: linear
label: null
priority: low
task_status: done
---
**Follow-up to the** DEV-358 **spike (Brief 105).** The spike proved `katana -headless --no-sandbox` runs clean inside a real scanner Job pod under the **current** securityContext (`seccomp: RuntimeDefault`, `runAsNonRoot`, `drop:[ALL]`) — **Option (A): engine-only, no backend/jobspec cha…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-363](https://linear.app/stevevine/issue/DEV-363/katana-ship-headless-crawl-mode-engine-only-build-chromium-headless)