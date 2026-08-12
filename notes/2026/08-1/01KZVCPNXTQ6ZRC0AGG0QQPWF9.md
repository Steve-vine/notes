---
id: 01KZVCPNXTQ6ZRC0AGG0QQPWF9
created: 2026-08-12T16:25:49.242658Z
updated: 2026-08-12T16:26:48.684438Z
type: task
title: 'version-cve: nmap CPE 2.2 URIs fail to parse → zero CVEs for all endpoints'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 171
sprint: s3ry03w
assignee: steve
imported_from: linear
label:
- bug
priority: urgent
task_status: done
---
## Summary

The `version-cve` engine returns **zero CVEs for every nmap** `endpoint` because `services/cve_lookup.py::parse_cpe` only handles **CPE 2.3** URIs, but `service-detection` (nmap) emits **CPE 2.2** URIs. This silently breaks the entire high-confidence endpoint→CVE path — the headline M11 capability.

## Evidence (live on dev, 2026-06-27, full mirror of 361,483 CVEs)

A "CVE Detection" run (workflow_run `6a455b4f`, 17:47, after the backfill completed) produced **0 findings** despite Apache `http_server` 2.4.66 endpoints present, e.g. `{"cpe":["cpe:/a:apache:http_server:2.4.66"],"product":"Apache httpd","version":"2.4.66"}`.

Direct service-layer reproduction:

```
parse_cpe('cpe:/a:apache:http_server:2.4.66')                 -> (None, None, None)   # 2.2 — what nmap emits
parse_cpe('cpe:2.3:a:apache:http_server:2.4.66:*:*:*:*:*:*:*') -> ('apache','http_server','2.4.66')  # 2.3
lookup_cves(cpe23='cpe:/a:apache:http_server:2.4.66')          -> 0 CVEs
lookup_cves(cpe23='cpe:2.3:a:apache:http_server:2.4.66:...')   -> 24 CVEs
lookup_cves(product='Apache httpd', version='2.4.66')          -> 0 CVEs   # product fallback: name != 'http_server'
```

## Root cause

`parse_cpe` (cve_lookup.py:57): `parts = cpe23.split(":"); if len(parts) < 6 or parts[0] != "cpe": return (None,None,None)` and reads vendor/product/version at indices **3/4/5** (the 2.3 layout). A 2.2 URI `cpe:/a:vendor:product:version` splits to `['cpe','/a','vendor','product','version']` (5 parts) → rejected. nmap's default CPE output is 2.2, so `_resolve_endpoint_hits` gets nothing from `meta.cpe`; the `meta.product`/`meta.version` fallback then also misses because nmap's product label ("Apache httpd") ≠ the CPE product token ("http_server").

## Fix

1. `parse_cpe` **should accept CPE 2.2** (`cpe:/a:vendor:product:version[:update[:edition]]`) as well as 2.3 — detect the form (`parts[1]` starts with `/` → 2.2, fields at 2/3/4; else 2.3, fields at 3/4/5) and normalise to `(vendor, product, version)`. URL-decode/unescape as needed.
2. Add tests with real nmap 2.2 CPEs (apache http_server, coyote_http_connector, openssh, etc.) asserting they resolve to the same `(vendor, product, version)` as their 2.3 equivalents and return the expected CVEs.
3. Re-verify end-to-end on dev: a `version-cve` run over the existing Apache endpoints yields findings (≥24 for the 2.4.66 host).

## Acceptance criteria

* nmap 2.2 CPEs resolve to vendor/product/version and match the mirror.
* The dev "CVE Detection" workflow produces CVE findings for the Apache (and other versioned) endpoints.
* Tests cover 2.2 + 2.3 parsing.

## Notes

Reopens the M11 feature as not actually working through the primary (nmap) path. Found while investigating a user-reported zero-findings run after the M12 CVE-mirror backfill (DEV-675/677) made the data complete. The `technology` (httpx) path uses a separate `_parse_technology_name` and should be checked too, but the endpoint/nmap path is the high-confidence one and is fully broken.

---

Imported from Linear [DEV-692](https://linear.app/stevevine/issue/DEV-692/version-cve-nmap-cpe-22-uris-fail-to-parse-zero-cves-for-all-endpoints)