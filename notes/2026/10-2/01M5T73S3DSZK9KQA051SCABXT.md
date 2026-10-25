---
id: 01M5T73S3DSZK9KQA051SCABXT
created: 2026-10-25T19:03:03.533507Z
updated: 2026-10-25T19:03:03.533507Z
type: task
title: 'Trust Centre: files a visitor sends are checked for what they really are — questionnaire and supporting-file types, macros refused, size limits'
task_status: todo
assignee: steve
priority: medium
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1317
---
## Why

This is the first time someone outside the company can send Compass files: a signed-in Trust Centre visitor sending a questionnaire (COM-1316). Steve chose no virus scanning this sprint, so the checks on each file have to be strict.

## Behaviour

- **A questionnaire file** must be a spreadsheet (.xlsx, .csv) or a Word document (.docx).
- **A supporting file** can also be a PDF.
- The check is on **what the file contains, not its name**. A renamed .exe called "answers.xlsx" is refused.
- **Refused, each with a plain reason the visitor sees:**
  - an old .xls or .doc: "Save it as .xlsx (or .docx) and send it again";
  - a macro-enabled workbook or document (.xlsm/.docm, or a .xlsx carrying macros): "Files with macros can't be accepted — save a copy without them";
  - a password-protected or unreadable file: "We couldn't open this file — send it without a password";
  - a PDF as the questionnaire: "Send the questionnaire as a spreadsheet or Word document, or paste the questions";
  - anything else: "This type of file can't be accepted".
- **Limits:** 20 MB per file, up to 10 supporting files per questionnaire, and 100 MB per questionnaire in all.
- **Rate limit per visitor:** 10 questionnaires a day, and 50 files a day across all their questionnaires. Over the limit: "You've sent a lot today — try again tomorrow or contact <contact email>".
- A file that passes is stored unchanged under its original name, made safe for downloading.

## My calls (awaiting Steve)

- Limits as above.
- Macros are refused, never stripped. We don't change the client's file.

## Notes

- **Independent** (a core module, no migration, no API). The portal routes in the intake task call it.
- Reuse what exists:
  - the DDQ upload checks in `core/ddqs.py` (`read_questionnaire`, `read_files`: .xls/.doc refusal and macro reporting);
  - the trust centre's PDF sniffing in `core/trust_centre_documents.read_pdf_upload` (encrypted/unreadable refusal);
  - the Valkey rate limiter in `core/rate_limit.py`.
- Macro detection: `vbaProject.bin` in the zip, or the `macroEnabled` content type. Zip bombs: cap the uncompressed size and entry count before opening it with openpyxl/python-docx.
- Tests: look-alike files built in the test (never real client files), including a renamed binary, an xlsm saved as .xlsx, an encrypted xlsx, a zip bomb and an oversize file.
