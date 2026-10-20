---
id: 01M5CQ7VP2AB3QZTZBBTDY2PYK
created: 2026-10-20T13:15:32.418001Z
updated: 2026-10-20T13:15:32.418001Z
type: task
title: Every document a visitor views or downloads is watermarked with their name, email, organisation and the date, so a copy passed on says where it came from
assignee: steve
priority: medium
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1164
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1162.

## What people see

Every page of every PDF a visitor opens or downloads carries:

- a light diagonal stamp across the middle: "Jane Smith · Acme Ltd";
- a footer line: "Shared with jane@acme.com by <company> on 20 Oct 2026 14:05 — confidential".

It's on library documents and uploaded evidence alike, viewed or downloaded. The stamp is light enough to read the document through.

Admins previewing a document in the module see it without a watermark.

## Notes (technical)

- Stamp at serve time: render an overlay page with `reportlab`, merge onto each page with `pypdf` (both already dependencies). Rotated pages and odd page sizes must still be stamped in the right place.
- Don't store watermarked copies; cache only the unstamped source.
- An encrypted or broken uploaded PDF is refused at upload (COM-1159) so serving can't fail on it. Add that check there if it isn't already.
- Watch memory and time on a large (e.g. 200-page SOC 2) report; stream if needed. A test with a multi-page fixture.

**Done when:** a downloaded document on staging carries the visitor's stamp and footer on every page, including a rotated page.