---
id: 01KY6YN0E4V6HRQQX9E2JSQBSJ
created: 2026-07-23T07:39:43.940037Z
updated: 2026-07-23T11:00:28.321351Z
type: task
title: 'Taxonomy scope: allow any combination of Types'
imported_from: null
comments:
- id: 01KY6YN5W63JN9Q07WPW7GQQFZ
  author: Steve Vine
  at: 2026-07-23T07:39:49.510459Z
  text: |-
    Steve Vine · 2026-06-21:

    PR: https://github.com/Steve-vine/notula/pull/39 — In Review.

    A taxonomy can now apply to **any combination of Types**. `Scope` generalised to `Scope::Types(Vec<NoteType>)` (Any kept); serialises `Any`→`"any"` and a set→a YAML sequence; deserialise stays back-compatible with `"any"` / a single type string / a sequence. `applicable_for` uses set membership; empty set rejected. Frontend: `scope` is `"any" | string[]`, pure `scopeChecks`/`checksToScope`/`scopeLabel` helpers (all-or-none ⇒ "any"), and the "Applies to" select is now **Memo/Task/Project checkboxes**.

    Gates green: 47 cargo tests (multi-Type round-trip + applicable + legacy back-compat), 47 vitest, `npm run check` clean, `clippy -D warnings`, `npm run tauri build`.

    Holding for your manual sign-off + CI before merge.
- id: 01KY6YNBAX5NFB0MD94R2E8ZHQ
  author: Steve Vine
  at: 2026-07-23T07:39:55.100949Z
  text: |-
    Steve Vine · 2026-06-21:

    Replaced the checkboxes with a **check-mark dropdown** (PR #39), like the strict multi-select. The confusing behaviour was the "deselect all ⇒ any" collapse re-ticking every box; the dropdown has an explicit **Any note** row plus Memo/Task/Project, each toggling independently. Removing the last Type falls back to Any — but now that's shown clearly (the Any row ticks) rather than the boxes flipping. Rendered `position: fixed` so it isn't clipped by the modal. `npm run check`, 47 vitest, `npm run tauri build` green.
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 45
sprint: sdge8g4
---
Today a taxonomy's **scope** ("Applies to") is **any** *or* exactly **one** Type (ADR 0005 / `Scope::Type(NoteType)`). Steve wants to select **any combination** (e.g. Memo + Task).

This is a **data-model change** to `Scope`, so kept separate from the DEV-549 UI:

**Checklist**

- [ ] `taxonomy.rs`: `Scope::Type(NoteType)` → a set of Types (e.g. `Scope::Types(Vec<NoteType>)`), `Any` retained. Serialize `Any` as `"any"` and `Types` as a YAML **sequence**; deserialize accepting `"any"`, a single type string (back-compat), or a sequence. Update `applicable_for` (`Types` ⇒ contains the note type) + `system_taxonomies` + tests.
- [ ] Validate the scope set is non-empty (or treat all-Types as `any`).
- [ ] `taxonomy.ts`: `scope` becomes `"any" | string[]`.
- [ ] Management UI (`TaxonomySettings`): replace the single "Applies to" select with **Memo / Task / Project checkboxes** (all/none ⇒ `any`).

**Done when:** a user taxonomy can apply to any chosen combination of Types, persisted and reflected in the capture/editor pickers.

**Note:** generalises ADR 0005's scope ("any or one Type"); flag if it warrants an ADR amendment.

---

Linear DEV-554 · M6 — Taxonomy · created 2026-06-21 · done 2026-06-21