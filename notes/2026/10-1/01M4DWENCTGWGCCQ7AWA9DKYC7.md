---
id: 01M4DWENCTGWGCCQ7AWA9DKYC7
created: 2026-10-08T13:50:10.842553Z
updated: 2026-10-09T13:46:53.932809Z
type: task
title: 'Business role page: the "New starters go in" list opens twice as long'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 869
sprint: sme8esk
comments:
- id: 01M4E1VSHF9V1TJ7DSZWE3VCFT
  author: Steve Vine
  at: 2026-10-08T15:24:43.951578Z
  text: |-
    Done — PR #868, merged to main 2026-10-08. Not yet on staging (deploys with the rest of the sprint).

    What changed: on a business role's page, the "New starters go in" list opens to 440px — about twelve OUs before it scrolls, twice what it was. The same picker on Admin ▸ Integrations is unchanged.

    Built on the "taller" reading of "twice the length". If the box should be twice as wide instead, say so — that is a different change (see "If it's width" in the body).

    To check in the smoke test: open the list on a short browser window. It should flip above the box rather than run off the bottom; this was not checked in a browser.
- id: 01M4GENC3CQ8MPFFRZECZDCNGR
  author: Steve Vine
  at: 2026-10-09T13:46:53.93259Z
  text: On staging 2026-10-09 (5161e64a).
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Asked for by Steve while testing access control on staging, 2026-10-08: "On the business role edit page, make the 'New starters go in' dropdown box twice the length."

## What people see

On a business role's page, in the Details panel, opening **New starters go in** shows a list of OUs that is **twice as long as today** — about twelve rows before it scrolls, instead of about six. The OU tree is deep, and six rows means scrolling as soon as one branch is opened.

**Reading of "length" (mine, to confirm with Steve):** the opened list drops twice as far. If he meant the box should be twice as *wide*, see "If it's width" below — it is a different change.

Only this page. The same picker on Admin ▸ Integrations ▸ Active Directory is left as it is unless Steve asks.

## How (implementation)

- `access/RoleDetailPage.tsx:231` — the `<OuSelect label="New starters go in" …>` in the side panel.
- `components/OuSelect.tsx` wraps Mantine `Select` and passes other props through. Nothing sets `maxDropdownHeight`, so the list gets Mantine's default of 220px. Pass `maxDropdownHeight={440}` at this call site.
- The side column is sticky near the top of the page (`DetailColumns`, `components/kit/DetailLayout.tsx:103`), and this field is the last in the panel — check on a short window (e.g. 768px high) that a 440px list still opens fully on screen, flips above the box, or shrinks, rather than running off the bottom.
- jsdom hides a floating dropdown when its target re-renders (known Mantine quirk) — assert the prop, not pixels.

## If it's width

The box already fills the side panel, which is 280–320px wide (`flex: '0 1 320px'`). It cannot be made twice as wide where it sits. Options, if that is what Steve wants: let the opened list be wider than the box (`comboboxProps={{ width: 640, position: 'bottom-end' }}`) so long OU names and deep indents fit; or move the field out of the side panel into the main column.

## Done when

- [ ] The opened list shows about twice as many OUs before scrolling.
- [ ] It stays on screen on a short window.
- [ ] The Admin ▸ Integrations picker is unchanged.