---
id: 01KY6ZK7ZZ1J4ADYR4GFCR4TH9
created: 2026-07-23T07:56:14.719888Z
updated: 2026-07-23T07:56:22.609409Z
type: task
title: Attachment with a space in its filename fails to embed
label: bug
assignee: steve
task_status: done
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 103
comments:
- id: 01KY6ZKFPHSAVEG66M83X8D37A
  author: Steve Vine
  at: 2026-07-23T07:56:22.609003Z
  text: |-
    Steve Vine · 2026-06-27:

    Fixed in [PR #92](https://github.com/Steve-vine/notula/pull/92). Branch `steve/dev-668-attachment-filename-spaces`.

    **Diagnosis confirmed:** the copy to disk always worked — the failure was the embedded reference. `my file.png` went into the body as `![pic](attachments/<id>/my file.png)`, and a markdown destination can't hold a space, so the parser (and `references_in`) truncated it at the space → broken embed + broken round-trip.

    **Fix:** `sanitize_name` in `attachment.rs`, applied centrally in `place()` (covers picker, paste, and drop): whitespace and `()<>"'` → `-`, extension preserved (`my file.png` → `my-file.png`). The editor still shows the **original filename** as the link text; only the on-disk file + reference are sanitised.

    **On the fly:** also sanitises `()<>"'` (not just spaces) since those break the markdown destination / the reference scanner too. Documented as a minor refinement of ADR 0015's "original filename kept" (doc comments updated). Existing space-containing references aren't migrated — fix is forward-only.

    **CI:** `cargo fmt --check`, `clippy -D warnings`, `cargo test` (134 ✓, +2), `npm run check` (0 errors), `npm test`, `npm run build` — green.

    Quick manual check when convenient: attach a file named with a space (and one with parens) — it should embed and render. Moving to In Review for your merge call.
---
**Reported by Steve.** Attaching a file whose name contains a space doesn't work — the attachment appears to fail.

**Root cause:** the file *does* copy to `attachments/<id>/<name>` fine, but the reference is embedded in the note body as a **markdown link destination** — `![pic](attachments/<id>/my file.png)`. An unbracketed markdown destination can't contain a space, so the parser truncates it at the space (`attachments/<id>/my`), and the embed never resolves. The same space also truncates `attachment::references_in`, so import/export and on-save prune mis-handle the reference too.

**Fix:** sanitise markdown-breaking characters (whitespace and `()<>"'`) out of the **stored filename** (and therefore the reference) at store time — `my file.png` → `my-file.png`. The displayed link text keeps the original name; only the on-disk file + reference are sanitised. This keeps the reference valid as a destination and scannable by `references_in`, end to end (embed, import/export, prune). A minor, documented refinement of ADR 0015's "original filename kept".

Pre-existing attachments already embedded with spaces aren't migrated; the fix prevents new ones.

## Done when

- [ ] A file with a space (and `()` etc.) in its name attaches, embeds, and renders in read mode
- [ ] Round-trips through export/import; on-save prune keeps it
- [ ] CI green, PR opened

---

Linear DEV-668 · M12 - Attachments · created 2026-06-27 · done 2026-06-27