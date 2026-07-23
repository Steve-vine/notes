---
id: 01KY71SCTKPYY8XQYXEYKQEXNM
created: 2026-07-23T08:34:33.427213Z
updated: 2026-07-23T08:34:33.427213Z
type: task
title: Embedded HTTP server scaffold — lifecycle, settings, bearer auth
imported_from: linear
assignee: steve
task_status: done
label: brief
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 241
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