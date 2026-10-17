---
id: 01M521QP0KZCQ4E4CXDKT8RSTF
created: 2026-10-16T09:47:17.907846Z
updated: 2026-10-16T16:39:42.964176Z
type: task
title: '"Show as on paper" on the Edit tab — the sections become a page: white, the style''s real colours, and the page''s real width and margins, so you write at the size it prints'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1005
sprint: s2ufsxd
comments:
- id: 01M52JYXYNNCKV6X73TDS5RBGD
  author: Steve Vine
  at: 2026-10-16T14:48:21.205091Z
  text: |-
    Done in PR #997 (main 8b22ed2f).

    The Edit tab has a "Show as on paper" switch above the sections. It's off by default and stays as you left it on this browser. When it's on:
    - Each section's writing area becomes a white page in the house style's real colours, in dark mode as well as light.
    - The page is the house style's real width, between its left and right margins, centred with a soft shadow.
    - Lines wrap where they do in the PDF. Checked in a real browser: a long paragraph breaks at the same three words as WeasyPrint's PDF of it.
    - On a screen too narrow for a whole page, the page shrinks to fit rather than re-wrapping. At 700 px wide it showed at 84% with the same line breaks.
    - The section's name, the Rich text | Markdown switch, the buttons and the format bar keep Compass's own look. The format bar still stays on screen while you scroll.
    - The Markdown view gets the same white page.
    - Dragging a table column border on a shrunk page keeps the border under the mouse.
    - Callouts on the page look as they print.

    My calls, not confirmed with Steve:
    - The switch only appears once a document has at least one section.
    - The page has a little white space (10 mm) above and below the text. It isn't the page's top and bottom margins, because a section isn't a page.

    Screenshots: ~/.claude/projects/-home-steve-code-compass/sprint71-handoff/com-1005-shots/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Asked for in Steve's smoke test of sprint 71, 2026-10-16:
- "add a toggle on the edit screen to show just the sections on a white background … so that even in dark mode the user can see the sections as they would appear on paper";
- "a toggle that sizes the sections to show the actual page size so that while editing the user can see the document as it would be".

**Both asks are one switch.** This task takes the paper switch out of COM-1001; COM-1001 keeps dark mode.

## What people see

- **A "Show as on paper" switch** at the top of the Edit tab's sections. It's off by default and remembered per browser, like the Rich text | Markdown choice.
- **On:** each section's writing area becomes a sheet of the house style's paper:
  - **white, in the style's real colours,** in light mode and dark mode alike;
  - **the page's real width:** the sheet is the house style's page size (A4 or Letter) with its left and right margins, and the text runs in the same width as on paper. A line that wraps after "organisation" in the PDF wraps there in the editor too;
  - **at actual size where the screen allows.** On a screen too narrow for a full page, the sheet is shrunk to fit as a whole, not re-wrapped, so the lines still break where they print;
  - centred, with a soft shadow, so it reads as a page.
- **Everything else stays as it is.** The section's name, its Rich text | Markdown switch, its move and delete buttons, and the format bar keep Compass's own look, so they're plainly the tools, not the page. The format bar still pins while you scroll (COM-1003).
- **Off:** sections fill the column and follow Compass's light or dark mode (readable in dark, COM-1001).
- **What it isn't:** it isn't a page-by-page view. Page breaks show as the dashed line they are now, and the cover, header and footer aren't drawn. Print preview remains the exact, paged copy.
- **Changing the house style's page size or margins** changes the sheet's width the next time the page loads.

**My call:** one switch covers both "white like paper" and "the size of the paper". Two switches would show a white sheet at the wrong width, or a page width in dark colours, and neither tells you how it prints.

## Technical

- **The house stylesheet** (`core/render/css.py` `screen_css`, served at `/house-styles/{slug}/stylesheet.css`) emits the page's text width, ready to use:
  - `--rt-page-text-width: calc(<page width mm> - <left> - <right>)mm`;
  - `--rt-page-margin-left/right` (mm);
  - from `PageSettings` (`style.py`: `size`, `margin_left_mm`, `margin_right_mm`; A4 = 210 mm, Letter = 215.9 mm).
- **`.rt-paper`** (shared with COM-1001's dark rules, which skip `.rt-paper`):
  - `background: #fff`; light variables in force;
  - `width: var(--rt-page-text-width)`; `padding-inline` = the margins; `box-sizing: content-box`; `margin-inline: auto`; `box-shadow`.
  - CSS `mm` is true size at 96 dpi.
- **Shrink to fit:** measure the section column (a ResizeObserver on the card body). If the sheet is wider, apply `zoom: column / sheet` to the sheet. `zoom` scales layout without re-wrapping and is in every current browser; `transform: scale` would leave the layout box full width.
  - Check that the picture resize handle and the table column-resize maths (COM-1004) still use the right pixel scale under `zoom`, since pointer coordinates are unscaled. Divide by the zoom.
- **Switch:** `pages/ContentDetailPage.tsx` EditTab.
  - Mantine Switch, `w="fit-content"`, with `aria-label` if it has a description;
  - localStorage in try/catch, beside `preferredView`/`rememberView` in `richtext/convert.ts`;
  - adds `rt-paper` to each `RichSectionEditor` content area (`.rt-doc`) and to the Markdown view's container.
- **Build order:** after COM-1001 (dark variables and `:not(.rt-paper)`) and COM-1004 (proportional tables), since all three share `css.py` and `richtext.css`.
- **Tests:**
  - Python: `screen_css` emits the page-width variables for A4 and Letter and custom margins.
  - Vitest: the switch adds `rt-paper` and is remembered.
  - The Playwright harness: in dark mode with the switch on, the sheet is white; its text width in CSS px equals (210 − 44) mm × 96/25.4 for the built-in style; on a 1,000 px-wide window it's zoomed, not re-wrapped (same line count).

## Done when

- [ ] With "Show as on paper" on, the sections show as a white page of the house style's width and margins, in its real colours, in light and dark mode.
- [ ] Lines wrap where they do in the PDF.
- [ ] On a narrow screen the page shrinks to fit rather than re-wrapping.
- [ ] The setting is still on after a reload.
