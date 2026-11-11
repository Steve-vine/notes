---
id: 01M75KC2WMRR7CZXC7N0AND8FW
created: 2026-11-11T15:24:39.188032Z
updated: 2026-11-11T22:19:20.345851Z
type: task
title: 'Vulnerabilities gets an Imports tab: every pen-test report and file import, with the ones waiting to be confirmed shown on the tab and in Actions'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1734
comments:
- id: 01M75X4DM1293Z71WNB5ZCQ4P7
  author: Steve Vine
  at: 2026-11-11T18:15:13.79293Z
  text: |-
    Done. PR #1729 (API change, no migration). It merges after COM-1735, because both regenerate the API types.

    What you see:
    - An **Imports** tab on Vulnerabilities, after Register. It lists pen-test reports, retests and Nessus file uploads. Each row shows what was imported, the tester, test dates, SAP entry, status (Being reviewed / Confirmed / Withdrawn), findings proposed and recorded, how far Polaris has read it, and who imported it and when. Every column sorts. A pen-test row opens its import page; a Nessus row opens that file's window.
    - The tab reads "Imports 1" while anything is waiting.
    - The importer gets an Actions item, "Confirm the findings", titled with the report. It goes out in the actions email too, and clears on confirm or withdraw.
    - The Import button keeps "Nessus file" and "Pen-test report"; the "Pen-test reports" link is gone. The old /vulnerabilities/pentests address and the import page's breadcrumb both land on the tab.

    New, because the task assumed it existed: imports couldn't be withdrawn. There's now a **Withdraw** button on an import page while it's being reviewed. Nothing goes in the register, the report stays as evidence, and the import shows as Withdrawn.

    Checks:
    - backend: ruff, mypy, unit suite (2,183) and the import integration tests pass;
    - frontend: eslint, tsc and prettier are clean, and 6 new tests pass; one unrelated flaky test passed when re-run on its own;
    - schema.d.ts regenerated.
- id: 01M76B3CWS5X1S0F5GZ6A5YAQ8
  author: Steve Vine
  at: 2026-11-11T22:19:20.345651Z
  text: |-
    Passed (Claude's pre-UAT pass, staging fcaf1d13, as E2E Admin A in E2E Test Company).

    Steps and what was seen:
    1. **Before:** the Imports tab said "Nothing imported yet…".
    2. **The Import button** offers "Nessus file" and "Pen-test report" only. The "Pen-test reports" link is gone.
    3. **Imported a test report** (Import ▸ Pen-test report), then left the import page without confirming.
    4. **Back on Vulnerabilities**, the tab reads "Imports 1".
    5. **The Imports tab** lists it:
       - "Pen test: Pen test, 4 Nov 2026", Pen-test report · e2e-preuat-pentest.pdf, tested 2–4 Nov 2026;
       - BEING REVIEWED, 0 proposed;
       - E2E Admin A, 11 Nov 2026 22:02.
       - Every column sorts (Import, Tester, Tested, SAP entry, Status, Findings, Polaris, Imported by, Imported).
    6. **Actions** has an Import item, "Confirm the findings", on that report, owned by E2E Admin A, due 25 Nov 2026.
    7. **After confirming:**
       - the tab reads just "Imports";
       - the row is CONFIRMED, 2 proposed, 2 recorded, Polaris "Read";
       - Actions ▸ Import is 0.
    8. **Back from the import page:** the breadcrumb "Vulnerabilities" lands on the Imports tab. The old address /vulnerabilities/pentests does too.

    Withdraw wasn't tried; it isn't in "Done when".

    Small observation for Steve: an import with no tester picked is titled "Pen test: Pen test, 4 Nov 2026", and the doubled "Pen test" reads oddly. That naming comes from COM-1378, not this task.

    Screenshots: ~/compass-uat/sprint0-2026-11-11/COM-1734/
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, 2026-11-11. He imported the external pen test and left the import page; its message says nothing is in the register yet and he can come back. On returning to Vulnerabilities, there was no sign of the import. The only way back is the third item in the Import button's drop-down, "Pen-test reports", which nobody would think to look for.

**Behaviour wanted**
- **A new Imports tab** on Vulnerabilities, beside the register. It lists every import: pen-test reports (COM-1378), retests, and Nessus file imports (COM-1376).
  - Each row shows what was imported, by whom and when, the tester and test dates, its SAP testing entry, and its state: being reviewed, confirmed, or withdrawn.
  - It shows how many findings are proposed and how many recorded, and how far Polaris has read it.
  - A row opens the import page. Sortable, using the screen conventions.
- **The Import button keeps** "Pen-test report" and "Nessus file" for bringing something in. The "Pen-test reports" link is removed, because the tab replaces it.
- **Waiting imports are visible:**
  - the tab shows a count badge while any import is still being reviewed ("Imports 1");
  - the importer gets an Actions item, "Confirm the findings from <report>", which links to the import and clears when it's confirmed or withdrawn.
- **Back from the import page** returns to the Imports tab (breadcrumb trail, ADR 0084).
- **The assistant** is unchanged: `vulnerabilities_list_pentest_reports` already lists them.

**Done when:**
- Leaving an unconfirmed import and returning to Vulnerabilities shows "Imports 1".
- The tab lists the import, and the importer's Actions list carries the item.
- Confirming clears both.
- The drop-down no longer has the link.
- screen-conventions.test passes.