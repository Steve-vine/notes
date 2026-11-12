---
id: 01M77E89EEXY9N5K5HWXMWJDGT
created: 2026-11-12T08:33:40.81443Z
updated: 2026-11-12T14:26:15.01566Z
type: task
title: A record's history calls an archive "Archived", not "Deleted", and shows a file's classification by name, not as a number
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1748
sprint: spsp226
comments:
- id: 01M77YPK17MSDPGNCTZVDMNXDJ
  author: Steve Vine
  at: 2026-11-12T13:21:06.599631Z
  text: |-
    Built: PR #1749 (on the chain, migration 0823; merges after COM-1750's #1747, then I re-point it).

    What you'll see:
    - Archiving a file shows an Archived row in the record's history and in Admin ▸ Activity (the words underneath unchanged). Deleting an archived file for good shows a Deleted row. On a plan entry, that Deleted row and the file's earlier rows used to vanish once the file was gone; they now stay.
    - A replaced version, a renewed vendor certificate, and a trust centre file kept when its document is removed also read Archived (each is kept, not gone).
    - Archiving a trust centre document's file, which takes the document off the trust centre, reads Archived ("archived the file of trust centre document X, taking the document off the trust centre"); using Remove on the document still reads Deleted.
    - On a data subject request, disclosure or request to disclose, the record's own history row for a file now says Archived (or Deleted when deleted for good); it used to say Updated.
    - A classification change reads by name, e.g. "Classification: — → Confidential", in every record history and in Admin ▸ Activity.
    - Admin ▸ Activity's Action filter gains Archived.

    Cause: every archive was recorded as a delete, not mislabelled on screen. Activity now has a fourth kind, Archived (ADR 0023 amended). The migration relabels the rows already on staging and production (and for files removed with their trust centre document, rewords the summary to say archived); a downgrade restores every row exactly.

    Histories checked: plan entry, data subject request, trust centre and Admin ▸ Activity by a new integration test; disclosures and requests to disclose share the DSR code; incidents' timeline and assessments' evidence history already said Archived / deleted for good; risks' and vendors' histories list only versions of the record, so their file archives show in Admin ▸ Activity.

    Not done: old trust centre rows whose archived file was later deleted for good can't be matched to their document, so those document rows keep Deleted.

    Checks: backend lint, format, types, unit suite; 45 integration tests across the new and neighbouring files; semgrep on the migration; frontend lint, types, format, full suite (3916 passed); OpenAPI regenerated.
- id: 01M782DVV7DVZJA8TJYH3Z79BD
  author: Steve Vine
  at: 2026-11-12T14:26:15.015451Z
  text: |-
    Pre-UAT (staging 80ffc250, E2E Test Company, Admin A): Passed.
    - New entry SAP-71 with test files. Its history reads: "Archived · archived attachment … — Wrong file uploaded", "Archived · … — E2E pre-UAT test of archiving", "Deleted · deleted attachment e2e-pre-uat-1748-a.txt on SAP-71", "Updated · … Classification: — → Confidential".
    - The entry's archived list shows the deleted file struck through, "Deleted for good … Only its record is kept."
    - Admin ▸ Activity: Action filter offers Any / Created / Updated / Archived / Deleted; Archived lists 4 rows, including this morning's SAP-70 archive (written before the fix), which the migration relabelled to Archived.
    - A risk's history lists versions of the risk, not activity rows, so it doesn't apply; a data subject request wasn't checked in the browser (covered by the integration test).
    - No console errors.
    Noticed, not this task: a Deleted row doesn't carry its reason in the history text (the evidence list shows it); and a new entry's "Created" row reads "created sap entry SAP-None" (logged separately).
    Screenshots: ~/compass-uat/spsp226/COM-1748/
assignee: steve
label:
- bug
priority: low
task_status: review
---
Found in the COM-1738 pre-UAT pass on staging (2026-11-12), on plan entry SAP-70 in E2E Test Company.

**What happens:** two rows in the entry's history are labelled wrongly.
- **Archiving a file** shows the kind "Deleted", although the description underneath correctly says "archived attachment E2E-pentest-report.pdf … — Duplicate of …". Nothing was deleted; it was archived.
- **A file's classification change** shows "Classification: — → 3", the internal number, instead of the classification's name (e.g. Confidential).

**What it should do:**
- An archive row is labelled **Archived**. A permanent delete is labelled **Deleted**.
- Classification changes show the classification's name on both sides.
- Check the same on every record with a history or activity view that shows evidence: assessments, risks, incidents, data subject requests, vendors, the trust centre and Admin ▸ Activity. Archiving is now the same everywhere (COM-1738).

**Done when:** on a plan entry, archiving a file shows an "Archived" row, deleting one for good shows a "Deleted" row, and a classification change reads, for example, "Classification: — → Confidential". The other histories read the same way.