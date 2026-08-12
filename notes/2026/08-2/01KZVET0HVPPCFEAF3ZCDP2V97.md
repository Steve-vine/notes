---
id: 01KZVET0HVPPCFEAF3ZCDP2V97
created: 2026-08-12T17:02:35.579526Z
updated: 2026-08-12T17:02:35.579526Z
type: task
title: 'Rename engine: katana → web-crawler (Web Crawler)'
priority: medium
task_status: done
imported_from: linear
label: chore
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 268
---
Atomic engine rename per **Brief 110** + **ADR 036**.

**Mapping:** tool `katana` → slug `web-crawler`, displayName "Web Crawler".

One PR: package dir + python module + `pyproject` + `@engine` name + handshake + CR `metadata.name`/`engineRef` + seed filename + image repo + CI/smoke/docs + tests move to the slug; implementation refs (`KATANA_BIN`, chromium install, `headless` param plumbing, description) keep the tool name. Verify handshake == C…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-373](https://linear.app/stevevine/issue/DEV-373/rename-engine-katana-web-crawler-web-crawler)