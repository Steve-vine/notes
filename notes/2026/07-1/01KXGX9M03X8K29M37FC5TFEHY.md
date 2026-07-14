---
id: 01KXGX9M03X8K29M37FC5TFEHY
created: 2026-07-14T18:12:44.67578281Z
updated: 2026-07-14T18:12:44.67578281Z
type: task
title: xlsx/pptx PDF export fails on the worker — LibreOffice Calc/Impress missing from the image
label: bug
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 149
---
Clicking / exporting an uploaded **.xlsx** fails with:

> LibreOffice conversion failed: Warning: failed to launch javaldx … dconf-CRITICAL … unable to create directory '/home/compass/.cache/dconf': Permission denied … Fontconfig error: No writable cache directories …

**Root cause (reproduced in a bookworm container matching the image):** the backend image installs only `libreoffice-writer` (Dockerfile), so there is **no Calc import filter** — `soffice --convert-to pdf in.xlsx` reports "Error: source file could not be loaded" and produces no output. The code then surfaces stderr, which contains only the secondary noise: the `compass` user is created `--no-create-home`, so dconf/fontconfig can't write their caches. **.pptx** has the same latent failure (needs Impress). `.docx` works because Writer is installed.

**Fix:**

* Dockerfile: install `libreoffice-calc` + `libreoffice-impress` alongside `libreoffice-writer` (the upload allow-list and PDF-export whitelist already advertise docx/xlsx/pptx).
* `pdf_render.py`: point `HOME`/`XDG_CACHE_HOME`/`XDG_CONFIG_HOME` at the throwaway temp dir for the `soffice` subprocess, so the caches are writable regardless of the image user (kills the dconf/fontconfig noise that was masking the real error), and include stdout in the failure detail.

Verified in-container: writer-only + uid 10001 → xlsx load fails; +calc with the same invocation → PDF produced.

---
*Migrated from Linear [DEV-803](https://linear.app/stevevine/issue/DEV-803/xlsxpptx-pdf-export-fails-on-the-worker-libreoffice-calcimpress) · created 2026-07-03 · completed 2026-07-04*