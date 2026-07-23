---
id: 01KY70TAXF41SAQYDJD15WJZXA
created: 2026-07-23T08:17:35.663487Z
updated: 2026-07-23T11:00:29.835319Z
type: task
title: Taxonomies on cards
assignee: steve
task_status: done
imported_from: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 170
comments:
- id: 01KY70TGXFRDGZB5MS348A1J22
  author: Steve Vine
  at: 2026-07-23T08:17:41.807028Z
  text: |-
    Steve Vine · 2026-07-04:

    Done as agreed. The "doesn't work" turned out to be two real bugs, both fixed:

    1. **Free-form tag values never chipped** — `card_chips()` only rendered values found in the pool, so a tag-style taxonomy showed nothing however the flag was set. Tags now render as plain (uncoloured) chips.
    2. **The Priority tick was a no-op** — the letter chip ignored the flag; it now respects "Show on Task cards".

    And the split: `show_on_task_cards` / `show_on_project_cards` replace the single flag (Priority defaults on for tasks, everything else off). Old vault yaml with the legacy `show_on_cards` is folded into both new flags at load and the legacy key is never written back. The settings editor offers each checkbox only when the taxonomy's scope covers that Type — so Priority/Assignee (Task-scoped) won't show a Project checkbox until their scope gains projects in DEV-813/814.

    **Problems encountered:** none; the trickiest part was back-compat for old vault files, covered by dedicated loader tests.

    Full gate green (158 Rust + 110 frontend tests). To verify in the app: tick "Show on Task cards" on a tag taxonomy and check chips appear; untick Priority's and check the letter chip disappears.

    PR: https://github.com/Steve-vine/notuvia/pull/153
sprint: ssy6aak
label: null
---
In Taxonomies section there is a tick show to show taxonomies on cards. This currently doesn't work.   Fix this but add an additional tick box, so we have "Show on Project cards" and "Show on Task cards".

## Agreed work (planned 2026-07-04)

**Root causes found** (the chip mechanism itself works and is tested):

1. `card_chips()` only renders values found in the taxonomy's pool — free-form tag values (taxonomies with "allow free-form values") are silently skipped, so ticking the box for a tag-style taxonomy shows nothing.
2. The Priority tick is a no-op: the card's priority letter chip is populated unconditionally and ignores the flag.

**Changes:**

* Schema: `TaxonomyDef` gains `show_on_task_cards` / `show_on_project_cards` (optional). Legacy `show_on_cards` still reads from old vault yaml and is folded into both new fields at load, but is never written again. Defaults: task cards on for Priority only; project cards off.
* Backend: `card_chips()` becomes board-aware (filters by the matching per-board flag) and emits free-form values as plain chips (fix 1). `task_board()` populates the priority letter-chip fields only when "show on task cards" is on (fix 2).
* Settings UI: the single "Show on cards" checkbox becomes "Show on Task cards" / "Show on Project cards", each offered only when the taxonomy's scope covers that type.
* Tests: legacy-flag migration, tag-value chips, priority flag respected, project board follows the project flag.

---

Linear DEV-812 · Kanban board Improvements · created 2026-07-04 · done 2026-07-04