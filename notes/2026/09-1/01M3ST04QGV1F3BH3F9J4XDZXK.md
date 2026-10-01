---
id: 01M3ST04QGV1F3BH3F9J4XDZXK
created: 2026-09-30T18:42:29.232199Z
updated: 2026-10-01T20:06:04.874296Z
type: task
title: The screen kit — page header, tabs that fold into More, filter bar, quick-filter chips, grouped lists, summary cards, the detail layout
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 799
sprint: s0zzctz
blocked_by:
- 01M3SSYNG7G0N7PH6XS02CJ7NK
- 01M3SSZ4HV84GPHB49267YPDNP
comments:
- id: 01M3T2T7F5NR35RBG6DG47XFWJ
  author: Steve Vine
  at: 2026-09-30T21:16:32.613797Z
  text: |-
    Done: PR #809, merged to main (a96b90e).

    Nothing changes on screen yet. This is the set of building blocks every redesigned screen will be made from, so the section tasks (COM-801 to COM-814) assemble screens rather than styling each one by hand. The pieces, as the design draws them:
    - **Page header:** a title with actions on the right, and no line under it.
    - **Tab bar:** tabs that don't fit fold into a "More" menu instead of wrapping onto a second line. The tab you're on is never hidden there.
    - **Filters:**
      - a search box;
      - filter buttons that read "Domain: All ▾" (one choice, or several);
      - round quick-filter chips with counts.
    - **Lists:** small-capital column headings, quiet rows, and domain headings with a violet bar that stay in view while their rows scroll. They're still proper tables, so sorting, rows as links, and the fixed list heading keep working.
    - **Summary cards,** which can act as filters.
    - **Record pages:** a header with a reference badge, a main column, and a side column of cards that moves underneath on a narrow window.
    - **Folding sections,** marks for status and maturity (0–5), and initials for people.
    - **A control's guidance** shown in its three parts: what it means, what good looks like, and evidence to collect.

    A new check makes sure no screen is left in the old layout. It lists the 54 pages still to convert, and each section task crosses off its own. In a development build, a showcase page at /dev/kit shows every piece in light and dark.

    All checks passed (1,492 tests).
assignee: steve
label:
- feature
priority: high
task_status: done
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The prototype's six screens are built from a dozen repeated pieces. This task builds them once, so every section task assembles screens from the same parts rather than restyling each by hand.

## What people see

Nothing changes on its own. Each section task adopts the kit. These are the pieces, as drawn in the prototype:

- **Page header:**
  - the title (26px, medium weight) with the page's actions on the right, the main one outlined in violet;
  - no line under the title.
- **Tab bar:**
  - underlined tabs, with a count beside a tab where it helps ("Register 5");
  - tabs that don't fit fold into a **More ▾** menu with a count.
- **Filter bar:**
  - a search box;
  - filter buttons that read "Domain: All ▾" with the chosen value in violet;
  - on the right, a "12 shown" count and any toggles ("Owned by me", "Show disabled").
- **Quick-filter chips:** round chips with a coloured dot and a count ("Critical risk 2"). One is active at a time, and it is tinted violet.
- **Grouped list:**
  - a sticky column header in small capitals;
  - a sticky group heading with a violet bar, the group name, its count, and anything the group carries on the right;
  - quiet rows that tint on hover, where the whole row opens the record;
  - on narrow screens, fewer columns.
- **Summary cards:** a row of cards, each with a small-caps label, a large figure and a short line under it. A card can be a filter, ringed in violet when chosen.
- **Detail layout:**
  - a header with a ref badge or icon tile, the title, a line of facts and the actions;
  - an optional strip of fact cards and the tabs;
  - a main column, and a sticky side column (about 320px) of cards.
  - On narrow screens the side column drops below.
- **Collapsible section:** a heading with a chevron, a count and an action on the right ("Gaps 3 · + Raise gap").
- **Status marks:**
  - a status as a tinted pill or a dot and label;
  - maturity as a row of small bars with the level's name;
  - avatars as initials in a violet circle.
- **Guidance:** a control's guidance shown in three parts: *What this means*, *What good looks like* (ticked lines) and *Evidence to collect*.
- **Focus layout:** a narrow queue on the left and the open record on the right. Assessments uses it.

## Notes (technical)

- **Where it lives.** Build in `components/kit/` on Mantine primitives. Extend `ScreenFrame` for the page header rather than adding a second frame.
- **Conventions still hold:**
  - pills never truncate (`theme.ts` overrides);
  - `w="fit-content"` on every toggle;
  - row actions in their own trailing column.
- **Grouped list.** Rows are `LinkRow`s, so the trail and middle-click still work. Where today's list is sortable, the column header keeps `SortableTh` behaviour. Extend `screen-conventions.test.ts` so the kit's header counts as sortable.
- **Tab bar.** It drives `useTabParam` as today, so URLs don't change. Overflow is measured with a `ResizeObserver`, and the More menu lists the hidden tabs.
- **Chips and filters.** They read and write through the COM-792 `useQueryState` hooks, so a list you come back to is the list you left.
- **Guidance renderer.** Split the control's markdown `description` on its three headings (ADR 0059 §4). With no headings, render the whole markdown as today.
- **Ratchet.** Add a test that every routed page renders the kit's page header, with an allowlist of today's pages. Each section task empties its own entries. This is how we know no page was left in the old layout.
- **Tests.** Unit tests for each piece, including tab overflow into More, guidance splitting, and chip state in the URL.

**Done when:** the kit and the ratchet are merged, and a storybook-style scratch page (dev only) shows every piece in light and dark.