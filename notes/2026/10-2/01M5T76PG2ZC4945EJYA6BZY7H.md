---
id: 01M5T76PG2ZC4945EJYA6BZY7H
created: 2026-10-25T19:04:39.170469Z
updated: 2026-10-26T08:03:46.774405Z
type: task
title: 'Trust Centre portal: a completed DDQ in the visitor''s area — download the completed file, each evidence file, or everything as one zip'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1323
sprint: snfoon1
blocked_by:
- 01M5T768VHF4ZKQY7RCAH0C4SP
comments:
- id: 01M5TWRYBDD52KSB741RADNQ63
  author: Steve Vine
  at: 2026-10-26T01:21:37.133012Z
  text: |-
    Done — merged to main (PR #1339).

    - **Each DDQ shared with a visitor appears in their portal with:**
      - "Download questionnaire": their own file with our answers, unstamped;
      - each evidence file by its folder, with View for a PDF and Download;
      - "Download everything" as one zip.
    - **Where it shows:**
      - a questionnaire the visitor sent in shows these inside its own Questionnaires entry, under "What we sent back";
      - one we sent without being asked appears in a "Completed questionnaires" section.

      Nothing is listed twice.
    - **Exactly what went out:** every byte comes from the copies stored when the DDQ was sent, never made again. The evidence PDFs keep the pack's stamp, with no second per-visitor stamp. It isn't behind the NDA click-through.
    - **Ringfenced:** only visitors it's shared with right now can see it. Anyone else, a stopped share, or a malformed address gets the same "This questionnaire is no longer available."
    - **Every view and download is recorded** as a Trust Centre event carrying the DDQ, for example "DDQ-7 · completed questionnaire". A view counts once per file per visit every few minutes.

    My calls:
    - A questionnaire the visitor sent in shows its downloads inside that entry, not in a second list.
    - An event's detail starts with the DDQ's number, so Activity and the CSV say which DDQ it was.
    - The zip keeps the pack's folders, with the completed questionnaire at the top.
assignee: steve
label:
- feature
priority: high
task_status: done
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
