---
id: 01M3SSYNG7G0N7PH6XS02CJ7NK
created: 2026-09-30T18:41:40.87147Z
updated: 2026-09-30T18:41:40.87147Z
type: task
title: The new look lands on every page — Nocturne colours in light and dark, Inter, the new status colours — and Admin ▸ Appearance goes
label: feature
priority: high
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 796
---
Part of sprint 65, UI Upgrade (ADR in COM-794). This is the change everyone notices first. Every page, in both portals too, takes the new colours and typeface in one go, before any layout changes. Until each page's section task lands, it keeps its old arrangement but wears the new look.

## What people see

- **Dark:** a quiet blue-grey ground with a violet accent used for lines, marks and the selected item, never large fills.
- **Light:** the prototype's light variant, a pale grey-blue ground with a deeper violet.
- **Light or dark follows the computer's setting**, as today. The theme toggle overrides it and is remembered.
- **Text is Inter**, headings at medium weight. Corners are softer (8px) and spacing is a little denser.
- **Statuses share one set of colours:** green for good, amber for warning, orange for high, red for bad, grey for muted.
  - The same meaning is the same colour on every screen.
  - Every pill stays readable in both schemes, and a pill still never cuts its label short.
- **Admin ▸ Appearance is gone.** An organisation that had picked its own colours now sees the new look like everyone else.

## Notes (technical)

- **Tokens.** Take them from the design system's `styles.css` (`--color-*` ramps 100–900, radius, space, shadows) and the prototype's `[data-theme="light"]` block. Read both via DesignSync from project `891a3126-6ab8-4868-8550-6f744d19c0c1`.
- **The fixed palette.** Replace the palette machinery in `src/theme.ts` and `src/appearance/palette.ts` with one fixed token set per scheme:
  - `brand` = the accent ramp;
  - Mantine `dark` = the neutral ramp;
  - `--mantine-color-body`, surface, border, text and dimmed mapped from the tokens.
- **Status tones.** Retune `components/statusColors.ts` to the prototype's `TD` (dark) and `TL` (light) values.
  - Keep the COM-574 principle that a pill is **opaque**, blended once against the surface, so its contrast is a number we can promise.
  - Re-derive the pill families from the new tones.
  - Mind [[mantine-autocontrast-needs-shade]].
- **Inter.** Bundle it locally (e.g. `@fontsource-variable/inter`) rather than loading it from a CDN, and set it in `fontFamily` and `headings`.
- **Retire Appearance:**
  - Remove `admin/AppearanceSection.tsx`, its Admin tab, and `appearance/hooks.ts`.
  - Remove the palette fetch in `AppearanceProvider.tsx`, which keeps only the colour-scheme manager.
  - Backend: remove `api/v1/appearance.py`, its router entry, `models/appearance_settings.py` and its schemas.
  - Add a migration that drops `appearance_settings` (with a downgrade that recreates it).
  - Remove the audit entry in `db/audit.py`.
  - Regenerate `schema.d.ts`.
- **Tests.** Update `theme.test.tsx` and `palette.test.ts` to assert against the fixed tokens:
  - body text 4.5:1 or better on the ground and on the surface;
  - dimmed text 4.5:1 or better;
  - every pill family's label on its ground 4.5:1 or better, in both schemes.

**Done when:** staging shows the new look in light and dark on every page, including the portals, with no Appearance tab. The contrast tests pass.