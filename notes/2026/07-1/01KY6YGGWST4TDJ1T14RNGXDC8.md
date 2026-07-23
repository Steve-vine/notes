---
id: 01KY6YGGWST4TDJ1T14RNGXDC8
created: 2026-07-23T07:37:16.953021Z
updated: 2026-07-23T11:03:33.874138Z
type: task
title: Add a suggestion feature for custom tags
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 35
comments:
- id: 01KY6YGPCG5T253JRF1XFVGR31
  author: Steve Vine
  at: 2026-07-23T07:37:22.575992Z
  text: |-
    Steve Vine · 2026-06-21:

    PR: https://github.com/Steve-vine/notula/pull/38 — In Review.

    Typing into a free-form taxonomy's tag box now suggests existing values for that taxonomy (from the index's `taxonomy_values`), to avoid near-duplicates. Pure `taxonomySuggest.ts` (case-insensitive match, excludes selected/identical, dedupes, capped — also surfaces `Blues` when you type `blues` so you reuse the canonical casing) + a dropdown in `TaxonomyEditor` (click or ↑/↓+Enter; plain Enter still adds new text; Esc/blur closes). Only the free-form tag boxes get suggestions. No backend change.

    Gates green: 43 vitest, `npm run check` clean, `npm run tauri build`.

    Holding for your manual sign-off + CI before merge.
- id: 01KY6YGWFHCQ4NBDSC234WPXMZ
  author: Steve Vine
  at: 2026-07-23T07:37:28.817387Z
  text: |-
    Steve Vine · 2026-06-21:

    Fix pushed (PR #38):
    - The macOS WebView's own **autocapitalize/autocorrect** was the suggestion you saw — added `autocapitalize="off"` / `autocorrect="off"` / `spellcheck="false"` to the tag input (alongside `autocomplete="off"`), so the OS bar no longer appears.
    - Broadened the app's suggestions to also include the **taxonomy's own value pool** (not just values already used across notes), so the dropdown shows even before any note has used the taxonomy.

    `npm run check`, `npm test` (43), `npm run tauri build` green. Worth another try — type in a free-form taxonomy's tag box and the app's list should appear (no OS capitalise prompt).
- id: 01KY6YH05HGQKMXSKS0NPAHVJ1
  author: Steve Vine
  at: 2026-07-23T07:37:32.593084Z
  text: |-
    Steve Vine · 2026-06-21:

    Fixed the clipped dropdown (PR #38): it was opening **downward** into the note-body region below the meta header, where it got obscured. Now it opens **upward** (above the input), like the taxonomy's other popovers, which render cleanly over the meta. `npm run check` + `npm run tauri build` green — should be fully visible now.
- id: 01KY6YH7Y357VV3EB8JWAKPP0M
  author: Steve Vine
  at: 2026-07-23T07:37:40.547066Z
  text: |-
    Steve Vine · 2026-06-21:

    Pushed the proper fix (PR #38). The popovers were trapped in the meta region (downward → behind the body; upward → off the top of the window). Now the **`+` picker, the strict value popover, and the tag-suggestion dropdown** all render **`position: fixed`** just below their trigger with a high z-index — so they open **downward and overlay the note body**, and a long list scrolls within the popover rather than off-screen. `npm run check` + `npm run tauri build` green.
sprint: sdge8g4
---
When entering tags into taxonomies where user input is allowed, show a suggestion/auto-complete list to help prevent duplicates.

---

Linear DEV-543 · M6 — Taxonomy · created 2026-06-21 · done 2026-06-21