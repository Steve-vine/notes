---
id: 01KY7058QJVWW13E39Y8ESYRBM
created: 2026-07-23T08:06:05.29829Z
updated: 2026-07-23T11:03:36.033398Z
type: task
title: 'ADRs + design docs: tabbed workspace shell & note due date'
comments:
- id: 01KY705K195Q4DRYDJBMAEFM53
  author: Steve Vine
  at: 2026-07-23T08:06:15.849391Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/123

    **What was done**
    - `decisions/0021-tabbed-workspace-shell.md` — workspace tabs as independent saved views; the per-tab (view mode, pane tree, browse/kanban state) vs global (theme, keymap, panel collapse) split; single versioned `notuvia:workspace` localStorage document with one-shot migration from `notuvia:paneTree` (legacy key deleted only after a successful write); background tabs keep state but unmount DOM, leaning on ADR 0010's flush-on-release buffers; view-mode tabs (Dashboard | Browse | Kanban) move into the main panel with Search merged into Browse as a sidebar section; multi-axis nested browse resolved by filtered queries in the SQLite index rather than client-side intersection; note metadata editing moves to the right panel over the shared DocHandle buffers.
    - `decisions/0022-note-due-date.md` — optional `due: YYYY-MM-DD` core frontmatter field on any note (UI surfaces it for Tasks/Projects); reserved key + indexed column like `identifier`/`order`; opaque display text for now; no migration since the index rebuilds on startup.
    - `brief/ui.md` — Full UI section rewritten for the new shell (workspace tab strip, view tabs, collapsible sections both sides, borderless gap-resized panes/columns, card select/overlay, editable right panel). Tray, capture window, and keyboard-shortcut sections untouched.
    - `brief/data-model.md` — `due` core-field subsection alongside `identifier`/`order`.

    **Decisions made on the fly**
    - ADR 0021 explicitly notes it supersedes only ADR 0019's *surface* choice (milestones edited in the meta header) — the milestone model is untouched.
    - ADR 0022 records the reserved-key caveat: a vault already using `due` as a user taxonomy key would see those values become due dates; accepted as unlikely, consistent with the existing reserved keys.
    - Due date is date-only ISO (`YYYY-MM-DD`) — a due date is a day, not an instant; loosening "opaque display text" later (overdue styling etc.) needs no new ADR since the stored shape is already sortable.

    **Problems encountered**
    - None; pre-push gate fully green (rust-fmt, clippy, rust-test, vitest 94/94, svelte-check 0 errors, build).
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 138
sprint: sa8cznq
label: null
---
R1 of the Revamp UI milestone (parent DEV-754). Docs-only brief that pins the redesign's architecture before code lands.

* **ADR 0021 — tabbed-workspace shell**: workspace tabs as independent saved views; per-tab state (view mode, pane tree, browse/kanban state) vs global state (theme, keymap, panel collapse); single versioned `notuvia:workspace` localStorage document with one-shot migration from `notuvia:paneTree`; background tabs keep state but unmount DOM (relies on noteDocs flush-on-release); multi-axis nested browse resolved in the SQLite index (filtered queries), not the frontend.
* **ADR 0022 — note-level** `due` **date**: frontmatter `due: YYYY-MM-DD` on any note, surfaced for tasks/projects; indexed column; no migration needed (index rebuilds on startup).
* Update `brief/ui.md` to describe the new shell (workspace tabs, view tabs in the main panel, collapsible sidebar/right-panel sections, right-panel property editing, kanban select/overlay interactions).
* Add the `due` field to `brief/data-model.md`.

Checklist:

- [X] ADR 0021 written
- [X] ADR 0022 written
- [X] brief/ui.md updated
- [X] brief/data-model.md updated

---

Linear DEV-761 · Revamp UI · created 2026-07-02 · done 2026-07-02