---
id: 01M79F35NDBMJ1BX4E99ZWNX6A
created: 2026-11-13T03:26:50.541696Z
updated: 2026-11-13T14:32:49.381597Z
type: task
title: Record a vulnerability's system list doesn't offer deleted technology assets
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1784
sprint: spsp226
comments:
- id: 01M7A7ZFVTQQVE1TZG5Z9HHVWN
  author: Steve Vine
  at: 2026-11-13T10:41:44.314252Z
  text: |-
    Built — PR #1778 (feature/com-1784-no-deleted-systems, 0ed8b5c2), auto-merge set. No migration, no change to the API's shape.

    What a person now sees: when choosing a vulnerability's system, only technology assets that still exist are offered. That covers:
    - Record a vulnerability
    - the pen-test finding window ("Systems it affects")
    - Move to a system
    - matching rules and placing an unmatched target
    - Polaris

    A deleted asset drops out at once, whether it was deleted outright or as a duplicate. Recording a vulnerability against a deleted asset is refused ("Every system must be one of this company's technology assets").

    Cause:
    - Every picker, Polaris included, reads one shared systems list, and that list never left out deleted assets. Fixed on the server.
    - Recording by hand also accepted a deleted asset; it now refuses one.
    - The browser kept the old list in memory after a delete. Deleting a technology asset now makes it read the list again.

    Tests:
    - the list before and after deleting a duplicate;
    - recording against a deleted asset is refused;
    - Polaris can't choose a deleted system, for a pen-test finding or a hand record;
    - the browser reads the list again after a delete.

    All checks pass: backend unit suite, the integration tests, the full vitest suite, and no OpenAPI drift.

    Left as is:
    - A draft pen-test finding that already had a since-deleted system keeps it until someone takes it off. Saving or confirming refuses with a clear message. The window doesn't drop it automatically, which avoids wiping systems while the list is still loading.
    - Deleting an asset as a duplicate still doesn't move draft findings or matching rules onto the asset it duplicated. That is existing behaviour.
- id: 01M7AN6KZ53ZJWFCH17CY9TC2R
  author: Steve Vine
  at: 2026-11-13T14:32:49.381349Z
  text: |-
    Pre-UAT on staging ee0d160c, E2E Test Company, as Admin A: **Passed**.

    Steps and what I saw:
    1. I created AST-56 "E2E UAT5 1784 to delete". Record a vulnerability ▸ System offered it.
    2. I deleted it from its own page, without reloading, while the list was already held in memory. Its page now reads "Technology asset not found".
    3. It is no longer offered in any of these, with no reload:
       - Record a vulnerability (searching "1784" finds only "New asset…");
       - a vulnerability's Move… and Add a system… pickers;
       - a pen-test finding's "Systems it affects".
       That last one needed a throwaway report, "Pen test, 13 Nov 2026". I cancelled the finding and withdrew the report.
    4. "E2E UAT4 1780 dup", "E2E pre-UAT 1758 duplicate" and "E2E pre-UAT 1766 duplicate" are offered nowhere. "E2E pre-UAT 1757 duplicate serial" is still offered, which is right: it's a live asset.

    Screenshots: ~/compass-uat/spsp226/COM-1784/uat5-*.png
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in the sprint 116 round-4 pre-UAT re-check on staging (ee4bff02, 2026-11-13).

**What happens:** Record a vulnerability's System list offers technology assets that have been deleted — e.g. "E2E UAT4 1780 dup" straight after it was deleted as a duplicate (its page says "Technology asset not found"), and "E2E pre-UAT 1758 duplicate", "E2E pre-UAT 1766 duplicate". The pen-test finding page's system picker wasn't checked and may do the same.

**What it should do:** only live (not deleted) technology assets are offered, in Record a vulnerability, the pen-test finding picker and anywhere else a system is chosen for a vulnerability.

**Done when:** on staging in E2E Test Company, a just-deleted asset isn't offered in either picker; a test covers it. Independent.