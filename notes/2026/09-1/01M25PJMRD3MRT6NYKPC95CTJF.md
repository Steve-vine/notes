---
id: 01M25PJMRD3MRT6NYKPC95CTJF
created: 2026-09-10T13:02:10.701534Z
updated: 2026-09-10T13:02:14.4019Z
type: task
title: The PDF keeps the template's fonts — Calibri, Cambria, Arial and friends render in their metric-matched open equivalents, not DejaVu
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 658
sprint: s9q4m6q
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Found reviewing the Content section on staging, 2026-09-10. A template whose title is set in Calibri Light exports to a PDF in a plainly different font.

## Cause

The PDF is rendered by LibreOffice in the worker container, and the only font family the image installs is `fonts-dejavu-core` (`app/backend/Dockerfile`). A Word template names its fonts; it does not carry them. Every name the container lacks — Calibri, Calibri Light, Cambria, Arial, Times New Roman, Segoe UI — is substituted by fontconfig, and with nothing else installed that means DejaVu Sans for everything. The screenshot on COM-648 is DejaVu Sans.

Microsoft's fonts cannot be redistributed, so the fix is the metric-compatible open fonts that LibreOffice and Google Docs use for the same purpose: same glyph widths, so line breaks and page counts match Word.

## Fix

- **Install in the image** (Debian packages, all free licences):
  - `fonts-crosextra-carlito` — Calibri
  - `fonts-crosextra-caladea` — Cambria
  - `fonts-liberation2` — Arial, Times New Roman, Courier New (Liberation Sans / Serif / Mono)
  - `fonts-gelasio` if packaged in the base image's Debian release, else skip — Georgia
  - `fonts-noto-core` — a good sans fallback for Segoe UI and anything else unknown, and wide Unicode coverage
- **Alias file** at `/etc/fonts/local.conf` (or `conf.d/60-compass-aliases.conf`) so names fontconfig does not already map are covered: `Calibri Light` → Carlito (no light face exists; regular is the honest substitute), `Segoe UI` / `Segoe UI Light` / `Segoe UI Semibold` → Noto Sans, `Georgia` → Gelasio or Noto Serif, `Verdana` / `Tahoma` → DejaVu Sans (already metric-close). fontconfig's `30-metric-aliases.conf` handles Calibri / Cambria / Arial / Times / Courier once the packages are present.
- Keep `fonts-dejavu-core` as the last resort.
- Check the `fc-match` output for each name in the image as part of the PR (`fc-match "Calibri Light"` → Carlito).
- Bump `_RENDERER_VERSION` in `tasks/pdf.py` so cached PDFs re-render with the new fonts.
- **Templates help text** (the placeholder alert on the Templates tab, `content/components.tsx`): one line saying which fonts render faithfully in the PDF — Calibri, Cambria, Arial, Times New Roman, Courier New, Georgia — and that any other font is substituted. That is the rule an author needs; the mechanism is not.

## Not in scope

Uploading real font files so the true Calibri renders. Possible later — the renderer already runs with a throwaway `HOME`, so dropping uploaded `.ttf` files into `$HOME/.fonts` before conversion would work — but it needs a font-licensing decision and an admin screen. Raise separately if the metric matches are not close enough.

## Done when

The template from the screenshot exports with its title in Carlito (visually Calibri) and body text in the family the template names, not DejaVu Sans; page count matches the same document printed to PDF from Word within a page.