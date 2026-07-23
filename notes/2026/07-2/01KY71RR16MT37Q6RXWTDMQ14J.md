---
id: 01KY71RR16MT37Q6RXWTDMQ14J
created: 2026-07-23T08:34:12.134132Z
updated: 2026-07-23T12:24:57.272302Z
type: task
title: API key management — core store + Settings → API tab
task_status: done
assignee: steve
comments:
- id: 01KY71RZ75YSVNTFJH49Q2ASPC
  author: Steve Vine
  at: 2026-07-23T08:34:19.492871Z
  text: |-
    Steve Vine · 2026-07-07:

    ## Done — built and tested

    **What was done**
    - New `notuvia-core::api_keys` module: key records (`name`, `prefix`, SHA-256 `hash`, `created_at`, `last_used_at`) in `api_keys.json` in the OS app-config dir. Generation is `ntv_` + 32 random bytes base64url (via the same OS RNG the crypto module uses); the plaintext exists only in the create response. Verification hashes the presented key, compares digests constant-time, scans the whole list without early exit, and bumps `last_used_at`.
    - Tauri commands `list_api_keys` / `create_api_key` / `revoke_api_key`; the list returns metadata only — hashes never reach the frontend.
    - New Settings → **API** tab: create-with-name (Enter or button), one-time key reveal with copy button and "you won't see this again" note, key list (name, `ntv_xxxxxxxx…` fingerprint, created, last used/never), two-click revoke that disarms on mouse-leave.

    **Decisions made on the fly**
    - Key ids are ULIDs (uppercase canonical, matching note-id house style); `revoke` on an unknown id is an error so the UI can't believe it revoked something it didn't.
    - Constant-time comparison is a small local XOR fold over the fixed-length digests rather than a new `subtle` dependency.
    - The key list stores/loads via free functions over the config dir (same shape as `config.rs`) — no runtime state, so DEV-894's server can read it directly.

    **Problems encountered** — none.

    **Testing** — 6 new unit tests (round-trip, plaintext never on disk, verify accept/reject/bump, revoke, uniqueness); full workspace green (229 core, 16 + 2 MCP); svelte-check and frontend build clean.

    PR: [#219](https://github.com/Steve-vine/notuvia/pull/219)
label: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 240
sprint: s70xwrb
---
Foundation for the embedded HTTP API (ADR 0031, DEV-889): create, list, and revoke API keys from the app, stored securely on this machine.

## Scope

**Core (**`notuvia-core`**)**

- [ ] API key model: `name`, key `prefix` (first ~8 chars, for identification), SHA-256 `hash`, `created_at`, `last_used_at`
- [ ] Persist keys in `api_keys.json` in the OS app-config dir (alongside `config.json`) — **never in the vault**, so secrets can't ride git-sync (ADR 0013)
- [ ] Generate: cryptographically random key (e.g. `ntv_` + 32 random bytes base62); return plaintext once, store only the hash
- [ ] Verify: constant-time hash comparison; bump `last_used_at`
- [ ] Revoke: remove by id
- [ ] Unit tests for generate/verify/revoke/persistence round-trip

**App (Tauri commands + Settings UI)**

- [ ] Tauri commands: `list_api_keys`, `create_api_key(name)`, `revoke_api_key(id)`
- [ ] New **Settings → API** tab in `src/lib/Settings.svelte`: key list (name, prefix, created, last used), create-with-name flow showing the full key **once** with a copy button and a "you won't see this again" note, revoke with confirm

## Out of scope

* The HTTP server itself and its enable/port/bind settings — that's the server scaffold brief, which extends this tab.

## Definition of done

Keys can be created, copied, listed, and revoked from Settings; only hashes are at rest; core logic is unit-tested.

---

Linear DEV-893 · API Server · created 2026-07-07 · done 2026-07-07