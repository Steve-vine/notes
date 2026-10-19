---
id: 01M59GECGCPXB2HF0A285RGFPD
created: 2026-10-19T07:19:02.924904Z
updated: 2026-10-19T07:19:56.763788Z
type: task
title: Frontend tests load only what each test needs, not the whole app, so the frontend suite takes about half as long
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1106
sprint: sjlj05e
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Sprint 77, CI / Build optimisation. Raised 2026-10-19 from the review of sprint 77's tasks. Start after sprint 76 is on staging.

## Why

Vitest's own timing for PR run 39189060622 (221 files, 2,459 tests):

`Duration 1137.68s (transform 10.41s, setup 1205.85s, collect 9.20s, tests 837.98s, environment 135.57s, prepare 23.59s)`

**Setup costs more than the tests do.** `src/test-setup.ts` (a setupFile, so it runs for every test file) imports `drainQueryClients` from `src/test-utils.tsx`, and `test-utils.tsx` imports `appRoutes` from `App.tsx`. App.tsx has 81 eager imports and no lazy routes, so every test file loads every screen in Compass — Excalidraw, React Flow, charts and all — before it runs a single test, including pure-logic `.test.ts` files.

Only **5** test files use `renderApp`, the one helper that needs `appRoutes`. (Memory: "vi.mock too late via test-utils" is the same root cause showing up differently.)

## What changes

- Each test file loads the screens it tests, plus the shared providers — not the whole app.
- The few tests that render the whole app keep doing so, through their own helper.
- Nothing about what is tested changes.

## Notes (technical)

- Move `renderApp` (and the `appRoutes` import) into its own module, e.g. `src/test-app.tsx`; point the 5 callers at it.
- Move `drainQueryClients` and `activeQueryClients` into a tiny module with no app imports (e.g. `src/test-query-clients.ts`) so `test-setup.ts` stops importing `test-utils.tsx` at all. `renderWithProviders` registers clients there.
- Check nothing else in `test-utils.tsx` imports a screen. `UnsavedChangesProvider` and `theme` are fine.
- After the move, some tests may have relied on a module being loaded as a side effect (registrations, `vi.mock` ordering). The full suite must pass; fix those tests directly rather than re-adding the import.
- Measure: record Vitest's `Duration (…)` line before and after, in CI and locally, in the PR. Expect `setup` to fall from ~1,200s to well under 200s.
- Lint, typecheck (`npm run typecheck`, i.e. `tsc -b`), Prettier, and the **full** vitest run (memory: screen-conventions test) before pushing.

**Done when:** `test-setup.ts` no longer imports App; only the whole-app tests load App; Vitest's `setup` time is at least 70% lower in CI; before and after figures are in the PR.