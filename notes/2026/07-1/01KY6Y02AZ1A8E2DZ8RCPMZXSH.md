---
id: 01KY6Y02AZ1A8E2DZ8RCPMZXSH
created: 2026-07-23T07:28:17.759722Z
updated: 2026-07-23T11:04:51.488201Z
type: task
title: Tauri app skeleton
task_status: done
assignee: steve
imported_from: linear
comments:
- id: 01KY6Y0CQZQBWQPYKZABWFZV3M
  author: Steve Vine
  at: 2026-07-23T07:28:28.415114Z
  text: |-
    Steve Vine · 2026-06-19:

    **Done building — in review.**

    **What was done**
    - Scaffolded a Tauri v2 shell at the repo root: **SvelteKit** (SPA, SSR off) frontend + Rust backend, identity `Notula` / `uk.stevevine.notula`. Trimmed the template's greet/IPC demo to a minimal empty Notula window.
    - **ADR 0008** (`decisions/0008-svelte-frontend.md`) captures the Svelte/SvelteKit choice + rationale, resolving the open question ADR 0002 deferred. Updated `brief/ui.md` and `CLAUDE.md` to point at it; ADR 0002 left unchanged (append-only).
    - **CI** (`.github/workflows/ci.yml`) upgraded from the DEV-476 placeholders to real jobs on `macos-latest`: **build** (`npm run tauri build` → uploads `notula-macos` bundle artefact), **typecheck** (`svelte-check` + `cargo check`), **lint** (`cargo fmt --check` + `clippy -D warnings`), **test** (`cargo test`).
    - `.gitignore` extended for SvelteKit/Vite; `Cargo.lock` committed (binary app).

    **Decisions / things to know at review**
    - Template is **SvelteKit** (not bare Svelte+Vite) — the canonical Tauri+Svelte setup, static adapter in SPA mode. ADR 0008 states this precisely.
    - Script contract: `npm run dev`/`build` = Vite/SvelteKit (Tauri before-commands); **`npm run tauri:dev` / `tauri:build`** = the app. `dev` couldn't be remapped to `tauri dev` (would recurse via beforeDevCommand).
    - CI runs **macOS-only** for now; Linux/Windows runners are a later add (ADR 0002 cross-platform concern). Kept the `tauri-plugin-opener` the template ships; `serde`/`serde_json` deps left in for M2.

    **Verification**
    - `npm run check`: 0 errors. Local `npm run tauri build` produced `Notula.app` + `Notula_0.1.0_aarch64.dmg`; launching the app starts the process cleanly. Automated window introspection was blocked by macOS assistive-access, so **visual sign-off that the window renders is yours**.
    - CI on PR #3 is the authoritative artefact check (running now).

    **PR:** https://github.com/Steve-vine/notula/pull/3
    **Branch:** `brief-478-tauri-app-skeleton` · commit `ef4ae46`
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 3
sprint: s87b0qx
---
Scaffold the Tauri application so there's a runnable shell to build on (ADR 0002).

**Checklist**

- [X] `tauri init` + Rust backend crate structure
- [X] Choose & scaffold the frontend inside the WebView — **capture the frontend-framework choice as its own ADR** (0002 left it open) → ADR 0008 (Svelte/SvelteKit)
- [X] `dev` script (hot-reload) and `build` script (bundled app) → `npm run tauri:dev` / `tauri:build`
- [X] App launches to an empty window on macOS (local build runs; visual sign-off pending review)
- [X] CI builds the app on push/PR → macOS `tauri build` + artefact

**Done when:** the dev command opens a window and CI produces a build artefact.

---

### Agreed approach (planned 2026-06-19)

* **Frontend framework: Svelte + Vite + TypeScript** (template is **SvelteKit**, SPA/static adapter — the canonical Tauri+Svelte setup) — captured as **ADR 0008**.
* **Shell:** Tauri **v2**. **Package manager:** npm. **Rust:** stable via rustup.
* Scaffold at repo root, identity `Notula` / `uk.stevevine.notula`, minimal empty window (tray/capture land in DEV-479/M3).
* **Scripts:** `npm run tauri:dev` / `npm run tauri:build` (`dev`/`build` stay as Vite, called by Tauri before-commands).
* **CI:** real jobs on `macos-latest` — build (+ artefact), typecheck (svelte-check + cargo check), lint (cargo fmt/clippy), test (cargo test).
* **Docs:** `decisions/0008-svelte-frontend.md`; `brief/ui.md` + `CLAUDE.md` point at it (ADR 0002 unchanged — append-only).

**PR:** [https://github.com/Steve-vine/notula/pull/3](<https://github.com/Steve-vine/notula/pull/3>)

---

Linear DEV-478 · M1 — Foundation · created 2026-06-19 · done 2026-06-19