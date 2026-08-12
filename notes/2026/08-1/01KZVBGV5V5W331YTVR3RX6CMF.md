---
id: 01KZVBGV5V5W331YTVR3RX6CMF
created: 2026-08-12T16:05:09.435451Z
updated: 2026-08-12T16:05:09.435451Z
type: task
title: Asset meta-merge semantics across selectors
assignee: steve
priority: low
task_status: backlog
imported_from: linear
label: follow_up
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 124
---
## Context

Surfaced during Brief 028 (Cloudflare Selector). When two selectors discover the same hostname — e.g. subfinder finds `api.example.com` via passive sources, and the Cloudflare selector finds the same hostname authoritatively — `AssetUpsertService` dedups by fingerprint, so both produce a single Asset row.

**What happens to** `Asset.meta` in that case is currently undocumented and unverified. It could be deep-merged, last-write-wins, or something in between. If last-write-wins, callers running both selectors lose the cross-source signal: running cloudflare after subfinder would overwrite subfinder-sourced meta and vice versa.

## Tasks

1. Read `AssetUpsertService.upsert()` (or wherever the merge happens) and confirm the actual meta-handling behaviour today.
2. Decide on the desired semantics. Default proposal: **per-source namespacing under** `meta.sources.<scanner>` (e.g. `meta.sources.cloudflare.proxied = true`, `meta.sources.subfinder.passive_origin = "crtsh"`), with cross-source-stable fields (e.g. `ip`) at the top level. Open to alternatives — deep-merge with conflict policy is the other obvious shape.
3. If current behaviour already matches, add a regression test and a `docs/architectural-standards.md` § "Asset meta semantics" entry.
4. If it doesn't, fix the upsert path, add tests, and document. No data migration needed (no production data yet).

## Acceptance criteria

* A test asserts the chosen meta-merge behaviour with two selectors producing the same fingerprint.
* `docs/architectural-standards.md` documents the rule.
* If the fix is non-trivial it ships under its own brief; otherwise inline as a small bug.

## References

* Brief 028 — [`docs/briefs/028-cloudflare-selector.md`](<https://github.com/Steve-vine/redvektor/blob/main/docs/briefs/028-cloudflare-selector.md>) (§ Risks)
* Session log — [`docs/sessions/028-cloudflare-selector.md`](<https://github.com/Steve-vine/redvektor/blob/main/docs/sessions/028-cloudflare-selector.md>) (§ Open questions / follow-ups)
* Parent: DEV-184

---

Imported from Linear [DEV-197](https://linear.app/stevevine/issue/DEV-197/asset-meta-merge-semantics-across-selectors) · parent DEV-184