---
id: 01KZVDG3VTYFVA85RMJ9QV49GQ
created: 2026-08-12T16:39:42.714645Z
updated: 2026-08-12T16:39:42.714645Z
type: task
title: Bridge CNAME-aliased hosts via ALIAS_OF (host-stack coverage)
imported_from: linear
priority: low
assignee: steve
label: feature
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 187
---
Deferred from [DEV-646](<https://linear.app/stevevine/issue/DEV-646>). DEV-642/646 bridge hostname↔IP via `RESOLVES_TO`. The remaining host-identity gap is **CNAME aliasing**: a hostname that's a CNAME to another hostname (e.g. `www.example.com → example.com`, or `app.example.com → app.cloudfront.net`) splits a host's components across the two names, and the `RESOLVES_TO`-to-IP bridge doesn't join them.

## Idea

Use the `ALIAS_OF` relation (reserved in `AssetRelationType`) to link a CNAME alias to its target: `subdomain(alias) --ALIAS_OF--> subdomain(target)`. cloudflare-dns-discovery already surfaces CNAME content as `subdomain.meta.target` (see DEV-646 exploration); httpx/dns outputs may carry it too.

## Scope (to triage at plan time)

* **Write the edge** in the asset-mint path when an asset carries a CNAME target (cloudflare `meta.target`; any other source). Resolve-or-mint the target `subdomain` anchor; idempotent; reuse the DEV-642/646 mint helpers.
* **Settle direction/semantics**: `ALIAS_OF` = alias→canonical (parent=alias? or canonical?) — decide + document, mirroring the DEV-642 `RESOLVES_TO` decision record.
* **Traverse it** in `assemble_host_assets`: fold the alias↔canonical pair into the host (carefully — CNAMEs to shared infra like a CDN must NOT lump unrelated tenants; likely treat a CNAME to an off-scope/third-party apex as a boundary, similar to the shared-IP vhost caveat).
* Tests over CNAME-chain shapes + the shared-CDN boundary case.

## Acceptance

* A CNAME-aliased host's components (split across alias + canonical names) are assembled together; CNAMEs to shared third-party infra don't lump unrelated hosts. Tests.

## Notes

Pure coverage widener (P3 is promote-only / false-negative-safe). The shared-CDN lumping risk is the main design care — analogous to the shared-IP vhost caveat from DEV-642. Plan-mode-driven.

---

Imported from Linear [DEV-653](https://linear.app/stevevine/issue/DEV-653/bridge-cname-aliased-hosts-via-alias-of-host-stack-coverage)