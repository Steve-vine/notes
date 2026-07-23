---
id: 01KY6Y7SHST3BNJGV4G7HEX6YX
created: 2026-07-23T07:32:30.905413Z
updated: 2026-07-23T12:24:59.343492Z
type: task
title: Main window shell + read IPC + full search (Tab 2)
assignee: steve
comments:
- id: 01KY6Y83GVJFASQQB61ESD1WG6
  author: Steve Vine
  at: 2026-07-23T07:32:41.115416Z
  text: |-
    Steve Vine · 2026-06-20:

    **Done building — in review.**

    **What was done**
    - **Backend:** `index::NoteSummary` + `search_summaries(query)` — FTS5 joined to the `notes` table (id/title/type, ranked), with an `fts_query` helper (tokenise, strip punctuation, AND, prefix-match last token for live search). `runtime::NoteView` + `search`/`load_note`. Commands `search_notes` / `load_note`.
    - **Frontend:** `lib/notes.ts`; `lib/Main.svelte` — sidebar with **Search** (live) + **Browse** (placeholder → DEV-514) tabs, results list, read-only viewer (title/type/body). `+page.svelte` renders `Main` when a vault is configured.

    **Verification** — `npm run check` (0/0), fmt, clippy `-D warnings` (exit 0), `cargo test` (**37 pass**, 3 new), `npm run tauri build`; app launches cleanly (a stale single-instance from my repeated launch/kill cycles briefly confused the smoke test — not a real issue). **Interactive search→view needs your manual sign-off.**

    **Please verify** via `npm run tauri:dev`: main window shows the **Search** tab → type a word from a saved note → it lists → click → title + body show read-only.

    **Process note:** local tests caught that FTS5 `MATCH` rejects a table **alias** (`f MATCH` → "no such column: f") — fixed to unaliased `notes_fts MATCH`.

    **Scope guard:** browse = DEV-514; editing = DEV-515; splits = DEV-516; Open-in-UI = DEV-517. Plain-text body render (rich later); fuzzy = M7. No new ADR.

    **PR:** https://github.com/Steve-vine/notula/pull/17 · commit `5a39402`
    Holding the merge for your sign-off.
label: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 18
sprint: s6s57kv
---
The retrieval-first slice of the main UI (`brief/ui.md`): the Obsidian-like window shell + live full-text search + a read-only note viewer. First time the index's read side is exposed to the frontend.

**Checklist**

- [ ] Read IPC: `search(query)` → note summaries (id, title, type), and `load_note(id)` → the note (frontmatter fields + body) for display. (Index `search` returns ids; join the `notes` table for titles.)
- [ ] Main window layout: left sidebar with two tabs + a main panel (single pane for now)
- [ ] **Tab 2 — Full search:** a search field that filters notes live (FTS5), results list
- [ ] Read-only note viewer in the main panel: click a result → load + show its title/body (markdown render can be basic)
- [ ] Replace the main-window placeholder with this UI when a vault is configured

**Done when:** in the main window, typing in search lists matching notes and clicking one shows it read-only.

**Scope:** browse tab = next brief; editing, split panes, Open-in-UI hand-off are later M4 briefs. Consumes the index (DEV-484) + runtime (DEV-509).

---

Linear DEV-513 · M4 — Main UI · created 2026-06-20 · done 2026-06-20