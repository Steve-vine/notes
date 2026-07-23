---
id: 01KY6Y13NBFP723FN9Z2QQVP3F
created: 2026-07-23T07:28:51.883216Z
updated: 2026-07-23T09:17:05.765356Z
type: task
title: Vault bootstrap & app configuration
comments:
- id: 01KY6Y1K3DBHSE3K7DSRZ1H9BW
  author: Steve Vine
  at: 2026-07-23T07:29:07.692732Z
  text: |-
    Steve Vine · 2026-06-19:

    **Done building — in review.**

    **What was done**
    - **First-run flow** (`src/lib/FirstRun.svelte`): suggests `~/Notula`, "Create vault here" / "Choose a different folder…" (native picker via `@tauri-apps/plugin-dialog`). `+page.svelte` branches: loading → first-run (if unconfigured) → main placeholder.
    - **Config** (`src-tauri/src/config.rs`): hand-rolled `config.json` in the OS app-config dir, schema `{ version, vault_path }` (serde_json).
    - **Vault** (`src-tauri/src/vault.rs`): `bootstrap` creates `notes/`/`attachments/`/`.notula/` and seeds `taxonomies.yaml` with the 3 system taxonomies (Type/Task Status/Project Status per data-model.md) — **only if absent**, so existing vaults aren't clobbered. `is_valid_vault`, `default_vault_path`.
    - **Commands** `get_vault_state` / `initialize_vault` (in `lib.rs`); dialog plugin registered; `dialog:default` capability added.
    - **Tests:** 2 Rust unit tests (structure+seed; idempotency/no-clobber) — first real `cargo test` coverage.

    **Decisions / scope notes**
    - `get_vault_state` returns `configured: false` when the stored path is missing/invalid → UI re-prompts (handles a moved/deleted vault).
    - **Scope-guarded** out of adjacent briefs: `.notula/` empty (index = DEV-484), `notes/` empty (sharding = DEV-481), `taxonomies.yaml` written but **not parsed** (loader = DEV-483), no frontmatter (DEV-482). No new ADR (within ADR 0003/0004).
    - Default suggestion uses app-name capitalisation `~/Notula` (you'd typed lowercase) — trivially changeable; flag if you want `~/notula`.

    **Verification**
    - `cargo test` (2 pass), `cargo fmt --check`, `cargo clippy -- -D warnings`, `npm run check` (0 errors/warnings), `npm run tauri build` (bundles + launches).
    - **Manual sign-off needed** (assistive-access blocks GUI automation): first-run picker → vault created with seed on disk → relaunch goes straight to main → existing vault adopted untouched.

    **PR:** https://github.com/Steve-vine/notula/pull/5
    **Branch:** `brief-480-vault-bootstrap-app-configuration` · commit `83ca082`
assignee: steve
label:
- brief
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 5
sprint: s87b0qx
---
Establish where notes live and create the vault on first run.

**Checklist**

- [X] App config store (vault location + app settings), persisted per-OS conventions
- [X] First-run: choose/confirm the vault directory
- [X] Create `notes/`, `attachments/`, `.notula/`, and seed `taxonomies.yaml` with the system taxonomies (Type, Task Status, Project Status — see `brief/data-model.md`)
- [X] Open an existing vault without clobbering it

**Done when:** first launch produces a valid empty vault; subsequent launches reopen it cleanly.

---

### Agreed approach (planned 2026-06-19)

* **Config:** hand-rolled `config.json` in OS app-config dir, `{ version, vault_path }`.
* **Default vault:** `~/Notula` (suggested, any folder pickable).
* **Folder picker:** frontend `@tauri-apps/plugin-dialog`.
* **Backend:** `config.rs`, `vault.rs` (idempotent `bootstrap`; seed = 3 system taxonomies; `is_valid_vault`), commands `get_vault_state` / `initialize_vault`, Rust unit tests.
* **Frontend:** `lib/vault.ts`, `lib/FirstRun.svelte`, `+page.svelte` branch.

**Scope guard:** `.notula/` empty (index = DEV-484); `notes/` empty (sharding = DEV-481); `taxonomies.yaml` written but not parsed (loader = DEV-483); no frontmatter (DEV-482). No new ADR (within ADR 0003/0004).

**PR:** [https://github.com/Steve-vine/notula/pull/5](<https://github.com/Steve-vine/notula/pull/5>)

---

Linear DEV-480 · M1 — Foundation · created 2026-06-19 · done 2026-06-19