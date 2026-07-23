---
id: 01KY6ZG6PG9WD9E2P2BGWK01KF
created: 2026-07-23T07:54:35.088413Z
updated: 2026-07-23T11:03:34.409122Z
type: task
title: Import/export attachment round-trip
comments:
- id: 01KY6ZGENHDKSM1EN1S8YH1NYM
  author: Steve Vine
  at: 2026-07-23T07:54:43.249092Z
  text: |-
    Steve Vine · 2026-06-26:

    Built and opened [PR #89](https://github.com/Steve-vine/notula/pull/89). Branch `steve/dev-651-importexport-attachment-round-trip`.

    **Checklist — all done:**
    - ✅ **Export** copies referenced attachments to `<dest>/attachments/<id>/<name>` (mirrors vault layout); references are already vault-relative so no rewrite needed. Count surfaced in the export notice.
    - ✅ **Import** copies referenced attachments into the vault under the note's id, **repointing the id segment** when the id is re-minted, so the reference resolves.
    - ✅ **Round-trip faithful + idempotent** — covered by a new test (export → import into a fresh vault: same id, resolvable bytes); honours the ADR 0014 skip-on-collision rule.
    - ✅ **Missing files non-fatal** — left as dangling references.

    **Decisions on the fly:**
    1. **"Reported" = the in-note visible caption** (DEV-649's ⚠ missing-attachment), not a new import-summary field — keeps the summary model unchanged and is genuinely user-visible. Say the word if you'd prefer an explicit summary entry.
    2. **Folder walk now skips `attachments/`** — otherwise a `.md` file someone attached would re-import as a separate note. Small behavioural change to import, flagged.
    3. **Hand-rolled reference scan, no `regex` dep.** Spaces/quotes in filenames truncate at the delimiter — the same limit the renderer already has (ADR 0015), not introduced here.

    **CI:** `cargo fmt --check`, `clippy -D warnings`, `cargo test` (124 ✓, +5), `npm run check` (0 errors), `npm test` (69 ✓), `npm run build` — green. Release bundle skipped.

    This one's backend with the core covered by round-trip tests, so no manual verify strictly needed — though a real export→import of a note with an image is a nice confidence check if you want one. Moving to In Review for your merge call. **DEV-652 (orphan cleanup)** is the last M12 brief.
imported_from: linear
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 99
sprint: sy430a6
---
Close the gap ADR 0014 left open: referenced attachments must travel with notes through import and export, so a round-trip stays faithful. Implements the import/export contract from ADR 0015 on top of the M11 import/export code (`import.rs`, `export_*` in `runtime.rs`).

## Checklist

- [ ] **Export:** when writing a note out, copy its referenced attachment files alongside it, and rewrite references so the exported set resolves on disk (define the on-disk export layout for attachments — consistent with the export filename-slug rule from ADR 0014)
- [ ] **Import:** bring referenced attachment files into the vault under the (kept-or-minted) note id's `attachments/<note-id>/` folder, and rewrite references to the canonical in-vault form (ADR 0015)
- [ ] Round-trip is faithful and idempotent: export → import restores the same note + attachments without duplication (honour the ADR 0014 skip-on-collision rule)
- [ ] Missing referenced files are reported, not fatal (mirror import's existing reporting)

## Done when

- [ ] Exporting then re-importing a note with an image + a file attachment reproduces it with working references
- [ ] CI green (verbatim CI commands run locally), PR opened

---

Linear DEV-651 · M12 - Attachments · created 2026-06-25 · done 2026-06-26