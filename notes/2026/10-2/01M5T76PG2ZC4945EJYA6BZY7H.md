---
id: 01M5T76PG2ZC4945EJYA6BZY7H
created: 2026-10-25T19:04:39.170469Z
updated: 2026-10-25T19:04:39.170469Z
type: task
title: 'Trust Centre portal: a completed DDQ in the visitor''s area — download the completed file, each evidence file, or everything as one zip'
task_status: todo
label: feature
priority: high
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1323
---
## Behaviour

- **A DDQ shared with a visitor (COM-1322) appears in their Questionnaires area as Completed:**
  - their reference, or "Questionnaire from Acme Ltd", and the date it was completed;
  - **Completed questionnaire:** the client's own file with our answers, or the questions-and-answers spreadsheet. It downloads as the original type (.xlsx/.docx).
  - **Evidence:** each file listed by its folder (section) and name, with view (PDFs) and download;
  - **Download everything:** the evidence pack zip and the completed file together.
- **What they get is exactly what went out** (ADR 0124 §14), byte for byte from the stored copies.
  - The evidence PDFs already carry the pack's stamp ("Shared with Acme Ltd · DDQ-12 · 25 Oct 2026"). There's no second per-visitor stamp.
  - The completed questionnaire is the client's own file, unstamped, so their scoring formulas keep working. ADR 0126 records this exception to "every document is watermarked".
- **Ringfenced:** only the visitors it was shared with see it. Anyone else gets the ordinary "not found". Once sharing is stopped (COM-1324), or the visitor's access ends or is revoked, it's gone from their area.
- **Not behind the NDA click-through.** The DDQ's own sharing rules already applied the NDA position.
- **Every view and download is recorded** as a Trust Centre event against the visitor and the DDQ ("Downloaded completed questionnaire", "Downloaded Pen test summary.pdf", "Downloaded everything"), with the same de-duplication as documents (one view per file per visit per few minutes).
- The rest of the portal is as for any visitor: everything shared with all visitors, plus restricted documents only if granted (Steve, 2026-10-25).

## My calls (awaiting Steve)

- Files are listed individually, plus a "Download everything" zip.
- There's no per-visitor watermark on DDQ files. The DDQ stamp names the organisation, and the event log names the person.

## Notes

- **On the chain:** portal API `GET /api/trust-centre/questionnaires` gains completed entries, plus `GET …/{ddq}/completed`, `GET …/{ddq}/evidence/{n}` and `GET …/{ddq}/everything`. Add these to the exact-set route test.
- Read files from the stored `sent_copy` / `sent_pack` (`core/ddq_sent.sent_bytes`). List evidence from the pack's kept manifest, never by regenerating it. Stream the zip.
- "Download everything" is a zip that contains the stored pack's entries and the completed file, built at serve time from stored bytes. The stored pack itself is never changed.
- Events: new kinds in `trust_centre_events` carrying the DDQ id. The Activity tab filter and CSV include them.
