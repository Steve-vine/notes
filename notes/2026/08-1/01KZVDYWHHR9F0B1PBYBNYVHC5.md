---
id: 01KZVDYWHHR9F0B1PBYBNYVHC5
created: 2026-08-12T16:47:46.737673Z
updated: 2026-08-12T16:48:34.909226Z
type: task
title: 'tls-certificate-analysis: enumerate all supported TLS versions, not just the negotiated one (misses TLS 1.0/1.1)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 207
sprint: sp88phy
assignee: steve
imported_from: linear
label:
- follow_up
priority: medium
task_status: done
---
## Context

Surfaced comparing a RedVektor "Vuln Scan" run against `voicenation.com` (run `e249ce31`, 2026-06-23) with a Nessus Basic Network Scan of the same scope. Nessus reported **TLS Version 1.0 Protocol Detection** and **TLS Version 1.1 Deprecated Protocol** on 3 hosts; RedVektor produced **no** weak-protocol finding.

## Root cause (verified)

The engine *does* have a weak-protocol check — `_is_weak_protocol()` flags `ssl20/ssl30/tls10/tls11` as a medium finding (`runner.py`, Brief 104 / DEV-357). But the tlsx invocation (`_build_cmd`) probes with a single connection and **no version enumeration** — it passes `-json -silent -disable-update-check -ex -ss -mm -c -timeout` only, no `-tls-versions-enum` / per-version probing.

tlsx therefore reports only the **highest negotiated** protocol in `tls_version`. A host that supports TLS 1.0/1.1 **and** 1.2/1.3 negotiates 1.3 and reads as clean — the weak-protocol finding never fires. Nessus probes each version explicitly, which is why it catches the legacy ones.

## Proposed fix

Add a TLS-version enumeration mode to the engine so the weak-protocol finding reflects the **full set** of supported versions, not just the negotiated one. Options to evaluate at brief time:

* tlsx native `-tls-versions-enum` (preferred if its JSON output exposes the enumerated set per endpoint), or
* per-version probe loop (`-min-version`/`-max-version` pinned) and aggregate.

Emit one `tls-weak-protocol` finding per endpoint if **any** supported version is < TLS 1.2 (keep the existing medium severity / dedup_key). Add a param to toggle enumeration (it's an extra round of probes) with a sensible default.

## Acceptance

* A host supporting tls10/tls11 alongside tls12/tls13 yields a weak-protocol finding.
* Conformance/fixtures updated for the enumerated-version record shape.

## Notes

Scope caveat carried from the same comparison: the run used `proxied: any`, so TLS posture is only meaningful on non-proxied/origin records (Cloudflare edge serves 1.2+). Related to the scope-hygiene thread in DEV-567.

---

Imported from Linear [DEV-584](https://linear.app/stevevine/issue/DEV-584/tls-certificate-analysis-enumerate-all-supported-tls-versions-not-just)