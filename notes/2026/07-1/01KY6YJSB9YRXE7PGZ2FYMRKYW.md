---
id: 01KY6YJSB9YRXE7PGZ2FYMRKYW
created: 2026-07-23T07:38:31.145553Z
updated: 2026-07-23T12:24:59.665645Z
type: task
title: In-app taxonomy management UI
assignee: steve
comments:
- id: 01KY6YK2RSD7AKFYZ7R6QTG35S
  author: Steve Vine
  at: 2026-07-23T07:38:40.792976Z
  text: |-
    Steve Vine · 2026-06-21:

    PR: https://github.com/Steve-vine/notula/pull/37 — In Review.

    A **Taxonomies** tab in the Settings modal: list/create/edit/delete user taxonomies + value pools (name, id [create-only], scope, multi, allow_user_values; values with label/id/colour/is_done + up-down reorder + add/remove), on the DEV-548 backend. System taxonomies read-only; explicit Save per taxonomy; Delete warns with a note-usage count; backend validator errors shown inline; list refreshes after each change. New pure `taxonomyDraft.ts` (blank/isSlug/move) with vitest.

    Gates green: 36 vitest, `npm run check` clean, `npm run tauri build`.

    Holding for your manual sign-off + CI before merge. (Value/id rename across notes is DEV-551; ids immutable post-create here.)
- id: 01KY6YK953CVNHCXVJ2QV7BZ8Y
  author: Steve Vine
  at: 2026-07-23T07:38:47.330896Z
  text: |-
    Steve Vine · 2026-06-21:

    Pushed fixes for your feedback (PR #37):
    - **Settings cog** — sidebar button is now a cog **Settings** icon; Shortcuts/Taxonomies are tabs inside.
    - **Autocomplete off** on the taxonomy name/id/value inputs. This was the root of the "can't create" issue: browser autofill turned the id into `Colour` (capitalised → invalid slug), so the create failed validation. With it off, create/edit/delete should all work — please re-verify.
    - **Live availability** — a new/edited taxonomy now shows immediately in the open capture/editor pickers (via a `taxonomyRev` signal; no need to switch notes).
    - **Value colours** — now render as a dot on the value pills and in the strict value popover in the note editor.

    **Deferred:** "Applies to" allowing **any combination of Types** is a `Scope` data-model change → filed as **DEV-554** (kept out of this PR since it touches the taxonomy model + serialisation).

    Gates green: 36 vitest, `npm run check`, `npm run tauri build`. Ready for another look.
- id: 01KY6YKDRPMXAWWBQ5CY2M2328
  author: Steve Vine
  at: 2026-07-23T07:38:52.05388Z
  text: |-
    Steve Vine · 2026-06-21:

    Both fixed (PR #37):
    - **Edit existing taxonomy** — root cause found: `startEdit` used `structuredClone(t)`, which **throws on the Svelte `$state` proxy**, so the function aborted before opening the editor (create worked because it used a plain object). Switched to `$state.snapshot()`. Editing existing taxonomies works now.
    - **Cog** — now an icon-only cog button, left-aligned at the bottom of the sidebar, matching the app's icon-button style (no "Settings" label).

    `npm run check` + `npm run tauri build` green. Ready for another look.
label: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 40
sprint: sdge8g4
---
A settings surface to manage user taxonomies, on top of the DEV-548 CRUD backend. Extends the DEV-540 Settings modal with a **Taxonomies** section.

**Checklist**

- [ ] List user taxonomies; create a new one (id, name, multi, allow_user_values, scope).
- [ ] Edit a taxonomy's value pool: add/remove/reorder values, set label, optional colour, `is_done` (status semantics, ADR 0005).
- [ ] Delete a user taxonomy (warn if notes use it).
- [ ] Changes call the DEV-548 commands and reflect live (capture/editor pickers + browse update without restart).
- [ ] System taxonomies shown read-only (app-owned, ADR 0009).

**Done when:** a user can create/edit/delete their taxonomies and value pools from the app and see them take effect everywhere. Depends on DEV-548; builds on the DEV-540 settings modal.

---

Linear DEV-549 · M6 — Taxonomy · created 2026-06-21 · done 2026-06-21