---
id: 01KZVEP16APDQ2MMYE6M42ZDPZ
created: 2026-08-12T17:00:25.162407Z
updated: 2026-08-12T17:01:33.870345Z
type: task
title: Brief 116 — Endpoint identity model + anchor-relative observations (STACK)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 256
sprint: sv10nf2
assignee: steve
imported_from: linear
label:
- feature
priority: null
task_status: done
---
ADR-037 sequence step 4 — the endpoint identity model that fixes the IP-collapses. **Design/epic** for a STACK of three PR-shippable units.

**Brief merged:** `docs/briefs/116-endpoint-identity-model.md` (#305).

**The fix:** one `endpoint` kind keyed `{anchor}:{port}/{proto}` (anchor = scanned host, not resolved IP); `port`/`service` retire into it; observed IP → meta attribute; host→endpoint via `EXPOSES` (reconciled by DEV-407…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-408](https://linear.app/stevevine/issue/DEV-408/brief-116-endpoint-identity-model-anchor-relative-observations-stack)