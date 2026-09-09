---
id: 01M21FYT8GHRG1J2EKGXEV9JC9
created: 2026-09-08T21:49:31.792881Z
updated: 2026-09-09T18:20:19.775822Z
type: task
title: 'Admin → Appearance: tune the light and dark palettes, pill colours included, with a live preview'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 631
sprint: sa2t9sq
comments:
- id: 01M21NTA9MZW725GD1RV2JTZFR
  author: Steve Vine
  at: 2026-09-08T23:31:55.828233Z
  text: 'Done — PR #640 merged to main. Admin → Appearance (admin.manage_configuration, beside Email): Light and Dark panels each drawn in their own scheme via a nested MantineProvider scoped to the panel, fed the same theme/resolver the app root builds from the palette; pickers for the six base tokens and the eleven pill families, each with an AA contrast note; Save (PUT both schemes) and Reset to defaults (unsaved). Storage: one audited singleton row `appearance_settings` (light/dark JSONB, migration 0173); no row = shipped defaults, which are the toolkit''s own values so an untouched install is unchanged. GET /appearance for anyone signed in (defaults + is_default alongside), PUT for configuration managers, validating #rrggbb and all families. `appearance/palette.ts` derives ten shades per family from one hex and writes the scheme''s CSS variables (page ground via a new --app-background, surface, border, text, dimmed, brand shades, family shades + light tints, COM-574 dark pill grounds over the chosen surface). The provider now waits for the palette before painting; signed out the login page wears the default. PILL_FAMILIES is pinned by a guard test to the colours the pills use. Note: my own 10-shade generator rather than @mantine/colors-generator (not installed; npm is flaky here) — anchor shade exact, HSL ladder either side. Awaiting the sprint deploy to staging for smoke test.'
assignee: steve
label:
- feature
priority: low
task_status: done
---
Asked for by Steve while smoke-testing, 2026-09-08. Pill colours added to scope the same evening.

## How colour works today

Compass carries one hand-picked **brand** palette (ten shades of blue-teal) in code, and leans on the UI toolkit's built-in named palettes (grey, red, green, yellow, blue…) for everything else — backgrounds, borders, dimmed text, and the status pills. Light and dark mode are not two palettes: they are the same palettes with a different shade and background picked per scheme. Nothing is adjustable without a code change and a release.

## The feature

A new **Appearance** tab under Admin (for administrators who manage configuration, alongside Email and Files) that lets an administrator tune the colours Compass uses, per scheme, and see the effect before saving.

**Two panels, Light and Dark**, side by side, each always drawn in its own scheme no matter which the viewer is in. Each panel is a sample of the app: a block of page background, a card on it with a heading, a line of body text and a line of dimmed text, a primary button, one pill of every pill colour, and a pair of table rows with the line between them. Beside each panel, the pickers, in two groups.

**Base colours** — one picker each:

- **Background** — the page behind everything
- **Surface** — cards, panels, the table
- **Border** — the lines between rows and around cards
- **Text** and **Dimmed text**
- **Accent** — the brand colour: buttons, links, the selected tab, focus rings

**Pill colours** — one picker per colour *family*, labelled by what the family means, because one colour carries the same meaning on every screen (teal is "done / healthy" whether it is an assessment, a vendor or a request), and the pills that share it must keep matching:

- **Teal** — complete, healthy, approved
- **Green** — implemented
- **Red** — critical, failed, rejected
- **Orange** — high, overdue, needs attention
- **Yellow** — in progress, pending, medium
- **Blue** — informational, under review
- **Cyan**, **Indigo**, **Grape**, **Violet** — the secondary kinds (categories, roles, kinds of change)
- **Grey** — not started, cancelled, not applicable

Picking a new colour for a family re-tints every shade of it, so the light-mode pill (pale background, dark text) and the dark-mode pill (deep opaque background, light text — the COM-574 treatment) both follow. The exact labels come from the code's own mapping of status → colour; the list above is the shape, not the final wording.

Changing any picker updates that panel immediately. Nothing is saved until **Save**; **Reset to defaults** puts the shipped palette back (still unsaved until Save). A contrast note beside Text and Dimmed text, and beside each pill family, says whether the text still reads on its background (AA or not), so a bad combination is visible before anyone else has to live with it.

**Once saved, the palette applies to everyone** on their next page load — it is how this organisation's Compass looks, not a per-person preference. People still choose light, dark or auto for themselves as now.

**Out of scope.** Which *meaning* maps to which family (that "critical" is red) stays in code — you can make red a different red, not make critical blue. Fonts, spacing and radius are not touched.

---

*Implementation notes.*

**Storage.** `models/appearance_settings.py` — singleton row (the `assessment_settings` idiom: always-true `singleton` + unique index), columns `light` JSONB and `dark` JSONB, each `{background, surface, border, text, dimmed, accent, pills: {teal, green, red, orange, yellow, blue, cyan, indigo, grape, violet, gray}}` as hex strings; `updated_at`. No row = shipped defaults; migration seeds nothing. Audited — add to the ADR 0023 allowlist.

**Families.** The eleven names are exactly the distinct Mantine colour names `statusColors.ts` uses (`grep` count: teal 19, red 17, gray 15, yellow 13, orange 12, blue 8, grape 3, cyan 3, indigo 2, green 2, violet 1; `dark` once, skipped — it is the text colour, not a pill). Export `PILL_FAMILIES` from `statusColors.ts` with a human label + the meaning line for each, derived so the Admin tab and the mapping cannot drift. Defaults = Mantine's shade-6 hex for each family (the visual "identity" shade).

**API.** `GET /api/v1/appearance` — any authenticated user; both schemes with defaults filled in, plus `is_default`. `PUT /api/v1/appearance` — `require_admin_configuration`; validates every value is `#rrggbb` and every family key is present. Drift script → `schema.d.ts`.

**Applying it.** `theme.ts` `cssVariablesResolver` becomes a function of the palette. Per scheme block emit: `--mantine-color-body`, the surface variable `Card`/`Paper`/`Table` actually read (check `--mantine-color-default` vs `--mantine-color-body`), `--mantine-color-default-border`, `--mantine-color-text`, `--mantine-color-dimmed`; the brand tuple from the accent hex via `@mantine/colors-generator` `generateColors` (10 shades; `primaryShade {light:7, dark:4}` stays — document that the accent lands near shade 7 light / 4 dark). **Pills:** for each family, `generateColors(hex)` → emit `--mantine-color-<name>-0…9` in that scheme's block — Mantine's shade variables are per-scheme CSS custom properties, so light and dark can carry different tuples even though `theme.colors` cannot; then the existing COM-574 flattening (`--mantine-color-<name>-light`, `-light-hover`, `-light-color` from shade 9 / shade 3 against `DARK_BODY`) runs over the *generated* tuple, so dark-mode pills stay opaque and readable by construction. `DARK_BODY` becomes the dark background token (it is also read by `AssessmentsQueuePage.tsx:32`). `StatusPill` in dark mode uses `color="<name>.8"` filled + `autoContrast` — unchanged, it reads the variables. `main.tsx`: fetch the palette before mounting `MantineProvider` (auth-only endpoint — the login page shows the shipped default; stated assumption); build `theme` + resolver in a `useMemo`.

**The tab.** `admin/AppearanceSection.tsx`, `value: 'appearance'`, `permission: 'admin.manage_configuration'` in `ADMIN_TABS`. Two `SchemePreview`s: `<div data-mantine-color-scheme="light|dark" style={cssVarsFor(draft[scheme])}>` — an inline override on a wrapper re-themes just that subtree, including the generated `-0…9` and `-light*` variables — containing ordinary `Card`, `Button`, a `StatusPill` per family (`variant` chosen by the wrapper's scheme, not the page's: pass a `scheme` prop or read `useComputedColorScheme` from a nested provider — check `StatusPill.tsx:1` uses the hook, so the preview needs a nested `MantineProvider forceColorScheme`), and a two-row `Table`. `ColorInput format="hex"` per token and per family, `swatches` = shipped defaults. Draft in `useState` keyed on `data.updated_at`; Save → `PUT` → invalidate; Reset → defaults. Contrast helper (relative luminance → ratio; AA ≥ 4.5 body, ≥ 3 for pill label size if the pill text is ≥ 14px bold, else 4.5) beside Text, Dimmed and each family — for pills, check label-on-background in *that* scheme's rendering (shade 8 filled in dark, `-light` tint in light).

**Tests.** Backend integration: GET with no row returns defaults + `is_default`; PUT rejects a bad hex, a missing family (422) and a non-admin (403); GET after PUT round-trips. Frontend: a base picker updates the preview's inline variables; a family picker changes that family's `-6` variable and the matching pill's computed background; Save calls PUT with both schemes and all eleven families; Reset restores defaults; contrast note flips at threshold; `PILL_FAMILIES` equals the set of colours `statusColors.ts` uses (a guard test so a twelfth colour cannot arrive untunable). Extend `AdminPage.test.tsx` or add one section test (parallel-suite flake — prefer extending).