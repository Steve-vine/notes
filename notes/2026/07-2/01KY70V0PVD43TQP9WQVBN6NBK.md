---
id: 01KY70V0PVD43TQP9WQVBN6NBK
created: 2026-07-23T08:17:57.979655Z
updated: 2026-07-23T11:00:29.85852Z
type: task
title: Priority field
task_status: done
imported_from: null
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 171
comments:
- id: 01KY70V6VNN3A7TQT7J0HQAE21
  author: Steve Vine
  at: 2026-07-23T08:18:04.276949Z
  text: |-
    Steve Vine · 2026-07-04:

    Done as agreed, in four parts:

    1. **Priority on Projects** — seed scope is now Task+Project, delivered to existing vaults by making built-in taxonomy frames code-authoritative at registry load (**ADR 0023**, `decisions/0023-…`). Your vault picks it up on next launch; the Priority picker appears on project notes and the "Show on Project cards" checkbox appears in Settings automatically.
    2. **Project cards** resolve the priority letter chip when that checkbox is ticked.
    3. **"default" replaces "done"** — the done checkbox is now status-taxonomies-only (it never meant anything elsewhere; flagging that this also removed it from *user* taxonomies, where it was equally inert — shout if you were using it as a marker). Priority values get a "default" checkbox; one per pool, enforced.
    4. **Default on create** — `save_note` stamps the default onto new Tasks/Projects without an explicit priority, covering editor, capture, and board adds. Imports are exempt (they preserve files as-is).

    **Note for your vault:** fresh vaults seed Medium as the default; your existing vault has no default marked yet, so tick one in Settings → Priority to activate the stamping.

    **Problems encountered:** one clippy lint on push, fixed. Full gate green (163 Rust + 110 frontend tests).

    PR: https://github.com/Steve-vine/notuvia/pull/154
sprint: ssy6aak
label: null
---
Add a second settings tickbox to Priority in settings so we have "Show on Project cards" and "Show on Task cards" and show the priority status on project cards when selected.

Remove the 'Done' option for priorities, and replace it with a default option to make one priority value the default.  When creating new tasks and projects, always set the priority to this unless it's otherwise set.

## Agreed work (planned 2026-07-04)

* **Priority applies to Projects**: seed scope becomes Task+Project. For existing vaults, built-in taxonomy *frames* (scope / multi / free-form) are normalised from the code seeds at registry load — the frame is already code-locked per ADR 0012; the vault file keeps owning names, values, and card flags. Recorded as **ADR 0023**. The scope-driven UI (note editors, capture, DEV-812's settings checkboxes) picks projects up automatically, giving Priority its "Show on Project cards" tickbox.
* **Default value replaces "done"**: `TaxonomyValue` gains `is_default`; validation rejects more than one default per pool. The per-value "done" checkbox now only appears for the status taxonomies (it is meaningless elsewhere); Priority gets a "default" checkbox instead (ticking one clears the others). Fresh-vault seed marks Medium as default; existing vaults tick it once in Settings.
* **Default on create**: `save_note()` stamps the default priority onto new Tasks/Projects that don't set one — a single choke point covering the editor, capture, and board-column adds. Imports deliberately untouched.
* **Project cards show priority**: the project board query gains priority + assignee columns (assignee unused until DEV-814); project cards populate the priority letter chip when "Show on Project cards" is ticked.
* Tests: frame normalisation of an old-scope vault, duplicate default rejected, default applied on create (explicit value wins, memo untouched), project card priority follows the flag.

---

Linear DEV-813 · Kanban board Improvements · created 2026-07-04 · done 2026-07-04