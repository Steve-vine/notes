---
id: 01KY6Y2GZEQQRYMXEGP7VK15F2
created: 2026-07-23T07:29:38.286373Z
updated: 2026-07-23T09:17:07.466321Z
type: task
title: Frontmatter schema & note (de)serialisation
comments:
- id: 01KY6Y2RV59J41WXKYMRKN90C3
  author: Steve Vine
  at: 2026-07-23T07:29:46.341309Z
  text: |-
    Steve Vine · 2026-06-19:

    **Done building — in review.**

    **What was done** — extended `src-tauri/src/note.rs`:
    - `NoteType` (memo/task/project) + `Note { id, frontmatter: Mapping, body, raw, dirty }`.
    - `parse` — splits `---` frontmatter / body, validates `id` + `type`, keeps every other key (taxonomy values, `project` link, unknowns) in an **order-preserving** YAML mapping.
    - **Format-preserving** `Display` — unchanged note echoes original bytes; canonical YAML only after a field changes (`set_field`/`set_body`, reserved core keys rejected).
    - Accessors `id`/`created`/`updated`/`note_type`/`field`/`body`; `load`/`save` reuse DEV-481 IO.
    - YAML via **serde_yaml_ng**.

    **Verification** — verbatim CI commands all pass: fmt, clippy `-D warnings`, `cargo test` (**13 pass**, 6 new), `npm run tauri build`. Tests: parse correctness on the data-model example, byte-stable round-trip (comment + extra key), lossless canonical re-emit (unknown key + multi taxonomy + `project` survive), `load`/`save` via tempdir vault, malformed-note errors. Backend-only — nothing interactive to sign off.

    **Scope guard:** taxonomy values not validated against definitions (loader = DEV-483); no index (DEV-484); no IPC/UI (capture = M3). No new ADR (implements ADR 0003).

    **PR:** https://github.com/Steve-vine/notula/pull/8 · commit `eee161a`
    Per your instruction I'll merge once CI is green.
task_status: done
label:
- brief
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 7
sprint: svnk3dy
---
Round-trip a note between disk and the in-memory model (ADR 0003, `brief/data-model.md`).

**Checklist**

- [X] Parse YAML frontmatter + markdown body
- [X] Model: id, created, updated, type, taxonomy values (single/list), relationship fields
- [X] Serialise back without losing unknown/extra keys (forward-compatible)
- [X] Round-trip test: read → write → byte-stable for unchanged notes

**Done when:** notes serialise and deserialise losslessly, including multi-value taxonomies and the `project` link.

---

### Agreed approach (planned 2026-06-19)

* **Round-trip: format-preserving** — `Note` keeps original raw text; unmodified note serialises byte-for-byte identical; canonical YAML only on change.
* **YAML:** `serde_yaml_ng` (order-preserving `Mapping`).
* Extended `src-tauri/src/note.rs`: `NoteType`, `Note`, `parse`, format-preserving `Display`, accessors, `set_field`/`set_body`, `load`/`save`. Timestamps kept as raw strings.
* **13 tests** (6 new): parse correctness, byte-stable round-trip, lossless canonical re-emit (unknown key + multi taxonomy + project), load/save via tempdir, error cases.

**Scope guard:** taxonomy values not validated vs definitions (loader = DEV-483); no index (DEV-484); no IPC/UI (capture = M3). No new ADR (implements ADR 0003).

**PR:** [https://github.com/Steve-vine/notula/pull/8](<https://github.com/Steve-vine/notula/pull/8>)

---

Linear DEV-482 · M2 — Storage & file handling · created 2026-06-19 · done 2026-06-19