---
id: 01M3SSYNG7G0N7PH6XS02CJ7NK
created: 2026-09-30T18:41:40.87147Z
updated: 2026-09-30T20:49:21.475208Z
type: task
title: The new look lands on every page — Nocturne colours in light and dark, Inter, the new status colours — and Admin ▸ Appearance goes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 796
sprint: s0zzctz
blocked_by:
- 01M3SSXGXPWVAWH64CKQR6KE1Z
comments:
- id: 01M3T18D4A10MWD9CRNRCWP43E
  author: Steve Vine
  at: 2026-09-30T20:49:20.010378Z
  text: |-
    Done: PR #807, merged to main (6950e47).

    What you'll see:
    - **A new look on every page, in both portals too:**
      - Dark: a quiet blue-grey page with slightly lighter cards and a violet accent.
      - Light: a pale grey-blue page, near-white panels and a deeper violet.
      - Light or dark still follows your computer, and the toggle still overrides it.
    - **Text** is Inter (bundled with Compass, so nothing loads from outside) at 14px, and headings are medium weight. Cards have softer corners.
    - **Buttons.** A main button is now a violet outline rather than a solid fill, as in the design.
    - **Pills.** Every status pill is a faint tint with its label in the status colour, in both schemes: green good, amber warning, orange high, red bad, grey muted.
      - Every label reads at 4.5:1 or better. In light mode a few labels are a shade deeper than the design's value to get there.
      - Teal and green are now the same "good" colour.
    - **Admin ▸ Appearance is gone,** and any colours chosen there no longer apply.

    Pages keep their current layout for now. They move to the new layouts as each section's task lands.

    One judgement to check on staging: the pill's colour is now carried by its label rather than its background, as the design does it. If "Does this and more" and "Does part of this" on a framework's coverage still look too alike, it's a one-line change.

    All checks passed, including the backend integration tests and 1,475 frontend tests.

    Not on staging yet. It goes out with the other sprint tasks once all five are in review.
assignee: steve
label:
- feature
priority: high
task_status: review
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