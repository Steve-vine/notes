---
id: 01M7NKB8TYT4T4XQ0D471K1HDA
created: 2026-11-17T20:32:03.422486Z
updated: 2026-11-17T22:27:14.153014Z
type: task
title: 'All checks holds every check: Raise a gap and Enabled switches on each row, the Built-in Checks tab and the Since column go'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1899
sprint: s7nqsy0
comments:
- id: 01M7NSY4NMTYNBJ9HAY3X4RGA1
  author: Steve Vine
  at: 2026-11-17T22:27:13.204834Z
  text: |-
    Done — PR #1895, merged 3b520a53.
    Evidence Collection ▸ All checks now has every check, built-in and custom, and the Built-in Checks tab is gone.
    Each row has a Raise a gap switch and an Enabled switch. Whoever can change a check's settings can flip them in the list; everyone else sees them greyed out.
    Switching either one off asks first, in Compass's own dialog, and names the gap it will close, in the same words as the check's card and Edit. Switching on doesn't ask.
    The Since column is gone. There's a new Enabled filter (On / Off), kept in the address.
    An old Built-in Checks link opens All checks filtered to Built-in, and keeps its On/Off and state filters.
    On a phone the list shows ID, Check (with its state underneath) and Enabled, and doesn't pan sideways. "Raises its own gap" now reads "Raise a gap" on a built-in check's page and in its Edit.
    Assumptions: a proposed check that hasn't been approved isn't on All checks at all, so there's nothing to show "—" for. A built-in check's own Edit still uses the browser's confirm for its switches, as before; the list uses Compass's dialog.
    To check on staging: flip both switches on a built-in check and a custom check in E2E Test Company and look at the dialogs. Open /automation/evidence-collection?tab=builtin and check where it lands. Then look at the list at 390px wide. The Browser smoke now covers the switches and the redirect.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, 2026-11-17: drop the Built-in Checks tab so every check lives on All checks. Give each row a Raise a gap switch and an Enabled switch, and remove the Since column to make room.

Builds on COM-1897 (custom checks' Raise a gap). It ships with COM-1900.

**What changes on Evidence Collection ▸ All checks**
- **Two new switches on every row**, for built-in and custom checks:
  - **Raise a gap**
  - **Enabled**: switches the check on or off, the same as on its own page.

  A proposed check that hasn't been approved has neither switch and shows "—".
- **Who can change them:** whoever can change a check's settings today. Everyone else sees the switches but can't change them.
- **Switching either off asks first**, in Compass's own dialog, never the browser's. The dialog names the gap it will close, in the same words as the check's card and Edit. Switching on doesn't ask.
- **Since column:** removed, along with its sort.
- **New filter:** "Enabled" (On / Off), kept in the address like the other filters.
- **Built-in Checks tab:** removed. Old links to it open All checks filtered to Type: Built-in. What the tab showed:
  - a check's controls: changed in the check's Edit, as today
  - its thresholds: on its page
  - whether it raises its own gap, and whether it's on: on All checks
- **On a phone:** the list keeps ID, Check (with its state underneath) and Enabled, and doesn't pan sideways (COM-1892's test).
- "Raises its own gap" reads "Raise a gap" on the check's page and in its Edit.

**Done when**
- All checks shows Raise a gap and Enabled for every approved check. Both can be changed in the list by whoever may change a check's settings, and are read-only for everyone else.
- Switching either off asks first and names the gap it closes. Switching on doesn't ask.
- There's no Since column and no Built-in Checks tab. An old Built-in Checks link lands on All checks, filtered to built-in.
- The Enabled filter works and stays in the address.
- At 390px wide the list doesn't pan sideways.
- The Browser smoke covers the new switches and no longer opens Built-in Checks.