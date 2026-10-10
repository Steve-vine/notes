---
id: 01M4JM0ZMN04ZXGMZD88X47N2V
created: 2026-10-10T09:59:06.133979Z
updated: 2026-10-10T11:35:07.459699Z
type: task
title: 'Move window: the new layout from Steve''s "Mover Request" design'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 898
sprint: sme8esk
comments:
- id: 01M4JP1J8XXH2DSGQY2CSAPDFA
  author: Steve Vine
  at: 2026-10-10T10:34:22.364912Z
  text: |-
    Done 2026-10-10 — PR #884, merged to main as b7c334e8. Not on staging yet (waiting for Steve's say-so; COM-899 goes with it).

    What landed
    - The move window in the design's layout: title + one line, fixed title bar and bottom bar, six numbered sections, "What this move changes" summary on the right (sticky; wraps under in a narrow window).
    - Access changes: a row each for Managed groups / Manual groups / Shared mailboxes with Adding and Removing pills and "+ Add a group" / "+ Add a shared mailbox".
    - Access this move leaves as it is: Role groups, Manual groups, Dynamic groups, Shared mailboxes — folded, with a count, Show all / Hide, a filter, pills filed by letter (mailboxes by mailbox).
    - Account details: "Changed" beside a field that differs, accent edge, as many to a row as fit.
    - Shared pieces for COM-899 in access/requestWindow.tsx; mover-specific in MoverSections.tsx.

    Where it departs from the design (each a small change to reverse)
    1. Role groups keep a list — the design had none.
    2. A change made by name opens its box (Don't add / Restore inside) rather than being removed on one click. A role's change can't be removed, and the box holds the description and the Access Admin warning.
    3. Colours are the app's palette (light + dark), not the design's hard-coded dark.
    4. Change pills are in capitals, as the design has them — including "24 HOUR — CAN OPEN". Say if mailbox pills should keep their case.
    5. A list that empties (last manual group removed) disappears; restoring one brings it back folded.

    Checked
    - vitest src/access + screen-conventions: 44 files, 628 tests. Mover tests updated for the new group names ("Managed group changes", "Manual group changes", "Shared mailbox changes"), folded lists and the summary; new tests for the window's name, the filter, the summary.
    - Headless Chromium at 1440 dark/light and 820 narrow, on data shaped like the design's (96 manual groups, 13 dynamic, 17 mailbox permissions).
    - CI: first run failed sast — semgrep refuses `new RegExp(variable)` even in a test; replaced with a name-matching function.

    Not checked: Safari, and the real estate's data. Smoke test steps are in the task body.
- id: 01M4JSGSY394BDSSVMPD7Z3DQP
  author: Steve Vine
  at: 2026-10-10T11:35:07.459298Z
  text: On staging 2026-10-10 (dd049cdb, image staging-20261010-1133) — with COM-899, COM-900, COM-896 and COM-897. Deploy run 38048810626 green; api / beat / frontend / worker Running, 0 restarts, no errors in the logs. Departure 4 above (capitals) is reversed by COM-900.
assignee: steve
priority: medium
task_status: review
---
## What Steve asked (2026-10-10)

"The mover window is now getting quite cluttered and hard to read. I've produced a new design in Claude design for the mover window, it's a bit wider and better layed out with some extra layout features. Apply this to the Mover window, then adapt the design for each of the other requests so that all 6 requests share the same design principles and layout."

Design: Claude Design project "Compass Site Redesign Review" (`891a3126-6ab8-4868-8550-6f744d19c0c1`), file **`Mover Request.dc.html`**. This task is the move window; COM-899 is the other five.

## The design, in the words on the screen

- **Window**: up to 1180px wide. A title with one line under it ("Change a person's roles, account details and access in one request."). The title bar and the buttons stay put; only the middle scrolls.
- **Left, numbered sections, each in its own outlined box:**
  1. **Who is moving** — Directory account.
  2. **Roles** — a "Roles now" strip, then Primary role and Additional roles side by side; "Changes from …" under the primary when it changes.
  3. **Account details** — each field says "Changed" beside its name and takes an accent edge when it differs; "Changes from X. Leave as it is" underneath, or "As it is now — not changed".
  4. **Access changes** — one row each for Managed groups, Manual groups, Shared mailboxes: a count on the left ("2 added · 1 removed"), "Adding" and "Removing" pills on the right, and "+ Add a group" / "+ Add a shared mailbox".
  5. **Access this move leaves as it is** — lists that start folded, each with a count, a line saying what it is, "Show all / Hide", a filter box, and its pills grouped (groups by first letter; mailboxes by mailbox, with "can open" / "can send as").
  6. **Justification**.
- **Right, "What this move changes"**: role and detail changes as *from → to*, a count of adds and removes per kind of access, and "Unchanged: N manual groups, N dynamic groups, N shared mailbox permissions." It stays in view while the left scrolls; in a narrow window it drops underneath.
- **Bottom bar**: the expedited warning on the left; Cancel, Submit expedited, Submit for approval on the right.

## Decisions taken while applying it

- **Role groups stay.** The design has no list for the groups their roles give them and they keep (COM-891). Kept as a fourth folded list, first in section 5.
- **A change pill opens its box, it is not removed on one click.** The design says "Select a change to remove it". But a managed-group or role-given change cannot be removed at all, and the box is where a group's description and the "needs an Access Admin" warning are. So by-name changes open the same box as today, with Don't add / Restore in it. One line to change if Steve wants one-click.
- **Colours come from the app's palette**, both light and dark — the design file is dark only and hard-coded.
- **"Primary role: A → B" is said once in the section** (under the box) and once in the summary, not three times.
- Nothing about what a move does changes: no backend change, no migration, no ADR.

## Build

- New `access/requestWindow.tsx` — the shared pieces COM-899 reuses: `RequestWindow` (Modal.Root composition: fixed header with subtitle, scrolling two-column body, fixed footer), `RequestSection` (numbered card; numbers from a CSS counter in `index.css`, so a section that isn't shown takes no number), `ChangeRow`, `KeptList`, `DetailPill`, `SummaryChange` / `SummaryCount`.
- `MoverStayingGroups.tsx` splits into the manual-group change row and the kept lists; `MoverMailboxes.tsx` likewise; `MoverAccountDetails.tsx` gains the "Changed" mark and can leave its heading and its list of changes to the window (the approval editor keeps both).
- New `MoverSummary.tsx`.
- `RaiseRequestModal.tsx`: the mover renders in `RequestWindow`; the other five keep the old window until COM-899.
- Group labels for tests and screen readers: "Managed group changes", "Manual group changes", "Shared mailbox changes"; "Role groups", "Manual groups", "Dynamic groups", "Shared mailboxes".

## Done when

- The move window matches the design at 1180px and wraps to one column when narrow, in light and dark.
- Everything the old window could do, the new one does: keep a role, change details, add/remove a group, add/remove a mailbox, the "no roles after this move" confirm, expedited.
- Checked in a real browser (headless Chromium harness), not only jsdom.

## Smoke test (Steve — Safari)

1. Access → Raise → Move someone. Pick yourself: six numbered boxes on the left, the summary on the right.
2. Change the primary role: "Changes from …" under it, the summary shows it, Access changes fills in.
3. Change First name: "Changed" appears, the summary gains a line; "Leave as it is" takes both away.
4. In section 5 open Manual groups, type in the filter, click a group, Remove: it appears under Manual groups → Removing, and the summary says −1.
5. "+ Add a shared mailbox", pick one: it appears under Shared mailboxes → Adding.
6. Scroll: the title, the summary and the buttons stay in view.
7. Narrow the window: the summary drops below the sections.