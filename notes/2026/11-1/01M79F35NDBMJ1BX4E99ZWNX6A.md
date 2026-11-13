---
id: 01M79F35NDBMJ1BX4E99ZWNX6A
created: 2026-11-13T03:26:50.541696Z
updated: 2026-11-13T10:41:46.4853Z
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