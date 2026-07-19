---
id: 01KXGSM2NNE1H46XS5NAP87QDD
created: 2026-07-14T17:08:33.077965844Z
updated: 2026-07-19T21:30:28.48231755Z
type: task
title: Theme foundation + light/dark toggle
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 52
sprint: s9nk96f
comments:
- id: 01KXGSMCPV6MQW48Y0D3TQF4PZ
  author: Steve Vine
  at: 2026-07-14T17:08:43.35501031Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-18 19:50 UTC]
    **Done — in review.** PR [#49](https://github.com/Steve-vine/compass/pull/49). First M7 brief; implements ADR 0022.

    **What was built** — `theme.ts` (teal `createTheme`: primaryShade 6/5, Inter + bolder headings, md radius, teal→cyan gradient); `main.tsx` theme + `localStorageColorSchemeManager` (`compass-color-scheme`, default `auto`); `index.html` no-flash pre-paint script; `ThemeToggle` (Light/Dark/System) in the top bar; theme wired into `test-utils`.

    **Note** — screenshots weren't possible from the build sandbox (no browser; Chromium's system libs need sudo apt, which was denied). Verifying instead by deploying so it can be viewed live.

    **Checks** — green locally: `npm run lint`, `npm run typecheck`, `npm run format:check`, `npm test` (76, incl. 2 new toggle tests).
assignee: steve
task_status: done
priority: medium
---
The visual backbone of M7 (ADR 0022) — a custom Mantine theme + a user-controlled colour scheme. Everything else in the milestone reads these tokens. Modern & vibrant, teal accent; default follow-OS with a toggle.

**Agreed approach (planned 2026-06-18).**

- [ ] `src/theme.ts` via `createTheme`: `primaryColor: 'teal'` with a per-scheme `primaryShade` (e.g. `{light:6, dark:5}`); modern `fontFamily` + bolder `headings`; `defaultRadius: 'md'`, refined `shadows`, consistent spacing. Exported `theme`, wired into `MantineProvider` in `main.tsx` **and** `test-utils`.
- [ ] **Colour scheme**: `colorSchemeManager={localStorageColorSchemeManager({ key: 'compass-color-scheme' })}`, `defaultColorScheme="auto"` (default = follow-OS unchanged).
- [ ] **No flash**: inline script in `index.html` `<head>` applying the stored/`auto` scheme to `data-mantine-color-scheme` before React paints.
- [ ] `ThemeToggle` — Light / Dark / System menu (`useMantineColorScheme().setColorScheme`), persisted; placed in the `AppLayout` top-bar group (<issue id="485b6d88-65d1-40dc-89ca-3e3765452ad5" href="https://linear.app/stevevine/issue/DEV-470/shell-and-navigation-polish">DEV-470</issue> refines placement/branding).
- [ ] Tests: toggle renders + choosing Dark persists the scheme (`compass-color-scheme`); app renders under the theme.

Verify: run the app, capture before/after screenshots in light + dark.

Refs: ADR 0022 (design direction), 0003 (frontend), 0017 (IA).

---
*Migrated from Linear [DEV-469](https://linear.app/stevevine/issue/DEV-469/theme-foundation-lightdark-toggle) · created 2026-06-18 · completed 2026-06-18*