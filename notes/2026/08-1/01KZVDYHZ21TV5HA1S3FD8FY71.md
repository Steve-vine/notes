---
id: 01KZVDYHZ21TV5HA1S3FD8FY71
created: 2026-08-12T16:47:35.90624Z
updated: 2026-08-12T16:47:35.90624Z
type: task
title: Version-to-CVE correlation (passive vuln detection, e.g. PHP version CVEs) — capability RedVektor lacks vs Nessus
assignee: steve
imported_from: linear
task_status: done
priority: high
label: feature
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 206
---
## Context

Surfaced comparing a RedVektor "Vuln Scan" run against `voicenation.com` (run `e249ce31`, 2026-06-23) with a Nessus Basic Network Scan of the same scope. Nessus reported a large block of **PHP 8.3.x < {8.3.12 … 8.3.31} Multiple Vulnerabilities** findings (~129 rows across 6 plugins). RedVektor found **none** of these.

## Why RedVektor misses them — methodology gap (not config)

This is a fundamental capability difference, not a tuning issue:

* **Nessus**: passively reads the software version (banner / `X-Powered-By` / service fingerprint), then maps that version against its CVE database — "PHP 8.3.x is below the patched 8.3.31, therefore it carries CVEs X, Y, Z." No active exploitation needed.
* **nuclei (our vulnerability-scanner)**: match-based — a template has to *actively confirm* a specific vulnerability. The bundled templates contain no PHP version-to-CVE rollup. Enabling `info` would at most let `php-detect` identify the version; it would **not** enumerate the CVEs.

So no parameter change to the existing engines reproduces these findings. RedVektor currently has no path from "detected software version" → "known CVEs for that version."

## Requirement

RedVektor needs **version-to-CVE correlation**: take software/component versions already observed (web-probe tech-detect, service-detection banners, future SBOM/CPE inputs) and correlate against a CVE/advisory source (NVD, OSV, vendor feeds) to emit findings — passive, version-based vulnerability detection alongside the active nuclei model.

This closes a real reNgine/DefectDojo-replacement gap: a Nessus/OpenVAS-style "you are running outdated X with N known CVEs" capability.

## Scope note — expand into a dedicated milestone

This issue is the **requirement capture / spike**, not the build. The full capability is milestone-sized and should be expanded into its own milestone. Decisions to take there:

* CVE data source(s) and refresh mechanic (NVD API / OSV / mirrored DB), and where it lives (baked image vs synced store).
* Identity matching: CPE generation from detected tech, version-range comparison, false-positive handling (back-ported patches, distro versioning).
* New engine vs enrichment step on existing assets; finding model (CVE-keyed findings, severity from CVSS, dedup).
* Scope hygiene: origin-software versions are only meaningful on non-proxied/origin records (cf. DEV-567).

## Acceptance (for this issue only)

* Requirement + approach documented; CVE-source and matching options compared; milestone proposal drafted for Steve to review.

---

Imported from Linear [DEV-585](https://linear.app/stevevine/issue/DEV-585/version-to-cve-correlation-passive-vuln-detection-eg-php-version-cves)