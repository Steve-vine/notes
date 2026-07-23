---
id: 01KY6YFDQB0QTYZQHW90NDE9HY
created: 2026-07-23T07:36:40.939191Z
updated: 2026-07-23T12:24:59.603915Z
type: task
title: Update New Note form
assignee: steve
label: null
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 34
comments:
- id: 01KY6YG2QBQE8KX3BCRD7QGBFH
  author: Steve Vine
  at: 2026-07-23T07:37:02.44357Z
  text: |-
    Steve Vine · 2026-06-21:

    PR: https://github.com/Steve-vine/notula/pull/31 — In Review.

    Capture form redesigned per the mockups + our discussion:
    - Borderless note-like title/body; slim meta footer. **Type** = pill → popover (Memo/Task/Project). **Tag icon** toggles a taxonomy section (slides). **Cancel/Open-in-UI/Save** → icon buttons (inline SVG, no dep), with tooltips.
    - Taxonomy section starts empty; Save works with nothing set. **`+`** lists user-defined taxonomies only (system status excluded). Strict → value popover; non-strict → text box → pills (click a pill to edit, ✕ to remove). Changing Type drops now-inapplicable rows.
    - New `TaxonomyEditor.svelte`, `Icon.svelte`, and pure `taxonomyRows.ts` (`userAddable`/`pruneRows`/`rowsToValues`) with vitest. Backend unchanged.

    Gates green: 28 vitest, `npm run check` clean, 42 cargo tests, `npm run tauri build`.

    Note for testing the section: a fresh vault has no user taxonomies, so `+` is hidden until one is defined in `taxonomies.yaml` (e.g. a `Genre`). Holding for your manual sign-off + CI before merge.
- id: 01KY6YG8XY5MV7JPZJTK86AJV6
  author: Steve Vine
  at: 2026-07-23T07:37:08.797854Z
  text: |-
    Steve Vine · 2026-06-21:

    Fix for the taxonomy `+` doing nothing: https://github.com/Steve-vine/notula/pull/32

    **Cause:** the taxonomy section is inside `.tax-wrap`, which had `overflow-y: auto` — an overflow container clips its children, so the popovers rendered but were cut off (the Type popover worked because it's not in an overflow container).
    **Fix (CSS only):** removed the overflow clipping and made the taxonomy popovers open upward (the section sits at the window's bottom edge).

    `npm run check` + `npm run tauri build` green. Ready for another test.
sprint: st23znm
---
Update the new note form to make it look more note-like.  Below is a mock up.
Also replace the buttons with icons

![](https://uploads.linear.app/467bbd6c-826b-40fd-a7d7-1f36b56963bf/d1695f26-a3e8-4432-9add-b0a1f47f5232/43157bec-e602-4f26-9f56-e6496988c5ce?signature=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXRoIjoiLzQ2N2JiZDZjLTgyNmItNDBmZC1hN2Q3LTFmMzZiNTY5NjNiZi9kMTY5NWYyNi1hM2U4LTQ0MzItOWFkZC1iMGExZjQ3ZjUyMzIvNDMxNTdiZWMtZTYwMi00ZjI2LTlmNTYtZTY0OTY5ODhjNWNlIiwiaWF0IjoxNzg0NzkxMjk0LCJleHAiOjE3ODQ3OTE1OTR9.HF8EG8uyBTGMCIJgrOcN5cdC7sqTY-AT0bK_vH6WGo8)

The Type is now a pill button that can be changed by clicking on it.  On the right is a taxonomy button (should be an icon rather than text). When you click on it, the type and tax buttons slide up to reveal the taxonomy section as shown below.

![](https://uploads.linear.app/467bbd6c-826b-40fd-a7d7-1f36b56963bf/65e518fa-8847-492a-9b13-b13c68132b98/6a4f81bd-2b1f-4baa-82f4-2040278ce30f?signature=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXRoIjoiLzQ2N2JiZDZjLTgyNmItNDBmZC1hN2Q3LTFmMzZiNTY5NjNiZi82NWU1MThmYS04ODQ3LTQ5MmEtOWIxMy1iMTNjNjgxMzJiOTgvNmE0ZjgxYmQtMmIxZi00YmFhLTgyZjQtMjA0MDI3OGNlMzBmIiwiaWF0IjoxNzg0NzkxMjk0LCJleHAiOjE3ODQ3OTE1OTR9.84IAnpiFN5SyAJu8SWIUqPN5NowNNH9ptlFujPfeaEU)

The section is empty initially but you can click the plus button to add a pre-defined taxonomy, then select the options, these render a pills.

---

Linear DEV-542 · M13 - Hybrid Edit Mode · created 2026-06-21 · done 2026-06-21