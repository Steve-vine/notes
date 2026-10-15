---
id: 01M50GP2TPQHR7APM04JVYF4K7
created: 2026-10-15T19:30:05.270168Z
updated: 2026-10-15T19:30:36.789Z
type: task
title: Word templates and LibreOffice are retired — every content type uses a house style, and Compass no longer carries an office suite
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 995
sprint: s2ufsxd
blocked_by:
- 01M50GJVGJ693A4RS0KN3A2EJ9
- 01M50GKX5FMQBWBZSWM5PZJ5JR
- 01M50GM94YF8A03SHS9A4QQGKZ
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Sprint 71, Improve templated content (ADR in COM-986). This is the last task of the sprint. **Merge only once Steve says the house style is right on staging** (COM-990).

## What people see

- **Admin no longer takes Word template uploads.** A content type maps to a house style only.
- **Today's Word templates aren't lost.** They are listed read-only under *House styles ▸ Old Word templates*, each with a download, so nothing that was uploaded disappears. Deleting them is a later decision.
- **A content type still mapped to a Word template** when this deploys moves to the default house style. Activity records the change.
- Sections no longer show or ask for a placeholder name.
- **Templated documents are now written, styled and exported entirely in Compass.** Uploaded, linked and managed documents are untouched.

## For production

- Before production is upgraded to a release containing this task, its house style is loaded from staging (COM-990's *Download* / *Load*). Otherwise production's PDFs change to the built-in style on the day of the upgrade.
- Put this in the release notes. The order is: load the style first, then map the content types, then upgrade.

## Notes (technical)

- **Remove:**
  - `core/pdf_render.py`;
  - the merge half of `core/templating.py` (COM-991 moved the numbering helpers out);
  - the template upload, rename and delete routes, and their frontend tab.
- **Dockerfile:**
  - drop `libreoffice-writer`, `-calc` and `-impress`, plus the apt font packages the renderer no longer needs; the fonts the house style uses are bundled with the app;
  - record the image size before and after in the PR;
  - check the arm64 build too (memory: arm64-build-binfmt-in-zot).
- **Migration (append-only):**
  - map every `content_types.template_id` to the default style, then make `style_id` NOT NULL;
  - keep `content_templates` and its column for history; drop nothing yet;
  - `placeholder` on sections becomes nullable and unused.
- **The PDF cache:** entries keyed to Word templates become unreachable. Leave them for the existing cleanup.
- **ADR 0030's §6 amendment** about the shared image is now moot. Say so in the COM-986 ADR's consequences, not by editing 0030.

**Done when:** on staging, no content type uses a Word template, every templated document exports to PDF, Word and plain text, the image no longer contains `soffice`, and its size has dropped.