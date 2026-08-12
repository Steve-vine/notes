---
id: 01KZVE9GQW03PR6BKW63WG4V79
created: 2026-08-12T16:53:35.100949Z
updated: 2026-08-12T16:54:30.564665Z
type: task
title: Web-crawler emits near-duplicate URL assets (query-only / anti-bot token variants)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 224
sprint: sp88phy
assignee: steve
imported_from: linear
label:
- follow_up
priority: medium
task_status: done
---
Follow-up from DEV-536 (root cause found while debugging the vulnerability scanner timeout).

The web-crawler emits a separate `url` Asset for URLs that are the **same resource differing only by query string**. On the "Full Test" run against `voicenation.com` (run `ad38facd`),…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-538](https://linear.app/stevevine/issue/DEV-538/web-crawler-emits-near-duplicate-url-assets-query-only-anti-bot-token)