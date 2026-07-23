---
id: 01KY6Y9ZMEQWEGZGZK7Y1PWXAE
created: 2026-07-23T07:33:42.670202Z
updated: 2026-07-23T11:00:29.411761Z
type: task
title: Edit taxonomy values in the note editor
imported_from: linear
assignee: steve
comments:
- id: 01KY6YA3QWYYD8B91K9VXCF089
  author: Steve Vine
  at: 2026-07-23T07:33:46.876123Z
  text: |-
    Steve Vine · 2026-06-21:

    Closed as **absorbed by DEV-545** (PR #34): the main-UI editor now edits a note's taxonomy values (pre-filled from frontmatter; deselect clears them; reindexed) alongside Type and the Project link, via the extended `update_note`. The editor uses ADR 0010 autosave rather than an explicit save. No separate work needed here.
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 23
sprint: sdge8g4
label: null
---
Deferred from DEV-515 (which edits body + title only). Add editing of a note's applicable taxonomy values in the main editor — most importantly changing Task Status / Project Status, which is M5's territory.

**Checklist**

- [ ] In edit mode, render the scope-driven selectors (reuse DEV-511's `applicable_taxonomies` + the capture selectors) **pre-filled** from the note's current frontmatter values
- [ ] Extend `update_note` (or a sibling command) to accept the edited taxonomy values and write them into the frontmatter (reserved core keys protected), preserving unknown keys; reindex
- [ ] Removing a value (deselect) clears it from the frontmatter

**Done when:** a note's taxonomy values (incl. Task/Project Status) can be changed in the editor and saved, reflected on disk and in the browse tree.

**Notes:** the load_note view currently returns title/body/type/timestamps — it'll need the applied taxonomy values too (or a separate fetch). No new ADR (implements ADR 0005/0006 in the UI).

---

Linear DEV-519 · M6 — Taxonomy · created 2026-06-20 · done 2026-06-21