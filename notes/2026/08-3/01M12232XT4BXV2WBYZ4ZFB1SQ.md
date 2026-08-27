---
id: 01M12232XT4BXV2WBYZ4ZFB1SQ
created: 2026-08-27T16:50:44.282852Z
updated: 2026-08-27T19:48:37.471557Z
type: task
title: One failing panel takes the whole app with it — there is no error boundary
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 467
comments:
- id: 01M12C8SYZS6BY49ATXSYP0WR5
  author: Steve Vine
  at: 2026-08-27T19:48:37.471367Z
  text: |-
    Done — PR #453, merged and deployed to staging 2026-08-27.

    Two boundaries, as decided in the PR:

    - Around the routed page, inside both shells. Header, sidebar, company switcher and search stay live; the page shows an apology with Try again and Go back. Reset on path change via a prop rather than React's key — keying would rebuild the subtree on every navigation, throwing away scroll position and half-typed input between two vendors to solve a problem that only exists after a failure.
    - Around everything, outside the router, for a failure in a shell itself. Offers a reload, because there is no navigation left to use.

    Deviation from the task's second candidate: NOT around each modal. A modal's React tree is a child of its page, so the route boundary already catches it and keeps the shell alive. Covering the inside of each modal means touching 48 call sites or introducing a wrapper and migrating all 48 — a sprinkle, for the difference between "this page couldn't be shown" and "this dialog couldn't be shown". Raise a follow-up if the finer message is wanted.

    Reporting: POST /api/v1/client-errors takes message, path, JS stack, component stack and which boundary caught it, and logs at ERROR with client_-prefixed fields. Signed-in callers only (get_current_user, not a section — a portal account's broken screen counts the same as an admin's), every field bounded.

    Fell out of it: migrations/env.py called fileConfig with its default disable_existing_loggers=True, which switched off every compass_api.* logger imported before migrations ran, for the life of the process — logger.error() became a silent no-op with no error and no record. Harmless in the Helm migration job; in-process it meant no test could prove anything about application logging. One keyword. Full integration suite re-run after it: 1034 passed.

    Limit, as the task asked it be stated: React error boundaries catch render errors, not event handlers or async callbacks. This fixes the whiteout, not every failure.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: high
task_status: done
---
When any part of a screen fails to render, Compass goes white. Not the panel that broke — the entire application, back to a blank page, recoverable only by reloading. Whatever you had typed is gone.

That is what COM-442 looked like from the outside: a modal flashed and the screen went white. The underlying defect was one picker looping, but the *reported* symptom was total loss of the app, and it read as catastrophic because there is nothing anywhere to catch it.

## What changes for the reader

**A screen that fails says so, in place.** The panel or page that broke shows a short apology and a way to retry or go back; the header, the navigation and everything else stay on screen and keep working. Nothing that has been typed elsewhere is lost.

**A failure is reported rather than silent.** Whatever broke reaches the logs with enough to identify it, instead of only existing in a user's browser console.

## Why it is worth doing now rather than after the next one

This is a severity multiplier on every future defect. Any render error in any component — a field arriving null, a list shape changing, a date that will not parse — becomes "the app is down" instead of "that panel is broken". Two of this sprint's defects were in the same picker; the next one will be somewhere else, and it will look just as bad.

The cost is small and one-off. The benefit applies to code that has not been written yet.

## Scope

Decide where the boundaries sit, and say so in the PR. The obvious candidates:

- **Around the routed page**, so the shell (header, tab bar, company switcher) survives and you can navigate away.
- **Around each modal**, so a failing modal closes or shows an error rather than taking the page under it.

Panel-level boundaries everywhere are probably too fine — worth deciding deliberately rather than sprinkling.

React error boundaries do not catch errors in event handlers or async code, only in render. Worth knowing so the task is not oversold: this fixes the whiteout, not every possible failure.

## Tests

A component that throws on render, asserted to leave the surrounding shell intact and to show the fallback. That is the whole contract, and it is cheap to assert.

## Origin

Noted while fixing COM-442, where it was explicitly out of scope. Raised now rather than left in a commit message.