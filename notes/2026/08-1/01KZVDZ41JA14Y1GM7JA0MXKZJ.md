---
id: 01KZVDZ41JA14Y1GM7JA0MXKZJ
created: 2026-08-12T16:47:54.41838Z
updated: 2026-08-12T16:47:54.41838Z
type: task
title: 'web-crawler: enforce the per-host max_pages cap in the runner (DEV-566 part 3)'
imported_from: linear
label: bug
priority: low
assignee: steve
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 208
---
Split from [DEV-566](<https://linear.app/stevevine/issue/DEV-566>) part 3 (the `max_pages` cap bug); the other two parts (route-template dedup, inventory decoupling) stay on DEV-566.

### Problem

A host emitted **869 URLs** despite `max_pages=500`.

Investigated against the real katana v1.6.1 binary:

* `max_pages` → katana `-mdp` / `-max-domain-pages` ("maximum number of pages to crawl **per domain**"); the runner builds this correctly.
* `-mdp` **works** in isolation (`katana ... -mdp 3` → exactly 3 URLs), and has been present since before the run that triggered DEV-566 — so it's not "flag ignored" or "predates the fix".
* But `-mdp` is a katana-side **soft, per-domain** cap and isn't authoritative at scale: the production run was a 514-seed `-list` crawl with concurrency, and one host still produced 869 > 500. The param + CR description claim **"per host"** — a contract the runner doesn't actually guarantee.

### Fix

Make the documented per-host cap **authoritative in the runner**: in the streaming emit loop (`_on_line`), count emitted `url` assets per host (`_canonical_url_key`'s host component) and skip emitting once a host reaches `max_pages`. Keep `-mdp` (it still usefully reduces wasted crawling). Update the `max_pages` description (runner + `chart/seeds/web-crawler.yaml`) to say the cap is enforced per host by the runner.

### Acceptance

* Emitted `url` assets per host never exceed `max_pages`, independent of katana's soft-limit precision or multi-seed batching. `max_pages=null` ⇒ unlimited.
* Unit tests: per-host cap truncates host A at `max_pages` while host B is unaffected; `null` ⇒ no cap; query-only duplicates over the cap still collapse via the DEV-538 dedup (counted as `skipped`, not `capped`).

---

Imported from Linear [DEV-583](https://linear.app/stevevine/issue/DEV-583/web-crawler-enforce-the-per-host-max-pages-cap-in-the-runner-dev-566)