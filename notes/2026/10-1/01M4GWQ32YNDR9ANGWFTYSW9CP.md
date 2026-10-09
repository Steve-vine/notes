---
id: 01M4GWQ32YNDR9ANGWFTYSW9CP
created: 2026-10-09T17:52:30.302653Z
updated: 2026-10-09T17:52:33.793047Z
type: task
title: 'Leaver "Run at": the picker offers a time again, not only a calendar — the same in every browser'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 892
sprint: sme8esk
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Found by Steve on staging, 2026-10-09 (`ef5cfddf`): "On the Leavers Run At date/time, the popup only shows the calendar now, it used to show the time as well."

## What people see today

On a leaver request, clicking **Run at (optional)** opens a calendar with no way to pick a time. The time can still be typed into the box by hand, but nothing shows that, so a leaver gets scheduled for a day with whatever time the box happens to hold — or the person gives up on the time. A leaver's time matters: it is when the account is disabled, and now also the leave date written to Entra (COM-868).

## What people should see

- Clicking **Run at** offers a date **and** a time, in one popup, in every browser.
- Minutes can be chosen (five-minute steps is enough; any minute can still be typed).
- The time shown is the person's own local time, as now. A time in the past is still refused, as now.
- Clearing the box still means "run as soon as it is approved".
- The same picker is used where a waiting leaver's time is **moved** ("New time" on the request page) — that one has the same problem.

## Cause (not yet confirmed — confirm before fixing)

Nothing in Compass changed here. The box has been the browser's own date-and-time field since it shipped (COM-546) and no styling touches it; what pops up is drawn by the browser, not by Compass. Chrome and Edge draw a calendar with time columns; Firefox draws a calendar only and expects the time to be typed. So the likeliest explanation is a different browser, or a browser update, since Steve last used it. **First step: ask Steve which browser and version, and reproduce.** If it reproduces in Chrome/Edge, look again — that would not be explained by the above.

Either way the fix is the same: stop relying on the browser's popup.

## How (implementation)

- Two places, both `<TextInput type="datetime-local">`: `app/frontend/src/access/RaiseRequestModal.tsx` (~l.578, "Run at (optional)") and `app/frontend/src/access/RequestDetailPage.tsx` (~l.1123, "New time" when moving a scheduled leaver). The value is a local `YYYY-MM-DDTHH:mm` string turned into ISO with `new Date(value).toISOString()` — keep that contract so nothing server-side changes.
- Options, in order of preference:
  1. `@mantine/dates` `DateTimePicker` (not installed today — needs `@mantine/dates` pinned to the same exact version as `@mantine/core`, plus `dayjs`; see the charts version-pin memory for why the pin must be exact). One shared `RunAtInput` component used in both places.
  2. If adding the package is unwanted: split into a date box and a time box (`type="date"` + `type="time"`), which every browser draws properly. Less neat, no new dependency.
- Mantine's popup is a floating dropdown inside a modal: check it isn't clipped by the modal and that jsdom tests can still set a value (existing tests use `fireEvent.change` on the input — see `RequestsPage.test.tsx` for the scheduled-leaver cases; the Mantine Menu/jsdom memory covers the floating-dropdown pitfalls).
- No API, migration or OpenAPI change.

## Done when

- [ ] Browser and version confirmed with Steve, and the cause recorded here.
- [ ] Run at offers date and time in Chrome, Edge and Firefox.
- [ ] "New time" on a waiting leaver's request page does the same.
- [ ] A scheduled leaver raised with the new picker runs at the chosen local time (existing tests still pass; one new test sets a time through the picker).
- [ ] Empty still means "as soon as approved"; a past time is still refused.