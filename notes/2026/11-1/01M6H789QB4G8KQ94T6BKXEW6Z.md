---
id: 01M6H789QB4G8KQ94T6BKXEW6Z
created: 2026-11-03T17:28:03.56313Z
updated: 2026-11-04T07:46:09.250423Z
type: task
title: Text a source sent already garbled shows as "���" in the feed — tidy it on the way in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1545
sprint: s6xh9g1
comments:
- id: 01M6HBXM8NV17FQ9Y5KKEJ1DYA
  author: Steve Vine
  at: 2026-11-03T18:49:36.789237Z
  text: |-
    Done (PR #1556, merged 2026-11-03; migration 0766). Not on staging yet.

    What people see now: text a source sent already garbled reads cleanly. A run of "���" between words becomes a dash ("…vulnerability class — Common Weakness Enumeration (CWE) — and…"), one inside a word an apostrophe ("victim's browser"), ones around a phrase quotes ("“require all denied”"), and any other is dropped. This covers titles, summaries, product names, and each source's own words, fixes and workarounds on the item page; search finds the mended text. What the source sent is still kept exactly as sent.

    Items already held are fixed once, quietly — no "changed" entry in their history, not marked Updated (as you decided for COM-1543). This happens on the worker within about 10 minutes of the deploy, a few thousand items at a time; it isn't in the deploy job, which is too small for a year of items. COM-1543 and COM-1549 reuse the same mechanism.

    Verified: unit tests on the three real shapes (Cisco, SAP via NVD, CISA); integration tests that a garbled record is mended as it's read while the source's words are kept, and that an older item is picked up by the 10-minute check, mended once without history, and not touched again.

    To check on staging (~10 min after deploy): Cisco's voice hardening advisory and CVE-2025-42886 read as above; searching "���" finds nothing.
assignee: steve
label:
- bug
priority: low
task_status: done
---
Found by Steve testing sprint 102 on staging (2026-11-03).

## What people see

Some items show unrenderable characters in their text, e.g. Cisco's voice hardening advisory:

> Cisco has grouped these issues by their underlying vulnerability class ��� Common Weakness Enumeration (CWE) ��� and assi…

Expected: readable text. A dash where the dash was, an apostrophe in "victim's".

## What staging holds (technical)

The � (U+FFFD, "unknown character") is **in the source's own data**. Compass stores what it was sent:

- **Cisco**: 56 rows, all from `cisco-sa-voice-hardening-twgbH9e3` (one row per CVE). Cisco's CSAF file itself has `EF BF BD ×3` where an em dash should be. This was checked by fetching the file on 2026-11-03, with header `charset=UTF-8`. It looks like Cisco decoded a UTF-8 dash byte by byte when writing the file.
- **NVD**: 25 rows, mostly SAP's CVEs (the SAP CNA's text): "victim�s browser", "system�s confidentiality", "(Financials � General Ledger)". These are single �.
- **CISA KEV**: 2 rows (CVE-2021-41773 "�require all denied�", CVE-2020-4428).

Compass's own decoding is fine. There's no sign of double-decoding in any reader.

## Fix

Tidy text as it's read, in one shared place (the record builder or `replace`/`recompute`, so every source gets it):
- A run of � between spaces → "—". Between letters ("victim�s") → "'". Around quoted words ("�require all denied�") → curly quotes. Any other � is dropped.
- Apply to title, summary and product names. Leave stored payloads as received, so the fix is in what Compass shows and searches.
- Re-tidy the items already held, once on deploy, kept out of item history (as Steve decided for COM-1543).

**Done when:** on staging, the Cisco voice hardening advisory reads "…vulnerability class — Common Weakness Enumeration (CWE) — and…"; CVE-2025-42886 reads "victim's browser"; and no item's title or summary shows a "�".