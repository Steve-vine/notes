---
id: 01KY71SCTKPYY8XQYXEYKQEXNM
created: 2026-07-23T08:34:33.427213Z
updated: 2026-07-23T08:34:42.968684Z
type: task
title: Embedded HTTP server scaffold — lifecycle, settings, bearer auth
imported_from: linear
assignee: steve
task_status: done
label: brief
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 241
comments:
- id: 01KY71SP4RGRS259SZ04FSXMW9
  author: Steve Vine
  at: 2026-07-23T08:34:42.968375Z
  text: |-
    Steve Vine · 2026-07-07:

    ## Done — built and tested

    **What was done**
    - `src-tauri/src/api_server.rs`: the axum chassis on Tauri's tokio runtime. `GET /health` unauthenticated (app + version); every other route behind bearer-key middleware verifying against the DEV-893 store (on the blocking pool, constant-time, bumps last-used). `ApiError` gives the uniform `{"error": …}` envelope with 400/401/404/409/500 constructors for the endpoint briefs.
    - Lifecycle: the listener binds **synchronously**, so a taken port fails into a recorded error that Settings displays — the app keeps running either way. Enabled at launch per config; `set_api_server_config` persists changes and restarts the server live via graceful shutdown (oneshot channel), no app restart. Quit needs no special handling — dropping the shutdown sender stops the serve task.
    - `AppConfig` gains `api_enabled` (default false), `api_port` (default 6688), `api_lan` (default false); serde defaults keep existing config.json files valid.
    - Settings → API tab server section: enable toggle, status line (`Running on http://127.0.0.1:6688` / Stopped / error in red), port field applying on Enter/blur with range validation, LAN toggle with a plain-English warning about network access.

    **Decisions made on the fly**
    - The router builder is Tauri-free (takes just the config dir), so tests drive it with `tower::ServiceExt::oneshot` — no app harness needed.
    - Key verification runs in `spawn_blocking` so the per-request file read never stalls the async runtime.
    - The unused `ApiError` constructors carry an `#[allow(dead_code)]` with a comment — they're this brief's deliverable ("for endpoint briefs to reuse") and DEV-895/896 consume them.

    **Problems encountered** — none.

    **Testing** — 4 router tests (health open; missing/wrong key → 401; valid key passes to the 404 fallback and stamps last-used). Full workspace green; clippy `-D warnings` clean; svelte-check clean. The DoD's live `curl /health` + toggle pass needs the running app — flagged for review.

    PR: [#220](https://github.com/Steve-vine/notuvia/pull/220)
---
The axum HTTP server inside the Tauri app (ADR 0031, DEV-889): lifecycle, configuration, and authentication — the chassis every endpoint brief bolts onto.

## Scope

**Server**

- [ ] `axum` server task in the Tauri app sharing the app's live `VaultRuntime` (`Arc`/state injection; tokio runtime already present via Tauri)
- [ ] Lifecycle: starts on app launch when enabled, stops on disable/quit; toggling the setting starts/stops it live
- [ ] `GET /health` (unauthenticated) returning app/API version
- [ ] Bearer-token middleware on everything else: `Authorization: Bearer <key>` verified against the DEV-893 key store (constant-time, bumps last-used); `401` JSON error otherwise
- [ ] Consistent JSON error envelope + status mapping (400 validation / 404 unknown id / 409 conflict / 500) for endpoint briefs to reuse
- [ ] Graceful bind-failure handling (port in use → surfaced in settings, app keeps running)

**Config + Settings UI**

- [ ] `AppConfig` (config.json) gains: `api_enabled: bool` (default false), `api_port: u16` (default **6688** — "NOTU" on a keypad), `api_lan: bool` (default false → bind `127.0.0.1`; true → `0.0.0.0`)
- [ ] Settings → API tab (from DEV-893) gains: enable toggle, port field, LAN-exposure toggle with a clear warning, live status line (running on `http://127.0.0.1:6688` / stopped / port-in-use error)

## Out of scope

* All vault endpoints — they follow in the read/write endpoint briefs.

## Definition of done

With the toggle on, `curl /health` works, any other path returns 401 without a valid key and 404 with one; toggle/port/LAN changes take effect without restarting the app.

---

Linear DEV-894 · API Server · created 2026-07-07 · done 2026-07-07