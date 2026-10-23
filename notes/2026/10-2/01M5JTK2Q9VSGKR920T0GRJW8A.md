---
id: 01M5JTK2Q9VSGKR920T0GRJW8A
created: 2026-10-22T22:09:32.393158Z
updated: 2026-10-23T18:06:19.78883Z
type: task
title: Download the evidence pack — a zip of the evidence the approved answers rely on, only what may be shared, every PDF watermarked for the client, with an index of question to file
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1262
sprint: s5uw2fz
blocked_by:
- 01M5JTJWW3G80YFB8J4D712JYM
comments:
- id: 01M5MM3A7WS26CWB7E5WC77H6V
  author: Steve Vine
  at: 2026-10-23T14:54:33.212319Z
  text: |-
    Done — merged in #1279 (09642f07, migration 0670_ddq_packs).

    - An **Evidence pack** card on the DDQ (Manage DDQs) once it's In review. Before downloading it says what the pack will hold — "14 files · 3 held back" — and lists what's **Left out** and why ("held back — see Held back", or "unavailable: archived …").
    - **Download** makes the pack and saves "DDQ-7 evidence pack 2026-10-23.zip". "Last made … by … · Save it again" downloads the last one again. Making and downloading are in History.
    - It holds only evidence on approved answers, only what the sharing rules allow for this DDQ's NDA position, plus anything an Admin released. Each file once; one folder per section (flat for a short pack); policies and standards as house-style PDFs.
    - **Every PDF is stamped** "Shared with Northwind Legal · DDQ-7 · 23 Oct 2026", index included. `index.pdf` lists question → file → fingerprint and never names anything held back. An email DDQ's reply ends with a line about the attached pack.
    - The pack that was downloaded is kept as it was, so Mark as sent can freeze exactly what went out.

    My calls:
    - Held-back items are counted for you but never named in the pack, because the pack goes to the client.
    - Something that can't be sent — archived, deleted, an expired trust centre document, a PDF that can't be stamped — is "unavailable", and is never sent unstamped.
    - An evidence file replaced since it was attached goes as its current version.
    - An approved answer that's since become held back (NDA lapsed) sends none of its evidence unless released — consistent with the completed questionnaire.
    - Each build is kept with its list of contents; older builds' zips are removed except the newest and the newest downloaded.
assignee: steve
label:
- feature
priority: high
task_status: done
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