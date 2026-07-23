---
id: 01KY6YTVZM7QFNQTZ8NKVGFBTQ
created: 2026-07-23T07:42:55.988443Z
updated: 2026-07-23T12:24:57.34074Z
type: task
title: 'Layout stability: stop resize reflow & consistent Settings sizing'
task_status: done
label: null
assignee: steve
number: 63
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sr2wq8c
---
Fix the layout jumpiness called out in the M8 discussion.

**Checklist**

- [ ] **Stable on resize** — several views move a lot of elements around when the window resizes; pin layouts (consistent flex/grid, fixed control rows, wrapping rules) so things don't jump.
- [ ] **Consistent Settings sizing** — the Settings panel changes size per page (each section is a different size); give it a stable frame (fixed/min dimensions, scroll within) so switching sections doesn't resize the modal.
- [ ] General **alignment** pass so controls line up across rows/sections.

Builds on the tokens (DEV-593) and pairs with the restyle (DEV-594). UI — needs design sign-off.

---

Linear DEV-595 · M8 - Styling · created 2026-06-23 · done 2026-06-23