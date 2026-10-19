---
id: 01M5A2WKBA78Y8V145GW1CJMNY
created: 2026-10-19T12:41:23.050419Z
updated: 2026-10-19T18:09:32.159817Z
type: task
title: An SVG saved after Compass has made a PDF keeps its normal form, instead of coming out with "ns0:" prefixes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1116
sprint: sjlj05e
comments:
- id: 01M5A5B0FA1J458T23R4M30E34
  author: Steve Vine
  at: 2026-10-19T13:24:12.39401Z
  text: |-
    Merged in PR #1107 (2026-10-19). sanitise_svg now writes plain element names with a literal xmlns, and xlink:/xml: spelled out, so its output never consults ElementTree's process-wide namespace table, and Compass no longer clobbers WeasyPrint's entry either.

    - Elements that opt out of the SVG namespace (xmlns="") are dropped by the allow-list.
    - tostring(default_namespace=…) was tried and doesn't work: it also rejects every unqualified attribute.

    Checked:
    - With weasyprint.pdf.metadata imported first, an SVG with <use xlink:href>, xml:space and <script> comes out as a plain <svg …> with the use and space kept, the script gone, and the SVG namespace intact on re-parse.
    - Two new regression tests.
    - Full unit suite 1,127 passed with the PDF tests running.
    - CI unit job green.

    Production effect until this deploys: any API or worker process that had made a PDF saved later SVG uploads and editor diagrams with ns0: prefixes. Those SVGs are valid XML and render as images. Ones already stored stay as they are; re-saving a diagram rewrites it.
- id: 01M5A6V7PWN0F1K1FTD1HN1CM1
  author: Steve Vine
  at: 2026-10-19T13:50:32.667976Z
  text: On staging 2026-10-19 13:49 UTC (bf723e00, images staging-20261019-1348), with the rest of sprint 77. The api, worker, beat and frontend pods all came up with 0 restarts, and the public URL returns 200.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Sprint 77 follow-up, found 2026-10-19 while running COM-1112 / COM-1115 on the new runner image.

## What happens

Every SVG Compass keeps is sanitised and written back by `compass_api/core/assets.py`. That code depended on a module-level `register_namespace("", SVG)` so the output has a plain `<svg …>` root. WeasyPrint's `weasyprint/pdf/metadata.py` runs `register_namespace('', '')` when it is imported, and in Python's XML library registering a prefix removes any other namespace using it. So **after a process first loads WeasyPrint's PDF code, every SVG sanitised in that process is written as `<ns0:svg xmlns:ns0=…>…</ns0:svg>`**.

- In production the API and worker images have Pango, so WeasyPrint loads on the first PDF export or render. After that, uploaded and editor SVGs (Mermaid, Excalidraw) are kept with `ns0:` prefixes. Valid XML, but not the form `test_assets.py` pins and inline rendering expects.
- CI hid it: the old runner image lacked Pango, so the 8 PDF tests skipped and WeasyPrint never loaded. The 2026-10-19 runner image (COM-1109) has Pango. WeasyPrint now loads at collection and `test_the_editors_own_diagrams_survive_sanitising` fails on every PR (#1105, #1106).

## Fix

- Serialise with `tostring(root, default_namespace=SVG)`, so the output doesn't depend on the global namespace table.
- Drop the module-level `""` registration, which also clobbered WeasyPrint's.
- Elements that explicitly opt out of the SVG namespace (`xmlns=""`) are dropped by the allow-list; they aren't SVG drawing elements, and `default_namespace` can't write them.
- Regression test: sanitise after `register_namespace("", "")` and still get `<svg `.

**Done when:** unit tests pass on the new runner image with the PDF tests running, and the regression test is in place.