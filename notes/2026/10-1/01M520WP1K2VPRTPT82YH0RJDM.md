---
id: 01M520WP1K2VPRTPT82YH0RJDM
created: 2026-10-16T09:32:33.203339Z
updated: 2026-10-16T11:32:10.653096Z
type: task
title: A section's format bar stays at the top of the screen while you scroll through that section, and hands over to the next section's as you reach it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1003
sprint: s2ufsxd
comments:
- id: 01M527QHW0FXM9P8A9SWWS7T2T
  author: Steve Vine
  at: 2026-10-16T11:32:05.119937Z
  text: 'Done — PR #988, merged to main (9ab9baec). In a long section the format bar now stays pinned at the top of the page while you write; at the end of the section it scrolls away with the last line and the next section''s bar takes over. Measured in a real browser: scrolled 1,200 px into a long section, the bar sits at the top (it was 645 px off screen before). Short sections and the Markdown view are unchanged. Nothing for Steve to decide.'
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in Steve's smoke test of sprint 71 (COM-988), 2026-10-16: "When a section gets quite long it becomes awkward to have to keep scrolling to the top to select items on the format bar."

## What is wrong

In a long section, the format bar (headings, bold, lists, Insert…) scrolls off the top with the text, so changing a heading near the bottom means scrolling back up.

The bar was built to stay pinned (COM-988), but it never does. **Measured in a real browser (Playwright, the real Edit tab in a scrolling page):** scrolled 1,200 px into a long section, the bar was at −645 px, off screen.

## What people see

- **While you're in a section, its format bar stays at the top of the page as you scroll down through it.**
- **When the section ends,** its bar goes up with the section's last line, and the next section's bar pins in its place. There's only ever one bar on screen, and it's always the one for the section in front of you.
- **Short sections** don't change: the bar sits above the text as now.
- **The Markdown view** has no format bar, so it's unchanged.

## Technical

- `content/richtext/RichSectionEditor.tsx:153` already has `<RichTextEditor.Toolbar sticky stickyOffset={0}>`.
- **It doesn't stick because the section's Mantine `Card` (`SectionCard` in `pages/ContentDetailPage.tsx`) has `overflow: hidden`.** That makes the card the sticky container instead of the page pane (`ShellFrame`'s `page-pane`, `overflow-y: auto`).
- **Fix:** give the section card `style={{ overflow: 'visible' }}` (or a class).
  - **Verified in the harness:** with the card's overflow visible, the bar sits at the top of the pane (top = 0) when scrolled 1,200 px into a 60-paragraph section.
  - Sticky keeps the bar inside the editor's own box, so it hands over from section to section with no extra code.
- **Check:** `stickyOffset={0}` is right, because the page pane starts below the top bar, so 0 is the pane's top. Also check nothing in the card relied on the clipping (rounded corners on the editor's edges, the picture panels, the table menu).
- **Tests:**
  - Vitest can't lay out, so pin the structure instead: the section card's computed `overflow` isn't `hidden`, with a comment saying why (as with the COM-679 layout tests).
  - Before and after screenshots from the Playwright harness for the PR.

## Done when

- [ ] Scrolling down a long section keeps its format bar on screen.
- [ ] Scrolling on into the next section swaps to that section's bar, with no overlap and no gap.
