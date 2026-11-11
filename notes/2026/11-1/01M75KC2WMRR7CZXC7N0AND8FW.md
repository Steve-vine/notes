---
id: 01M75KC2WMRR7CZXC7N0AND8FW
created: 2026-11-11T15:24:39.188032Z
updated: 2026-11-11T17:39:26.190107Z
type: task
title: 'Vulnerabilities gets an Imports tab: every pen-test report and file import, with the ones waiting to be confirmed shown on the tab and in Actions'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1734
assignee: steve
label:
- improvement
priority: medium
task_status: active
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