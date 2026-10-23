---
id: 01M5JTK2Q9VSGKR920T0GRJW8A
created: 2026-10-22T22:09:32.393158Z
updated: 2026-10-23T10:00:08.547807Z
type: task
title: Download the evidence pack — a zip of the evidence the approved answers rely on, only what may be shared, every PDF watermarked for the client, with an index of question to file
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1262
sprint: s5uw2fz
blocked_by:
- 01M5JTJWW3G80YFB8J4D712JYM
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — API

## What people see

**Evidence pack ▸ Download** on the DDQ:
- One folder per section (or flat, for a short DDQ). The files are the evidence attached to approved answers, de-duplicated. Policies and standards are rendered as PDFs in the company's house style.
- **Only what the sharing rules allow**, or what an Admin released. A summary before download says "14 files · 3 held back (see Held back)".
- **Every PDF is watermarked** "Shared with Acme Ltd · DDQ-7 · 22 Oct 2026" (the trust centre stamp). Other file types go in as they are.
- **index.pdf**: question reference → file name → fingerprint (SHA-256), plus the company, DDQ and date.

**Done when:** a pack for a DDQ with no NDA leaves out the Sensitive files, includes a released Confidential one, and every PDF carries the stamp.

## Notes (technical)

- Reuse the trust centre stamping (reportlab + pypdf) and the audit pack zip/fingerprint code (sprint 82). Built in a Celery task for large packs, with the download link on the DDQ.