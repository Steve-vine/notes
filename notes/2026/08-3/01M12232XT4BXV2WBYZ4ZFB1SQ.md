---
id: 01M12232XT4BXV2WBYZ4ZFB1SQ
created: 2026-08-27T16:50:44.282852Z
updated: 2026-08-27T19:38:57.159813Z
type: task
title: One failing panel takes the whole app with it — there is no error boundary
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 467
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