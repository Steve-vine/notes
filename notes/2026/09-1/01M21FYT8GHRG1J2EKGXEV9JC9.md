---
id: 01M21FYT8GHRG1J2EKGXEV9JC9
created: 2026-09-08T21:49:31.792881Z
updated: 2026-09-08T21:49:38.813525Z
type: task
title: 'Admin → Appearance: tune the light and dark palettes with a live preview'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 631
sprint: sa2t9sq
assignee: steve
label:
- feature
priority: low
task_status: backlog
---
Asked for by Steve while smoke-testing, 2026-09-08.

## How colour works today

Compass carries one hand-picked **brand** palette (ten shades of blue-teal) in code, and leans on the UI toolkit's built-in named palettes (grey, red, green, yellow, blue…) for everything else — backgrounds, borders, dimmed text, and the status pills. Light and dark mode are not two palettes: they are the same palettes with a different shade and background picked per scheme. Nothing is adjustable without a code change and a release.

## The feature

A new **Appearance** tab under Admin (for administrators who manage configuration, alongside Email and Files) that lets an administrator tune the colours Compass uses, per scheme, and see the effect before saving.

**Two panels, Light and Dark**, side by side, each always drawn in its own scheme no matter which the viewer is in. Each panel is a sample of the app: a block of page background, a card on it with a heading, a line of body text and a line of dimmed text, a primary button, a status pill or two, and a pair of table rows with the line between them. Beside each panel, a colour picker for each token:

- **Background** — the page behind everything
- **Surface** — cards, panels, the table
- **Border** — the lines between rows and around cards
- **Text** and **Dimmed text**
- **Accent** — the brand colour: buttons, links, the selected tab, focus rings

Changing a picker updates that panel immediately. Nothing is saved until **Save**; **Reset to defaults** puts the shipped palette back (still unsaved until Save). A contrast note beside Text and Dimmed text says whether the text still reads on the chosen background (AA or not), so a bad combination is visible before anyone else has to live with it.

**Once saved, the palette applies to everyone** on their next page load — it is how this organisation's Compass looks, not a per-person preference. People still choose light, dark or auto for themselves as now.

**Out of scope, deliberately.** The status pill colours (red for critical, green for done, and so on) are not tunable here — they carry meaning across every screen and were tuned for contrast on both schemes (COM-574). The fonts, spacing and radius are not touched. A second pass can open more up once the six tokens have proven themselves.

---

*Implementation notes.*

**Storage.** `models/appearance_settings.py` — singleton row (the `assessment_settings` idiom: always-true `singleton` + unique index), columns `light` JSONB and `dark` JSONB, each `{background, surface, border, text, dimmed, accent}` as hex strings; `updated_at`. No row = shipped defaults; migration seeds nothing. Audited (it is configuration somebody changed) — add to the ADR 0023 allowlist.

**API.** `GET /api/v1/appearance` — **any authenticated user** (everyone needs the palette to render); returns both schemes with defaults filled in where no row exists, plus `is_default: bool`. `PUT /api/v1/appearance` — `require_admin_configuration` (the guard Email/Files use); validates six `#rrggbb` per scheme. Drift script → `schema.d.ts`.

**Applying it.** `theme.ts` already exports a `cssVariablesResolver`; extend it to read a palette object and emit, per scheme block: `--mantine-color-body` (background), `--mantine-color-default` / card background (surface — check `Card`/`Paper`/`Table` read `--mantine-color-body` or `--mantine-color-default`; set whichever they use), `--mantine-color-default-border` (border), `--mantine-color-text`, `--mantine-color-dimmed` (dark already overridden — `DARK_DIMMED` becomes the default value), and the **brand tuple** regenerated from the accent hex with `@mantine/colors-generator`'s `generateColors` (10 shades; `primaryShade {light:7, dark:4}` stays, so the accent hex should land near shade 7 for light / 4 for dark — document the offset). `DARK_BODY` is consumed by the pill-flattening code and by `AssessmentsQueuePage.tsx:32` — make it read the dark background token, so pills stay opaque against whatever the background becomes. `main.tsx`: fetch the palette before mounting `MantineProvider` (a small pre-auth fetch; the endpoint is auth-only, so on the login page the shipped default shows — acceptable, and stated here as the assumption) and pass `theme` + resolver built from it; `cssVariablesResolver` is a function of the palette, so build it inside a `useMemo`.

**The tab.** `admin/AppearanceSection.tsx`, `value: 'appearance'`, `permission: 'admin.manage_configuration'` in `ADMIN_TABS`. Two `SchemePreview` components, each a `<div data-mantine-color-scheme="light|dark" style={{ ...cssVarsFor(draft[scheme]) }}>` — Mantine's variables are plain CSS custom properties, so an inline override on a wrapper re-themes just that subtree; the sample elements inside are ordinary `Card`, `Button`, `StatusPill`, `Table`. Six `ColorInput`s per scheme (`format="hex"`, `swatches` = the shipped defaults). Draft in `useState`, seeded from the query; Save → `PUT` → invalidate; Reset → draft = defaults. Contrast: a tiny WCAG ratio helper (relative luminance) rendered as `Text size="xs"` "4.6:1 AA" / "2.9:1 fails AA" beside Text and Dimmed. Hooks-lint: seed the draft with `key={data.updated_at}` rather than setState-in-effect.

**Tests.** Backend integration: GET with no row returns defaults + `is_default`; PUT rejects a bad hex (422) and a non-admin (403); GET after PUT returns what was saved. Frontend: pickers update the preview's inline variables; Save calls PUT with both schemes; Reset restores defaults; contrast note flips at the AA threshold. Extend `AdminPage.test.tsx` or add one section test (parallel-suite flake — prefer extending).