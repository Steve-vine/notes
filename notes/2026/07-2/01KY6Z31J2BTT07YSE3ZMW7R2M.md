---
id: 01KY6Z31J2BTT07YSE3ZMW7R2M
created: 2026-07-23T07:47:23.843027Z
updated: 2026-07-23T11:00:29.782645Z
type: task
title: Detect git repo + enable git-sync mode toggle
task_status: done
comments:
- id: 01KY6Z38WX8YDZN45WXYQKWP0K
  author: Steve Vine
  at: 2026-07-23T07:47:31.357147Z
  text: |-
    Steve Vine · 2026-06-24:

    Done — PR opened: https://github.com/Steve-vine/notula/pull/74

    **What was done**
    - New `src-tauri/src/git.rs` module shelling out to the system `git` binary: `is_available`, `is_repo_root` (vault folder itself must be the work-tree root — a parent repo doesn't count, per ADR 0013), `has_origin`, `init`, `ensure_notula_ignored`.
    - Commands `git_sync_state`, `init_vault_git`, `set_git_sync`; `git_sync` flag added to app config.
    - Settings → Storage "Git sync" section adapting to state: install-git prompt / "Initialise git repo" button / enable toggle + origin-remote status.

    **Decisions made on the fly**
    - **Repo-root, not "inside a repo":** used `git rev-parse --show-toplevel` and required it to equal the vault path (canonicalised), so a vault sitting inside an unrelated parent repo doesn't falsely offer sync. Matches ADR 0013's "vault root is a repo".
    - **Flag reset on relocate:** `open_vault` now clears `git_sync` when switching vaults (the new folder may not be a repo); `git_sync_state` only reports `enabled` while the folder really is a repo, so it self-heals and survives restart.
    - **No capability/permission changes:** git runs via `std::process::Command` in the Rust backend (not the shell plugin), so nothing needed in `capabilities/`.

    **Verification** — verbatim CI gates green locally: `npm run check` (0 errors), `npm run build`, `npm test` (58), `cargo fmt --check`, `cargo clippy -D warnings`, `cargo test` (**77**, +4 new git tests). `npm run tauri build` left to CI.

    **Scope boundary** — this is detection + flag only. Actual git wiring is the next briefs: auto-commit/push (DEV-614), pull + conflict (DEV-615).

    Moving to In Review — merge call is yours.
imported_from: null
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 78
sprint: stkh502
label: null
---
Gate git-sync mode on the vault being a git repository and let the user opt in (ADR 0013).

Foundation for the rest of M10: detect the repo, expose the toggle, store the config, and keep the index out of git.

## Sub-steps

- [ ] Detect a git repo at the vault root (presence of `.git`); confirm a usable system `git` binary (surface a clear message if absent).
- [ ] Settings: show git-sync toggle only when the vault is a repo; offer to `git init` when it isn't.
- [ ] On enable: ensure `.notula/` is gitignored in the vault; detect whether an `origin` remote is configured (git mode works locally without one — push/pull just inactive).
- [ ] Persist git-mode on/off in app config.

## Definition of done

When the vault is a repo, the user can toggle git-sync on; `.notula/` is gitignored; remote presence is detected; state persists across restart.

---

Linear DEV-613 · M10 — Sync · created 2026-06-24 · done 2026-06-24