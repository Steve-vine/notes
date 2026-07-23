---
id: 01KY6Z8DQT2VTRPA57V3EXNJCD
created: 2026-07-23T07:50:20.154019Z
updated: 2026-07-23T09:08:57.482466Z
type: task
title: ADR 0014 — Import/export mapping rules
assignee: steve
label: chore
comments:
- id: 01KY6Z8MGNCE622VCGERFAMRD3
  author: Steve Vine
  at: 2026-07-23T07:50:27.093245Z
  text: |-
    Steve Vine · 2026-06-25:

    Done — ADR written and PR opened: **[#80](https://github.com/Steve-vine/notula/pull/80)** (branch `steve/dev-638-adr-0014-importexport-mapping-rules`).

    **What landed:** `decisions/0014-import-export-mapping-rules.md`, Status: Accepted. Captures every decision from planning — verbatim foreign-frontmatter preservation (inert, not indexed), folder flattening, core-field derivation that prefers existing values, id-collision → skip, and full round-trippable export scoped to the current tab. Out-of-scope items (foreign-key→taxonomy mapping, attachments) recorded as future work.

    **Decisions made on the fly while writing:**
    - **`updated` on import** (left open in the issue): settled as *preserve existing valid value, else file mtime, else now* — symmetric with `created` and faithful to a clean round-trip (a relocated note wasn't really modified).
    - **CLAUDE.md "Locked" list**: not updated. That list is for *stack* locks; ADR 0014 is behavioural rules, so an entry there would be out of place. The ADR stands on its own in `decisions/`.

    Docs-only change — touches no Rust/TS, so the CI gates (check/build/clippy/test) are unaffected.
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 89
---
Record the rules that govern how markdown moves in and out of a Notula vault. This shapes all three M11 briefs, so it lands first (knowledge before work).

Write `decisions/0014-import-export-mapping-rules.md` in the standard Date / Status / Context / Decision / Consequences format, capturing the decisions already made in planning:

## Decisions to record

* **Foreign frontmatter is preserved verbatim.** Unknown frontmatter keys (e.g. Obsidian `tags`, `aliases`) are kept untouched on import. They are *not* indexed as taxonomies, so they don't appear in browse/pickers — accepted trade-off. (`Note::parse()` is already order-preserving, so this is structurally cheap.)
* **Folder imports flatten.** Subfolder structure is discarded; every file becomes a flat note. Consistent with Notula's "no folders, taxonomies instead" model (ADR 0005, `brief/ui.md`).
* **Export writes full Notula frontmatter** (round-trip). Export → import is lossless. No plain-markdown/portable format toggle.
* **Core-field derivation on import:**
  * `id` — keep an existing valid Notula id; otherwise mint a fresh ULID.
  * `created` — keep existing; else use file mtime; else now.
  * `updated` — set to now (or keep existing on a clean round-trip — settle in the ADR).
  * `type` — default `memo` if absent or invalid.
  * `title` — frontmatter `title` → first `# H1` in body → filename stem.
* **Id-collision policy: skip, keep existing.** If an incoming file carries a Notula id that already exists in the vault, skip it and report it; never overwrite. Re-importing a backup is idempotent and non-destructive.
* **Bulk import = one git commit.** The existing 4s auto-commit debounce (`gitsync.rs`) coalesces a folder import into a single commit; no batching infra is added.

## Out of scope (note as future work, not decided here)

* Mapping foreign `tags` onto a browsable taxonomy (the richer import option not chosen).
* Attachment / image-link rewriting on import/export (M12 territory).

## Done when

- [ ] `decisions/0014-import-export-mapping-rules.md` written and Accepted.
- [ ] Cross-references ADR 0005 (taxonomy model), 0009 (system taxonomy ownership), 0003/0004 (files + storage).
- [ ] CLAUDE.md "Locked" list updated if appropriate.

---

Linear DEV-638 · M11 - Import/Export capability · created 2026-06-25 · done 2026-06-25