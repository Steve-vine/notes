---
id: 01KY71Q5DHQZ8ZAQHN1119N2B6
created: 2026-07-23T08:33:20.305979Z
updated: 2026-07-23T11:03:35.855691Z
type: task
title: Create an API
task_status: done
comments:
- id: 01KY71QEETZGCMN1JH8MB6XZKR
  author: Steve Vine
  at: 2026-07-23T08:33:29.562562Z
  text: |-
    Steve Vine · 2026-07-07:

    ## Done — planning + ADR

    **What was done**
    - Researched the codebase: the MCP sidecar's 14 tools are thin wrappers over `notuvia-core::VaultRuntime` (a clean layer an HTTP server can reuse directly); the app has no listening socket or secret storage today; ADR 0030 had explicitly left an embedded HTTP server open as a future additive layer.
    - Agreed the architecture with Steve: **embedded axum server in the Tauri app** (over a standalone binary), **localhost by default with LAN opt-in**, bearer API keys created in Settings and stored hashed in the app-config dir.
    - Recorded it as **ADR 0031** — PR [#218](https://github.com/Steve-vine/notuvia/pull/218).
    - Created the implementation issues in this milestone, dependency-chained for sequencing (not stacking):
      - **DEV-893** — API key management (core store + Settings → API tab)
      - **DEV-894** — embedded HTTP server scaffold: lifecycle, settings, bearer auth *(blocked by 893)*
      - **DEV-895** — read endpoints: search, get note, list taxonomies *(blocked by 894)*
      - **DEV-896** — note write endpoints: create/update/delete *(blocked by 895)*
      - **DEV-897** — sprint, comment & dependency endpoints *(blocked by 896)*
      - **DEV-898** — taxonomy write endpoints *(blocked by 894, parallel-eligible but sequence per ways-of-working)*
      - **DEV-899** — API docs + client examples *(blocked by 896/897/898)*

    **Decisions made on the fly**
    - Default port **6688** ("NOTU" on a keypad), configurable.
    - A key is required even on localhost — anything on the machine can reach an open port, the exact concern ADR 0030 raised about this option.
    - Encrypted bodies stay sealed over the API (parity with MCP) even though the embedded server could reach the app's session keys — a leaked API key should never expose sealed content. Opening that up would be a new ADR.
    - Keys hashed (SHA-256) in `api_keys.json` next to `config.json` — kept out of the vault so secrets can't ride git-sync.

    **Problems encountered** — none; research confirmed no existing HTTP/token infrastructure to reconcile with.
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 236
sprint: s70xwrb
label: null
---
Create an API to allow functions to be completed via remote from other apps.  This will also include the capability to create an API key in the app settings.  Create the Issues required to do this in this milestone.

The same functions should exist as already exist in the MCP.

---

## Agreed plan (2026-07-07)

**Architecture (agreed with Steve, recorded as ADR 0031):** an **embedded axum HTTP server inside the running Tauri app** — ADR 0030's "Option B" arriving as the anticipated additive layer. It shares the app's live `VaultRuntime` (single writer, no extra process lifecycle), which matches "API key created in app settings". The stdio MCP sidecar remains the app-closed path for agents.

**Exposure:** bind `127.0.0.1` by default; a settings opt-in to bind on the LAN for other devices. Bearer API-key auth required either way. Keys are generated in a new Settings → API tab, shown once, and stored **hashed** in the app-config dir (never in the vault — secrets must not ride git-sync).

**Surface:** REST/JSON endpoints mirroring all 14 MCP tools (search/get/create/update/delete notes, list/create taxonomies + value add/update, project sprints, comments add/update/remove, blocked-by). Encrypted note bodies stay sealed, exactly as over MCP (ADR 0030).

**Deliverables of this issue:**

- [X] Research + options proposal (embedded vs standalone), agreed with Steve
- [X] ADR 0031 — embedded HTTP API server ([PR #218](<https://github.com/Steve-vine/notuvia/pull/218>))
- [X] Implementation issues created in this milestone with dependencies set (DEV-893 → DEV-899)

---

Linear DEV-889 · API Server · created 2026-07-07 · done 2026-07-07