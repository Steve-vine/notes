---
id: 01M3SSZ4HV84GPHB49267YPDNP
created: 2026-09-30T18:41:56.283815Z
updated: 2026-09-30T20:26:20.868406Z
type: task
title: Phosphor icons everywhere, replacing the current set
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 797
sprint: s0zzctz
blocked_by:
- 01M3SSXGXPWVAWH64CKQR6KE1Z
comments:
- id: 01M3SZY9FDG68AQT9VKFHQ45EQ
  author: Steve Vine
  at: 2026-09-30T20:26:20.013341Z
  text: |-
    Done: PR #805, merged to main (e1d852e).

    What you'll see:
    - Every icon in Compass is now from the Phosphor set the design uses, at the same sizes. That covers the menu, buttons, empty states, the Access graph, and both portals.
    - The menu uses the prototype's icons: squares for Dashboard, the clipboard for Assessments, the storefront for Vendor Management, the ID badge for Access Control, and so on.
    - Each icon means what it meant before. A few had no exact match and took the nearest one:
      - the privilege shield is now the same warning shield as Risks;
      - "Conditional Access, no policies" shows a lock;
      - distribution lists show an envelope.

    A check now stops anyone bringing the old icon set back. All the frontend checks passed (1,475 tests).

    Not on staging yet. It goes out with the other four sprint tasks once they're all in review.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The design system uses Phosphor icons throughout. This task swaps every icon in one pass, so no page mixes the two sets.

## What people see

- **Every icon is from the Phosphor set**, in its regular weight, at the prototype's sizes:
  - 18 in the menu;
  - 15–17 in buttons and the top bar;
  - 12–14 inline.
- **Each icon means what it meant before.** Where the prototype picks one for a menu item, use that one:
  - Dashboard `squares-four`, Actions `list-checks`, Reports `chart-bar`;
  - Frameworks `books`, Domains `stack`, Controls `check-square-offset`, Content `file-text`;
  - Assessments `clipboard-text`, Gaps `warning`, Risks `shield-warning`, Timeline `chart-line`, Decisions `gavel`;
  - Vendor Management `storefront`, Access Control `identification-badge`, Inventory `hard-drives`;
  - User Portal `globe`, Admin `gear`, Activity `clock-counter-clockwise`.

## Notes (technical)

- **About 63 files** import `@tabler/icons-react`. Replace them with `@phosphor-icons/react` named imports and drop the Tabler dependency.
- **The Access graph** (`access/graph/graphMeta.ts`, `DirectoryGraphView.tsx`) draws icons into the graph. Check that the Phosphor components render there as well.
- **Ratchet test** in `screen-conventions.test.ts`: no `@tabler/` import anywhere under `src`.
- **Tests.** Existing tests that query by an icon's aria-label or test id must keep passing. Update any that select by Tabler class names.
- **Parallel work.** This can run alongside the palette task. It touches imports only, so conflicts are mechanical.

**Done when:** staging shows no Tabler icon on any page, including the portals, and the ratchet test is in.