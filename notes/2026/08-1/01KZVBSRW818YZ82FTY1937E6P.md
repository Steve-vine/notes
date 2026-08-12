---
id: 01KZVBSRW818YZ82FTY1937E6P
created: 2026-08-12T16:10:01.992231Z
updated: 2026-08-12T16:11:10.683635Z
type: task
title: 'Rename engine: httpx → web-probe (Web Probe)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 142
sprint: s0ht2jk
assignee: steve
imported_from: linear
label:
- chore
priority: medium
task_status: done
---
Atomic engine rename per **Brief 110** + **ADR 036**.

**Mapping:** tool `httpx` → slug `web-probe`, displayName "Web Probe".

One PR: package dir + python module + `pyproject` + `@engine` name + handshake + CR `metadata.name`/`engineRef` + seed filename + image repo + CI/smoke/docs + tests move to the slug; implementation refs (e.g. `HTTPX_BIN`, install line, description) keep the tool name. Verify handshake == CR name; reseed; smoke on dev k3s. See Brief 110.

---

Imported from Linear [DEV-367](https://linear.app/stevevine/issue/DEV-367/rename-engine-httpx-web-probe-web-probe)