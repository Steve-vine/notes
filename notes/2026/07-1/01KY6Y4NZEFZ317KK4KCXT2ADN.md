---
id: 01KY6Y4NZEFZ317KK4KCXT2ADN
created: 2026-07-23T07:30:48.942962Z
updated: 2026-07-23T12:24:59.644578Z
type: task
title: Stop seeding system taxonomies into taxonomies.yaml
number: 12
assignee: steve
label: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: svnk3dy
---
Follow-up from ADR 0009 (DEV-496). Under ADR 0009, system taxonomies are app-owned and `taxonomies.yaml` holds user-defined taxonomies only.

**Checklist**

- [X] Remove the system-taxonomy seed from `vault::bootstrap` — a fresh vault's `taxonomies.yaml` now gets a comment-only placeholder (user taxonomies only)
- [X] Update the `vault.rs` tests that assert the seed content
- [X] `is_valid_vault` revisited — now keys off the `notes/` directory (a comment-only/absent `taxonomies.yaml` is still valid)

**Done when:** bootstrapping a fresh vault no longer writes system taxonomies into `taxonomies.yaml`, and tests reflect it.

---

Implemented in `src-tauri/src/vault.rs`: `TAXONOMIES_PLACEHOLDER` (comment-only) replaces the system seed; `bootstrap` still writes only-if-absent; `is_valid_vault` → `notes/` dir. Verbatim CI commands green (14 lib tests incl. updated `bootstrap_creates_structure` + new `valid_vault_needs_only_notes_dir`); bundle builds. No migration (DEV-483 loader will ignore stale `system:` entries in existing vaults).

**PR:** [https://github.com/Steve-vine/notula/pull/10](<https://github.com/Steve-vine/notula/pull/10>)

---

Linear DEV-497 · M2 — Storage & file handling · created 2026-06-19 · done 2026-06-19