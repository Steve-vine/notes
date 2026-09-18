---
id: 01M2SNHXEWX2GP28E9RYENYJ9M
created: 2026-09-18T07:09:06.908835Z
updated: 2026-09-18T10:41:13.350132Z
type: task
title: Expand symbol missing from browse tab groups
project: 01KY6W9951TW0904DT0GGJVGE7
number: 424
sprint: segj1dz
comments:
- id: 01M2SS8AN8FF3HG8TE0N7MKZ99
  author: Steve Vine
  at: 2026-09-18T08:13:47.048347Z
  text: |-
    Built on brief-424-browse-folder-chevron, PR #423.

    What was done — one file, src/lib/BrowseSection.svelte:
    - The .folder row's text caret ("▾" / "◂") is now <Icon name="chevron" size={13} /> inside <span class="caret" class:collapsed={!open}>, the same idiom CollapsibleSection.svelte:28-30 has used since DEV-771.
    - .caret CSS mirrors CollapsibleSection.svelte:75-85 — inline-flex, right-aligned, width 1rem, opacity 0.6, plus .caret.collapsed :global(svg) { transform: rotate(90deg) }.
    - Dropped the now-redundant font-size: 0.7rem and .folder .caret { text-align: right } — .r-title's flex: 1 is what pushes the caret to the right edge.

    Decision made on the fly: the investigation changed the framing of the bug. The rows never lost an icon — they have drawn a plain-text triangle since DEV-514 (2f48e46), with DEV-600 (3974d1b) switching the collapsed glyph to "◂". What actually happened is 5f274f0 (DEV-771's icon pass) upgraded CollapsibleSection, which draws the Browse and Trash *section headers*, so those gained a crisp chevron and the rows inside the tree were left behind. At 0.7rem and 60% opacity the leftover glyph reads as a dot. The fix is therefore "finish the DEV-771 pass for these rows", not "restore something that was removed".

    Problems encountered: none.

    Checks: npm run check (372 files, 0 errors), npm test (37 files, 340 tests). Rust untouched. Visual confirmation in the running app still outstanding — that is the review step.

    Follow-up to file: the same raw-glyph outlier survives in the Gantt/Timeline "Unscheduled" toggles (GanttChart.svelte:621, TimelineChart.svelte:554), even though TimelineChart.svelte:425 uses the Icon chevron a few lines away. Out of scope here per the brief discipline.
assignee: steve
label:
- bug
priority: medium
task_status: done
tech: null
---
In the left hand pane of the Browse tab, where the groups of notes are listed it used to show and expand symbol like the Trash section does. This now seems to be just a dot.

## Root cause

The Browse tree's folder rows have always drawn their disclosure marker as a
plain-text triangle — `2f48e46` (DEV-514) introduced `"▾"/"▸"`, `3974d1b`
(DEV-600) changed the collapsed glyph to `"◂"`. They never lost an icon. What
changed is `5f274f0` — "borderless split panes, dimmed inactive pane + icon
pass (DEV-771)" — which upgraded `CollapsibleSection`'s text caret to the SVG
chevron. `CollapsibleSection` draws the **Browse** and **Trash** section
headers, so those gained a crisp chevron while the rows inside the tree were
left behind. At `font-size: 0.7rem; opacity: 0.6` the leftover glyph reads as
a dot.

## Agreed work

- [ ] `src/lib/BrowseSection.svelte` — replace the `.folder` row's text caret
      with the shared chevron: `<Icon name="chevron" size={13} />` inside
      `<span class="caret" class:collapsed={!open}>`, the same idiom as
      `CollapsibleSection.svelte:28-30`. `Icon` is already imported for the
      leaf-row Type icons.
- [ ] Mirror `CollapsibleSection`'s `.caret` CSS — inline-flex, right-aligned,
      `width: 1rem`, `opacity: 0.6`, and
      `.caret.collapsed :global(svg) { transform: rotate(90deg) }`. Drop the
      now-redundant `font-size: 0.7rem` and `.folder .caret { text-align: right }`.
- [ ] Open = chevron down, collapsed = chevron left, matching the section
      headers above it.

Out of scope, to be filed as a follow-up: the same raw-glyph outlier survives
in the Gantt/Timeline "Unscheduled" toggles (`GanttChart.svelte:621`,
`TimelineChart.svelte:554`).