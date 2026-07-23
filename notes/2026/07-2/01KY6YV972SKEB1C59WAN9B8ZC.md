---
id: 01KY6YV972SKEB1C59WAN9B8ZC
created: 2026-07-23T07:43:09.538689Z
updated: 2026-07-23T09:18:24.336939Z
type: task
title: 'Capture window polish: larger default size, focus title, taxonomy line layout'
assignee: steve
label:
- brief
number: 64
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sr2wq8c
---
Follow-up tweaks to the new-note (capture) window requested after M8.

**Checklist**

- [ ] **\~50% larger default size** — bump the capture window's default `inner_size` (currently 480×380).
- [ ] **Focus the Title field on open** — focus (and select) the title input both on first open and on every subsequent re-open of the persistent capture window.
- [ ] **Taxonomy line layout** — the meta taxonomies overflow ugly: a value wraps before its field name. Put Status / Priority / Assignee on their own line, and keep each **field name + value glued together** (wrap as a unit, never split label from value).

Pure UI/UX polish on top of M8. The taxonomy line fix should also apply to the note pane's meta row (same structure).

---

Linear DEV-597 · M8 - Styling · created 2026-06-23 · done 2026-06-23