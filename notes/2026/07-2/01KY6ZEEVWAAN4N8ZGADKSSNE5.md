---
id: 01KY6ZEEVWAAN4N8ZGADKSSNE5
created: 2026-07-23T07:53:37.91609Z
updated: 2026-07-23T11:03:35.172935Z
type: task
title: Render embeds & attachment links in the read view
imported_from: linear
task_status: done
assignee: steve
comments:
- id: 01KY6ZES62KM81NWBJEXD94JYE
  author: Steve Vine
  at: 2026-07-23T07:53:48.482564Z
  text: |-
    Steve Vine · 2026-06-26:

    Built and opened [PR #87](https://github.com/Steve-vine/notula/pull/87). Branch `steve/dev-649-render-embeds-attachment-links-in-the-read-view`.

    **Checklist — all done:**
    - ✅ `markdown.ts` rewrites attachment references to the `notula-attachment://` URL (marked `image`/`link` overrides, injected `convertFileSrc` builder).
    - ✅ Image references render inline `<img class="note-attachment">`.
    - ✅ Non-image references → link opened in the OS default app via a new `open_attachment` command (opener plugin), not a WebView nav.
    - ✅ DOMPurify allowlist — lazy `uponSanitizeAttribute` hook force-keeps the custom scheme.
    - ✅ Broken/missing reference → capture-phase `error` listener swaps the failed image for a `⚠ missing attachment` caption.

    **Decisions on the fly:**
    1. **Rewrite factored into pure helpers** (`isAttachmentRef` / `attachmentImageHtml` / `attachmentLinkHtml`) and unit-tested directly — `renderMarkdown` can't be unit-tested because DOMPurify needs a `window` the node test env lacks (same constraint the existing markdown tests work around).
    2. **DOMPurify hook registered lazily** on first render, not at import — the node test env has no DOM, so a top-level `addHook` threw on import.
    3. **`open_attachment` resolves + opens server-side** so the absolute fs path never reaches the frontend; reuses the DEV-648 traversal guard.

    **CI:** `cargo fmt --check`, `clippy -D warnings`, `cargo test` (117 ✓), `npm run check` (0 errors), `npm test` (64 ✓, +6 new), `npm run build` — green. Skipped the release `tauri build` bundle. (A watcher timing test flaked once then passed on re-run — pre-existing, unrelated to this change.)

    **⚠️ Manual verify needed before merge (UI brief).** The editor-attach path is DEV-650, so until that lands you'll verify by hand:
    1. Pick any note, note its id (the sharded filename / `display_id`), and drop an image into `attachments/<note-id>/pic.png` in the vault.
    2. Add `![a picture](attachments/<note-id>/pic.png)` to the note body and save.
    3. Open it in **read mode** → the image should render inline. Add `[the file](attachments/<note-id>/pic.png)` too and click it → should open in the OS default app. Point a reference at a non-existent file → should show the `⚠ missing attachment` caption.

    Moving to In Review for your check + merge call. DEV-650 (editor attach) and DEV-651 (import/export) branch off `main` once this lands.
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 97
sprint: sy430a6
---
Make attached files actually show up when reading a note: images inline, everything else as a clickable link. Consumes the reference form + protocol from Brief 1 (DEV-648) per ADR 0015.

## Checklist

- [ ] In `src/lib/markdown.ts`, rewrite attachment references in the rendered output to the custom protocol URL (per ADR 0015's reference/rewrite rule)
- [ ] Image references (`![](...)`) render inline via `<img>`
- [ ] Non-image references (`[name](...)`) render as a link that opens the file with the OS default app via `tauri-plugin-opener` (not a navigation in the WebView)
- [ ] Extend the DOMPurify allowlist so the custom scheme survives sanitisation (currently strips unknown protocols)
- [ ] Sensible handling of a missing/broken reference (e.g. file deleted) — no crash, a visible broken-state

## Done when

- [ ] A note body referencing an image shows it inline in read mode; a referenced PDF/other opens externally on click
- [ ] CI green (verbatim CI commands run locally), PR opened

---

Linear DEV-649 · M12 - Attachments · created 2026-06-25 · done 2026-06-26