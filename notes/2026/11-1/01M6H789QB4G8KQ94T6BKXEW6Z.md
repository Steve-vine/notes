---
id: 01M6H789QB4G8KQ94T6BKXEW6Z
created: 2026-11-03T17:28:03.56313Z
updated: 2026-11-03T17:28:03.56313Z
type: task
title: Text a source sent already garbled shows as "���" in the feed — tidy it on the way in
task_status: todo
assignee: steve
priority: low
label: bug
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1545
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