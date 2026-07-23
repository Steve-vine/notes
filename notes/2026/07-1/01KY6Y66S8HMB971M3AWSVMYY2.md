---
id: 01KY6Y66S8HMB971M3AWSVMYY2
created: 2026-07-23T07:31:38.920064Z
updated: 2026-07-23T11:00:30.425505Z
type: task
title: Capture window shell (Type, save/cancel, tray/hotkey)
assignee: steve
imported_from: linear
task_status: done
comments:
- id: 01KY6Y6G95ZDFCJBVE2HKYKQCR
  author: Steve Vine
  at: 2026-07-23T07:31:48.644695Z
  text: |-
    Steve Vine · 2026-06-20:

    **Done building — in review.**

    **What was done**
    - **Backend (`lib.rs`):** `open_capture_window` builds/focuses a second window (label `capture`, ~480×380) loading the shared `index.html`; tray **New note** + **Option+Space** now open it (placeholders replaced). Close-to-tray guards `window.label() == "main"` so the capture window closes normally.
    - **Capabilities:** `capture` added to windows + `core:window` close/show/set-focus perms.
    - **Frontend:** `lib/window.ts` (`currentLabel`); `+page.svelte` branches on label → `lib/Capture.svelte` (Title, body, Type default Memo; Save→`save_note`+close, Cancel→close, Open-in-UI→save+show main+close; errors shown inline).

    **Design:** windows distinguished by **Tauri label on a shared entry**, not SvelteKit routing (avoids SPA-fallback friction).

    **Verification** — `npm run check` (0/0), fmt, clippy `-D warnings` (exit 0), `cargo test` (32 pass), `npm run tauri build`; built app launches cleanly. **The interactive flow needs your manual sign-off** — I can't drive the tray/hotkey/window (assistive-access blocked).

    **Please verify** via `npm run tauri:dev`: Option+Space / tray New note opens capture → type + Type + **Save** writes a note file (and indexes it) → **Cancel** discards → **Open in UI** saves + shows main → closing **main** keeps the app resident in the tray.

    **Scope guard:** Type only (selectors = DEV-511); Open-in-UI shows the M1 placeholder (real hand-off = M4). No new ADR.

    **PR:** https://github.com/Steve-vine/notula/pull/15 · commit `913c950`
    Holding the merge for your sign-off since I couldn't exercise the UI.
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 15
sprint: sd0ytgj
label: null
---
The lightweight single-note capture window (`brief/ui.md`), openable without the full UI.

**Checklist**

- [ ] A small standalone capture window (separate Tauri window/route), openable independently of the main UI
- [ ] Open it from the tray **New note** item and the **Option+Space** global hotkey (replace the main-window placeholders DEV-479 left)
- [ ] Form: **Title**, **body** (markdown text block), **Type** selector (Memo/Task/Project, default Memo)
- [ ] **Save** (calls `save_note`, closes), **Cancel** (discards/closes), **Open in UI** (saves, then shows/focuses the main window — the M1 placeholder for now; real hand-off in M4)
- [ ] `created` generated on save, not entered. Saveable with only Type (defaults to Memo)

**Done when:** the hotkey/tray opens the capture window; entering a note + Type and Save persists it (via `save_note`); Cancel discards; Open-in-UI saves and shows the main window.

**Scope:** scope-driven taxonomy selectors are the next brief; this ships Type only. Depends on DEV-509.

---

Linear DEV-510 · M3 — Capture window · created 2026-06-19 · done 2026-06-20