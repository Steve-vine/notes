---
id: 01KY6YTPD393QRXKNVMB4K25RD
created: 2026-07-23T07:42:50.275527Z
updated: 2026-07-23T09:08:57.335987Z
type: task
title: 'Linear-style restyle: cleaner tabs, smaller widgets, shared primitives'
task_status: done
assignee: steve
number: 62
label: brief
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
---
On top of the theme tokens (DEV-593), bring the app's look close to Linear: sleek, compact, consistent.

**Checklist**

- [ ] **Cleaner tabs** — the sidebar Browse / Search / Kanban tabs become proper tabs (segmented or underline), not chunky buttons.
- [ ] **Smaller, denser widgets** — reduce padding/sizes of pills, buttons, inputs, popovers toward Linear's compact density.
- [ ] **Shared primitives** — a small set of reusable styled components/classes (button, input, pill/chip, popover, icon-button) so surfaces stop re-inventing styles; apply across sidebar, note pane, capture, settings, taxonomy editor, board.
- [ ] Tighter, consistent **typography & spacing**; muted Linear-like palette via the tokens.

Builds on DEV-593. UI — needs design sign-off.

---

Linear DEV-594 · M8 - Styling · created 2026-06-23 · done 2026-06-23