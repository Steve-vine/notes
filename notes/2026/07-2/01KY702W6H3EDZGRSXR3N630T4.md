---
id: 01KY702W6H3EDZGRSXR3N630T4
created: 2026-07-23T08:04:46.929931Z
updated: 2026-07-23T09:08:57.866008Z
type: task
title: Bundle identifier + app-config & default vault-path migration
number: 134
priority: high
task_status: done
label: chore
assignee: steve
project: 01KY6W9951TW0904DT0GGJVGE7
---
Highest-risk part of the rebrand: change the macOS bundle identifier and the default vault path, with auto-migration so existing data and OS-managed state carry over. Follows the migration policy in the ADR (DEV-734).

## Bundle identifier

* `src-tauri/tauri.conf.json` — `identifier: "uk.stevevine.notula"` → `"uk.stevevine.notuvia"`.
* **Risk:** macOS uses the identifier to locate app-support / preferences / keychain / sandbox container. Changing it makes the OS treat this as a brand-new app — the saved config (which remembers the vault path) would be lost and the app would fall back to first-run.

## Default vault path

* `src-tauri/src/vault.rs` (~5/11) — `home.join("Notula")` → `home.join("Notuvia")`. **This is where real notes live** — must not blindly point elsewhere and orphan them.

## Migration (one-time, idempotent, best-effort on first run)

* **App config dir:** if the new bundle-id config dir is empty but the old `uk.stevevine.notula` config dir exists, copy it across so the saved vault path (and any other app config) survives — the app keeps pointing at the user's actual vault.
* **Default vault folder:** if config points at no vault and `~/Notula` exists while `~/Notuvia` doesn't, migrate (move, or adopt `~/Notula` in config). Don't move a folder the user explicitly configured elsewhere.
* Guard every step so re-running is safe and a missing old path is a no-op.

## Done when

* Upgrading an existing install keeps using the same notes with no first-run prompt and no lost config.
* A clean install defaults to `~/Notuvia` under the new identifier.
* Migration is verified idempotent (second launch does nothing).

---

Linear DEV-739 · Rebrand · created 2026-06-30 · done 2026-06-30