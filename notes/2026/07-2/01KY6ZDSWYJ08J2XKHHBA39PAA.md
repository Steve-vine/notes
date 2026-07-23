---
id: 01KY6ZDSWYJ08J2XKHHBA39PAA
created: 2026-07-23T07:53:16.446868Z
updated: 2026-07-23T07:53:26.826213Z
type: task
title: Store an attachment in the vault (backend + protocol)
imported_from: linear
label: brief
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 96
comments:
- id: 01KY6ZE41ANQQ5TSGATKFP0RSK
  author: Steve Vine
  at: 2026-07-23T07:53:26.825681Z
  text: |-
    Steve Vine · 2026-06-25:

    Built and opened [PR #86](https://github.com/Steve-vine/notula/pull/86). Branch `steve/dev-648-store-an-attachment-in-the-vault-backend-protocol`.

    **Checklist — all done:**
    - ✅ `attach_file(note_id, source_path)` command → copies into `attachments/<note-id>/<original-name>`, collision-suffixed, returns the vault-relative reference.
    - ✅ Folder created on demand; copy via temp-then-rename (mirrors `note::write_note`).
    - ✅ `notula-attachment://` custom protocol handler resolving against the **current** vault, with content-type.
    - ✅ Rides the auto-commit debounce (`git_touch`, ADR 0013).
    - ✅ Path-traversal guard — lexical (`.`/`..`/absolute/empty rejected) **plus** canonicalised containment for symlink escapes; only serves from `<vault>/attachments/`.

    **Decisions on the fly:**
    1. **Reference is a vault-relative path string, resolved by URL path**, not an opaque token — keeps the body greppable (ADR 0015). The protocol URL is `notula-attachment://…/attachments/<id>/<name>` and the handler decodes the path back to that reference.
    2. **Lock dropped before reading file bytes** — resolve (canonicalize) happens under the `AppState` lock, the read does not, so a large attachment can't block other commands.
    3. **No range-request support** — the handler returns the full body. Fine for v1 images/PDFs; video seeking would want HTTP range, a possible follow-up if it ever matters.
    4. **Added `percent-encoding`** (already transitively present) to decode filenames with spaces/unicode.

    **CI:** `cargo fmt --check`, `clippy -D warnings`, `cargo test` (117 ✓), `npm run check`, `npm test` (58 ✓), `npm run build` — all green locally. Skipped the full release `tauri build` bundle (recompiles the same debug-verified Rust; no bundle-config change).

    Moving to In Review for your merge call. DEV-649 (render) and DEV-650 (editor) both branch off `main` once this lands.
---
The backend foundation for M12: copy a file into the vault under a note and serve its bytes back to the WebView. Implements the storage layout and custom protocol from ADR 0015. Everything else in M12 builds on this.

## Checklist

- [ ] `attach_file(note_id, source_path)` Tauri command — copies the source into `attachments/<note-id>/<original-name>`, suffixing on name collision (ADR 0015), returns the in-body reference string
- [ ] Ensure `attachments/<note-id>/` is created on demand; atomic copy (write-temp-then-rename, mirroring `note::write_note`)
- [ ] Custom protocol handler (Rust) resolving a reference against the **current** (relocatable) vault path and streaming the file bytes, with correct content-type
- [ ] Rides the existing on-change auto-commit debounce (ADR 0013) so a new attachment is committed with no bespoke machinery — git-touch the copied file
- [ ] Reject / sanitise path traversal in references; only serve from within the active vault's `attachments/`

## Done when

- [ ] A file can be copied in via the command and its bytes fetched back through the protocol URL
- [ ] CI green (verbatim CI commands run locally), PR opened

---

Linear DEV-648 · M12 - Attachments · created 2026-06-25 · done 2026-06-25