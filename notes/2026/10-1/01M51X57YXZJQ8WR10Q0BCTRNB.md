---
id: 01M51X57YXZJQ8WR10Q0BCTRNB
created: 2026-10-16T08:27:19.38996Z
updated: 2026-10-16T16:39:49.254452Z
type: task
title: The house style sets where the logo sits on the cover — a corner or above the title — and how big it is, from actual size down
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 997
sprint: s2ufsxd
comments:
- id: 01M52E0N4Z1BHQN65XHGQ0D32T
  author: Steve Vine
  at: 2026-10-16T13:21:54.847364Z
  text: |-
    Done in PR #994 (merged to main, 588d54e8). In Content ▸ House styles ▸ Cover page, when the style has a logo shown on the cover, there's now a Logo position (Above the title, or a corner of the cover inside its margins) and a Logo size slider. 100% is the logo's actual size; the slider goes down to 10%, and a logo too big for the page is capped at the page's width. The preview, the PDF and the Word export all put it in the same place at the same size.

    Calls I made that you haven't confirmed:
    - A style nobody has changed prints exactly as before, and its slider starts at the size the logo prints at today. Saving without touching the slider changes nothing.
    - Uploading a new logo puts the size back to that "fits as before" size, since a size picked for the old logo doesn't suit a new one.
    - An old style whose logo file has a high resolution can start above 100%, because it used to print larger than its actual size. The slider widens to fit that rather than shrinking the logo.
    - Word exports now use the PDF's logo size even for untouched styles. Before, Word always made the logo 18 mm tall, so Word covers can look slightly different from today.
    - The header and footer logo is unchanged (as the task said).
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Asked for in Steve's smoke test of sprint 71 (COM-990), 2026-10-16.

## What is wrong

Today the cover's logo always sits above the title. Compass shrinks it to fit a fixed box (about 22 mm high and 70 mm wide), so a designer can neither move it nor choose its size.

## What people see

In Content ▸ House styles ▸ Cover, below "Show the logo":

- **Logo position:**
  - Above the title (the default; it's where the logo is now);
  - Top left, Top right, Bottom left, Bottom right.
  - The corners are the corners of the cover page, inside its margins.
- **Logo size:** a slider.
  - **Full scale (100%) is the logo's actual size:** what its file says its printed size is, or 96 pixels to the inch if the file doesn't say.
  - Sliding left shrinks it, down to 10%.
  - A logo too big for the page is still capped at the page's width, so it never runs off the page.
- The live preview follows both straight away.
- The Word export puts the logo in the same place, at the same size.
- **Existing styles:** they keep "Above the title". Their starting size is whatever matches what they print today, so no document changes on the day this ships.

**My call:** this is the cover's logo only. A logo in the header or footer still sizes itself to fit the band.

## Technical

- `core/render/style.py`: add `logo_position: Literal["above_title","top_left","top_right","bottom_left","bottom_right"] = "above_title"` and `logo_scale: int` (10–100) to the cover settings.
  - Settings are JSON with defaults, so there's no migration. Check that Load still accepts a style file without these two fields.
- Actual size: read the logo's DPI with Pillow when it's uploaded (`dpi` info, default 96) and keep its natural width in mm with the style's logo. Or work it out at render time from the stored bytes.
- `core/render/css.py` / `document.py`:
  - drop the fixed `.rt-cover-logo { max-height: 22mm; max-width: 70mm }` box for an explicit width (natural width × scale), capped at `max-width: 100%`;
  - place the corners absolutely within the cover page;
  - keep "Above the title" in the flow.
- Pick each existing style's starting scale so its logo stays the size it prints today: the scale at which the natural size fits 22 × 70 mm. Do this when the settings are read, not in a migration.
- `core/render/word.py` `_cover`: the same width; corners as a left/right aligned paragraph at the top, or at the foot of the cover page.
- Frontend: the House styles designer's cover panel gets a SegmentedControl or Select for position (`w="fit-content"`) and a Slider for size.
- Tests: the CSS for each position, the scale applied, the page-width cap, and an old style file still loading with today's look.

## Done when

- [ ] Each of the five positions shows in the preview and in an exported PDF and Word file.
- [ ] At 100% the logo prints at its actual size; the slider shrinks it.
- [ ] Today's styles look the same until someone changes them.
