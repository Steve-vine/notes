---
id: 01KZVDCZ9NK3XD5321KGATF0K5
created: 2026-08-12T16:37:59.733681Z
updated: 2026-08-12T16:39:47.06402Z
type: task
title: Platform settings store + ADR (runtime-mutable global config, encrypted secrets)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 185
sprint: skesb93
assignee: steve
imported_from: linear
label: null
priority: high
task_status: done
---
## Context

Building UI-managed CVE-database settings (NVD API key, sync schedule, etc. — see sibling M12 issues) surfaced that **RedVektor has no runtime-mutable settings store**. Every config knob lives in `core/config.py` as pydantic `BaseSettings`, read from env **at process start only**. There is no way to change a setting from the UI and have it take effect.

This issue builds that foundation. CVE settings are its first consumer, but it is intended to back any future global platform setting.

## Decision needed (ADR)

Author an ADR for a **global (non-tenant) platform settings store**:

* DB-backed, runtime-readable (not cached for the process lifetime — or cached with an invalidation path).
* **Encrypted-secret support**, reusing the existing `credential_kek` / credential-crypto mechanism (ADR 022) used today by the per-company `custom_settings` table. The NVD API key must be stored encrypted at rest, never logged (already in `log_redact_fields`), and never returned in plaintext to the client (write-only / show-masked).
* Global scope, gated by `require_super_admin` (the CVE mirror is global/non-tenant — `cve`/`cve_cpe_match`/`cve_sync_state` have no `company_id`). In a single-tenant customer deploy the install owner is the super-admin.
* Typed accessors so callers get validated values with the same defaults/ranges as today's `Settings`.

## Scope

* New `platform_settings` table + migration (key/value with type + encrypted flag, or typed columns — decide in ADR).
* Service layer: get/set with encryption for secret-typed values; runtime read path (no restart).
* Seed/migrate the CVE knobs as the first registered settings: `nvd_api_key` (secret), `cve_data_sync_interval_hours`, `cve_sync_max_pages_per_run`, `cve_data_sync_enabled`, `cve_mirror_stale_after_hours`. Env values become the **fallback/default** when no DB override is set (backward compatible).

## Reuse

* `core/credential_crypto.py` + `credential_kek_b64` (ADR 022)
* `custom_settings` encryption pattern (per-company precedent)
* `require_super_admin` — `api/v1/deps/auth.py`

## Acceptance criteria

* A setting written via the service is read back by application code **without a process restart**.
* Secret values are encrypted at rest; a DB dump shows no plaintext NVD key; the API never returns the raw key.
* Existing env-based config continues to work when no DB override exists (no behaviour change on a fresh deploy).
* `uv run pytest`, `uv run mypy src/`, `ruff` green.

## Dependencies

Blocks: CVE admin API (settings GET/PUT), CVE database tab.

*Triage-level brief — refine the ADR/schema details in plan mode before implementing.*

---

Imported from Linear [DEV-660](https://linear.app/stevevine/issue/DEV-660/platform-settings-store-adr-runtime-mutable-global-config-encrypted)