---
id: 01KZVDDDXCNQAFWWFWH7CV5H9J
created: 2026-08-12T16:38:14.700131Z
updated: 2026-08-12T16:39:46.434823Z
type: task
title: 'engine-spec: document meta conventions surfaced by M11 (observed_ip/ip host edges, CVE finding meta keys)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 186
sprint: s3ry03w
assignee: steve
imported_from: linear
label: null
priority: medium
task_status: done
---
M11 introduced engine-facing **conventions** that aren't in the canonical engine contract (`docs/engine-spec.md`, v1.2.0). No wire-format or SDK-API change — additive doc clarifications (engine-spec PATCH bump per [ADR 030](<https://linear.app/stevevine/issue/>) + changelog entry). Engines built today work unchanged; this is so **future** engine authors know the conventions.

## What to document

1. `meta.observed_ip` **/** `meta.ip` **drive host-graph edges** (DEV-642 / DEV-646). The dispatcher auto-draws `subdomain --RESOLVES_TO--> ip` from these keys on `endpoint` / `url` / `subdomain` assets (`_host_ip_resolution` in `tasks/workflow_runs.py`). Direction hostname→IP; subdomain→IP only (vhost-safe); shared-IP best-effort. **Convention to state:** an engine emitting a hostnamed asset should set the resolved IP in `meta.observed_ip` (or `meta.ip`) to get host-stack correlation. Currently only shown in one example, not defined as a consumed convention.
2. **CVE-finding** `meta` **key convention** (DEV-610 / DEV-630). The findings UI renders `cve_id`, `cve_ids`, `kev`, `epss_score`, `epss_percentile`, `cvss_version`, `cwe_ids`, `match_confidence`, `applicability` from finding `meta` (`severity_scheme=cvss`; `Finding.cve_ids` column stays a legacy V1 field). nuclei + version-cve rely on this implicitly. **Convention to state:** the meta keys a CVE-emitting engine should populate for the UI + correlation to light up.
3. **Clarify** `resolves_to` **/** `alias_of` **are dispatcher-derived, not engine-declarable.** The relation enum reserves them, but an engine sending `parent.relation:"resolves_to"` gets a WARN + fallback to `derived_from` (only `derived_from`/`exposes` are engine-declarable, §5.2.1). One line prevents confusion.

## Open decision (not blocking the doc)

* **Output-token internal-lookup pattern** (DEV-610): version-cve reuses its per-step-run output token (`RV_OUTPUT_TOKEN`) to GET an in-cluster endpoint (`RV_CVE_LOOKUP_URL`). Today bespoke per-engine env, not a generalized contract. Decide whether to formalize this as a spec-level capability (an engine reading back into an internal API) or leave it engine-specific. Document the outcome.

## Acceptance

* `engine-spec.md` (+ changelog) documents conventions #1–#3 as a PATCH bump; the #4 pattern decision is recorded (formalize or note as engine-specific). No SDK code change.

## Notes

`docs/engine-spec.md` is the right home (it has a changelog + ADR-030 versioning policy) — this is **not** `architectural-standards.md`. Surfaced during the M11 wrap-up review.

---

Imported from Linear [DEV-654](https://linear.app/stevevine/issue/DEV-654/engine-spec-document-meta-conventions-surfaced-by-m11-observed-ipip)