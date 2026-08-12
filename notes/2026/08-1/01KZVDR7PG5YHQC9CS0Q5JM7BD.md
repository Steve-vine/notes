---
id: 01KZVDR7PG5YHQC9CS0Q5JM7BD
created: 2026-08-12T16:44:08.784963Z
updated: 2026-08-12T16:45:00.255166Z
type: task
title: 'P4: version-cve FP tuning — full CPE applicability, confidence gating, scope hygiene'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 197
sprint: s3ry03w
assignee: steve
imported_from: linear
label:
- feature
priority: medium
task_status: done
---
Phase 4 of M11. Tightens version-CVE correlation ([DEV-610](<https://linear.app/stevevine/issue/DEV-610>) / [DEV-621](<https://linear.app/stevevine/issue/DEV-621>), merged) for **precision** — turning the raw mirror matches into a low-false-positive finding set.

Scoped by `docs/proposals/version-to-cve-correlation.md`.

## Problem

P2/P3 match a detected version against the mirror's CPE applicability and emit a finding per CVE. That's high-recall but noisy:

* The matcher handles the common single-`cpe_match`-with-range shape; it ignores NVD **applicability operator trees** (AND/OR nodes, "running on" / target-platform constraints) — so it can match CVEs that only apply in a configuration the target isn't in (false positives).
* No-version / "matches-all" CPEs (`versionStartIncluding`-less, `*`) over-match.
* Distro back-ports: a vendor patches a CVE without bumping the upstream version → the version still "matches" but isn't vulnerable.
* `low`-confidence httpx tech-string matches (DEV-621) currently emit at the same weight as nmap-CPE matches.
* Origin scope: software-version findings are only meaningful on origin hosts, not CDN edges (cf. [DEV-567](<https://linear.app/stevevine/issue/DEV-567>)).

## Scope (to triage at plan time)

* **Full CPE applicability** in the matcher: evaluate AND/OR node trees + the `vulnerable` flag correctly, and the running-on/target constraints, instead of the flat single-criterion check.
* **No-version CPE suppression**: drop `matches-all` applicability unless explicitly opted in.
* **Confidence gating**: use the `meta.match_confidence` label (DEV-621) — e.g. a `min_confidence` / severity floor so low-confidence tech-string matches can be gated or down-weighted; sensible defaults that cut noise without losing the high-value KEV/EPSS hits.
* **KEV/EPSS prioritisation**: optionally gate or rank by KEV / EPSS so the default finding set leads with real-world-exploited CVEs.
* **Scope hygiene**: correlate origin records only (proxied/CDN caveat, DEV-567).
* **Back-port awareness**: at least document the limitation; optionally a vendor/distro suppression hook.

## Acceptance

* The default version-cve run on a real estate produces a materially lower-FP finding set than P2/P3 (operator-tree applicability honoured, no-version CPEs suppressed, low-confidence gated per the chosen defaults), without dropping KEV/high-CVSS hits.
* Matcher + engine tests for the applicability-tree + gating logic; in-cluster proof.

## Notes

Plan-mode-driven: the applicability-evaluation depth, the default gating thresholds (confidence/severity/KEV-EPSS), and the scope-hygiene mechanism get agreed with Steve before implementation. This is the precision counterpart to P1–P3's recall.

---

Imported from Linear [DEV-624](https://linear.app/stevevine/issue/DEV-624/p4-version-cve-fp-tuning-full-cpe-applicability-confidence-gating)