---
id: 01KY6ZPGYDJH08NFXDRXJZYPV0
created: 2026-07-23T07:58:02.189822Z
updated: 2026-07-23T11:00:29.437834Z
type: task
title: 'Hybrid editor: Format menu (selection)'
imported_from: linear
comments:
- id: 01KY6ZPX40MS2K8SJ3BQNYR86K
  author: Steve Vine
  at: 2026-07-23T07:58:14.656013Z
  text: |-
    Steve Vine · 2026-06-28:

    Done — PR #97 (https://github.com/Steve-vine/notula/pull/97).

    **What was built**
    - Format ▾ menu + Cmd/Ctrl+B/I: Bold, Italic, Strikethrough, Highlight (`==`), Code (`` ` ``), Comment (`%%`), Quote (`> ` line prefix), Clear formatting.
    - `==highlight==` and `%%comment%%` taught to the CM parser (`markdownSyntax.ts`) so Live styles highlight / dims comment; read view (`markdown.ts`) renders `==`→`<mark>` and hides `%%comments%%` (Obsidian-style). Comment uses `%%` (Obsidian), decided over HTML comments.
    - Toggle/peel logic is pure + unit-tested (`formatMarkdown.ts`: `toggleMarkerPlan`, `symmetricPeel`, `stripInlineMarkers`).

    **Fixes from live review with Steve**
    - **Nested toggle** only undid in reverse order — checking just the adjacent marker meant a marker behind another (e.g. `==` behind `~~`) couldn't be found and got re-added. Now resolved over the full symmetric marker runs, so it toggles off at any depth/order.
    - **Clear formatting** did nothing — markers wrap *outside* the selection; now expands over the wrapping markers (`symmetricPeel`) before stripping.

    **Verification** — full lefthook gate green (check/build/npm test 81, cargo fmt/clippy/test 134) + manual pass.
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 109
sprint: st23znm
label: null
---
A **Format** menu / toolbar acting on the current selection, driving Brief 1's `Editor.wrapSelection` (CM6 transactions). Toggles where the wrap already present (unwrap).

## Actions (from the M13 brief)

- [ ] **Bold** (`**…**`)
- [ ] **Italic** (`*…*`)
- [ ] **Strikethrough** (`~~…~~`)
- [ ] **Highlight** (`==…==`)
- [ ] **Code** — inline single backticks (`` `…` ``)
- [ ] **Comment** (`%%…%%` Obsidian comment, or HTML comment — decide & note in ADR/impl)
- [ ] **Quote** (line-prefix `> `)
- [ ] **Clear formatting** (strip surrounding inline markers from the selection)

Standard keyboard shortcuts where natural (Cmd/Ctrl+B/I). Highlight (`==`) and comment may need a `markdown.ts` render rule + DOMPurify allowance to show in Read mode — include that.

DoD: each toggles on/off over a selection, round-trips losslessly, and renders in Read + Live.

---

Linear DEV-690 · M13 - Hybrid Edit Mode · created 2026-06-27 · done 2026-06-28