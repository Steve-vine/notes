---
id: 01KZVETTBWGXQ8WZMGPN3XGM9Z
created: 2026-08-12T17:03:02.012784Z
updated: 2026-08-12T17:03:02.012784Z
type: task
title: 'Rename engine: cloudflare → cloudflare-dns-discovery (Cloudflare DNS Discovery)'
assignee: steve
imported_from: linear
label: chore
priority: medium
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 274
---
Atomic engine rename per **Brief 110** + **ADR 036**.

**Mapping:** tool `cloudflare` → slug `cloudflare-dns-discovery`, displayName "Cloudflare DNS Discovery". (Cloudflare is the *target* queried, not the implementation tool — allowed by ADR 036.)

One PR: package dir + python module + `pyproject` + `@engine` name + handshake + CR `metadata.name`/`engineRef` + seed filename + image repo + CI/smoke/docs + tests move to the slug; implementation r…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-366](https://linear.app/stevevine/issue/DEV-366/rename-engine-cloudflare-cloudflare-dns-discovery-cloudflare-dns)