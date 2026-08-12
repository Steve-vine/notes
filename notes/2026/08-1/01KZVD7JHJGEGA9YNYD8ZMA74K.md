---
id: 01KZVD7JHJGEGA9YNYD8ZMA74K
created: 2026-08-12T16:35:02.834795Z
updated: 2026-08-12T16:35:57.542577Z
type: task
title: Default cisa_kev_url to a non-Akamai source (CISA GitHub mirror)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 177
sprint: skesb93
assignee: steve
imported_from: linear
label:
- follow_up
priority: medium
task_status: done
---
## Context

The default `cisa_kev_url` is CISA's official feed:
`https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json`

That host is **fronted by Akamai**, which IP/ASN-reputation-blocks cloud datacenter egress. Confirmed on dev (2026-06-27): every request from the AWS egress (`3.11.225.98`) returns **403 Access Denied** (`errors.edgesuite.net`, ref `#18...`), header-agnostic (tested no-UA / browser / curl UAs and the `.csv` variant). So the default KEV feed **fails out of the box for most self-hosted installs** (which run in cloud), leaving `require_kev` non-functional until an operator intervenes.

DEV-663 already made `cisa_kev_url` configurable + per-source-isolated (a KEV failure no longer aborts NVD), and added air-gap import as a fallback. On dev we've now pointed the setting at CISA's **own GitHub mirror**, which is **not** behind Akamai and serves the identical, current feed:

```
https://raw.githubusercontent.com/cisagov/kev-data/develop/known_exploited_vulnerabilities.json
```

Verified: 200, catalogVersion `2026.06.25`, 1,629 entries, parses cleanly with `parse_kev`; KEV flags now apply on dev.

## Scope

* Change the **default** `cisa_kev_url` (in `core/config.py` `Settings`, the `core/platform_settings` registry env-fallback, and any chart/values default) to the GitHub raw mirror, with a comment explaining the Akamai-block rationale. Keep it overridable (already is).
* Decide on branch pinning: `develop` is what CISA publishes to — confirm it's the intended stable path, or pin a tag/`main` if one exists, to avoid a moving-branch surprise.
* Sanity-check `first_epss_url` (`epss.cyentia.com`) for the same class of block — it currently works from the dev egress (`source_status.epss = ok`), so likely fine, but note it.
* Doc: a line in the CVE-mirror/engine docs on the KEV source + air-gap fallback.

## Acceptance criteria

* A fresh deploy on cloud egress syncs KEV successfully with no operator override.
* `cisa_kev_url` remains overridable via Settings → CVE Database.
* `ruff`/`mypy`/tests green.

## Notes

Discovered while fixing the live KEV 403 during the M12 deploy. Relates to DEV-663 (configurable URL + air-gap import) and the standing **egress hardening** consideration (KEV/CISA reachability) worth tracking for M13/infra — a customer install behind a restrictive egress may still need the air-gap import path regardless of this default.

---

Imported from Linear [DEV-669](https://linear.app/stevevine/issue/DEV-669/default-cisa-kev-url-to-a-non-akamai-source-cisa-github-mirror)