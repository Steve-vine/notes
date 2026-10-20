---
id: 01M5DKCRP76CZWGFWJRTR4GRMC
created: 2026-10-20T21:27:33.319482Z
updated: 2026-10-20T21:54:55.848061Z
type: task
title: Pillow 12.3.0 — eight new advisories (fixed in 13.0.0) fail the dependency scan on every PR
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1189
sprint: sq3fav7
comments:
- id: 01M5DMYTFP9MYF49V68A9AC0XM
  author: Steve Vine
  at: 2026-10-20T21:54:53.558356Z
  text: 'Done — merged in PR #1169. Compass now uses Pillow 13, the image library behind pictures in templated documents and document rendering. That clears the eight advisories that were failing every pull request''s dependency check from tonight. No visible change: I ran 189 picture, house-style and PDF tests on the new version and all passed. I raised this during sprint 81 because it blocked the sprint''s pull requests.'
assignee: steve
label:
- chore
priority: urgent
task_status: review
---
Found 2026-10-20 22:27 BST while shipping sprint 81 (PR #1168): `deps-scan` (pip-audit) reports pillow 12.3.0 → CVE-2026-112395/112397/112400/112404/112895/112896/112897/112899, all fixed in 13.0.0. Not caused by any PR — every PR goes red until main has the fix.

## What changes

Nothing anyone sees. Pictures in templated documents (COM-992) and PDF rendering keep working on the new version.

## Notes (technical)

- Pillow is a direct dependency (`pillow>=12.3.0`, COM-992). Raise the floor to `>=13.0.0` and `uv lock --upgrade-package pillow`. A major version: check WeasyPrint 70 and reportlab accept it, and run the picture/rendering tests (test_content_images*, test_review_pdf, test_trust_centre_watermark, document render tests).

**Done when:** deps-scan is green on main and on the open sprint-81 PRs.