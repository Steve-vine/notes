---
id: 01M79ACKXM5KTXKV8Y6PXTC98E
created: 2026-11-13T02:04:37.172523Z
updated: 2026-11-13T10:06:57.060694Z
type: task
title: Vulnerability history, Polaris's ask-first card and the issue row name things in screen words, never identifiers
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1782
sprint: spsp226
comments:
- id: 01M79CH9K6FK7WP2F42DAMW885
  author: Steve Vine
  at: 2026-11-13T02:42:07.589822Z
  text: |-
    Built — PR #1776 (auto-merge set; on the chain: migration 0834_vulnerability_screen_words, after 0833).

    1. Vulnerability History after Move to a system…: "moved vulnerability VUL-12 … from Company-wide to AST-51 · CRM — <why>", change "System: Company-wide → AST-51 · CRM". A comment reads "added a comment to VUL-12". Sources ▸ Its reference for a pen test shows the report's name ("Pen test: Example Security, 10 Nov 2026") linked to its import.
    2. Polaris's ask-first card: "Remove “Open redirect” from Pen test: Example Security, 10 Nov 2026" — names shown even when Polaris passed an id or a number; the activity line afterwards names the finding too (also for changing a finding, marking looked at, setting a retest outcome). Polaris tools can now name their arguments for the card in general; if a name can't be found the card shows what Polaris passed.
    3. Register issue row: only company-wide → "Company-wide"; mixed → "2 systems + company-wide" (was counted as one more system).
    4. Audit activity says each noun once: "created/updated/deleted audit finding AUD-1-F2"; a finding's gap reads "raised gap G-12 from finding AUD-1-F2" / "linked … to …" / "unlinked … from …". Auditors and requests had the same doubling ("audit auditor auditor Ada") — fixed too.
    5. Pen-test finding rows carry the import's company and vulnerability comment rows the vulnerability's, so Admin ▸ Activity filtered by company shows them.

    Old rows: yes — old moves get the System change, old comments become "added a comment to VUL-n" with the company, old pen-test finding rows get the import's company (a finding removed since keeps none — nothing says which company it was in), doubled audit nouns removed (old finding-gap lines become "added a gap to finding AUD-1-F2" / "unlinked a gap from finding …"). Old move summaries keep "AST-51 CRM" without the dot.

    Checks: ruff, mypy, unit suite (2196), integration incl. the new migration test, activity wording, Polaris pen-test findings (new ask-card + Allow test), company-wide, audit findings, Polaris engine/approvals; OpenAPI drift none; eslint, tsc, prettier, full vitest 4015 passed.
- id: 01M79F2V1R7FYWH96R5VH6VT7V
  author: Steve Vine
  at: 2026-11-13T03:26:39.672255Z
  text: |-
    Pre-UAT on staging (ee4bff02), E2E Test Company: **Passed**.
    VUL-7 History: "moved vulnerability VUL-7 … from Company-wide to AST-51 …", change "System: Company-wide → AST-51 · E2E UAT4 1777 second host"; comment row "added a comment to VUL-7". Sources ▸ Its reference: "Pen test: Pen test, 6 Nov 2026" linked to the import. Register grouped: VUL-17's issue reads "Company-wide". Admin ▸ Activity with E2E Test Company only: 35 pen-test finding rows show. Audit rows read "created/deleted audit finding AUD-1-F2". Polaris ask-first card (new throwaway import "Pen test, 13 Nov 2026", one proposed finding): "Remove “E2E UAT4 1782 Open redirect on login page” from Pen test: Pen test, 13 Nov 2026 — Can't be undone", fields Report / Company / Finding by name; Allow removed it, logged via Polaris under the company.
    Seen outside the bar (logged as COM-1785): pen-test finding rows' details still show "Vulnerability ids / System ids" identifiers and raw values like not_retested; summaries say "pentest finding"; the Entity filter shows raw keys "pentest_findings"/"audit_findings"; an import with no tester reads "Pen test: Pen test, …". Screenshots ~/compass-uat/spsp226/COM-1782/.
assignee: steve
label:
- bug
priority: low
task_status: done
---
Found in the sprint 116 round-4 pre-UAT pass on staging (6e988b9d, 2026-11-13), from COM-1772, COM-1774 and COM-1776.

**What happens:**
1. A vulnerability page's History, after Move to a system…, shows "Container: — → 934a655e-…"; adding a comment shows "created vulnerability comment fd3bf5ec-…". The Sources table's "Its reference" for a pen test shows the raw import identifier.
2. Polaris's ask-first card for a pen-test finding reads "Remove 3 from 058939d0-…" / "Report: 058939d0-…".
3. A register issue row for an issue that is only company-wide reads "1 system".
4. The activity summary for an audit finding reads "deleted audit finding finding AUD-1-F2".
5. Pen-test finding rows in the activity log carry no company, so Admin ▸ Activity filtered by company doesn't show them.

**What it should do:** (1) "moved from Company-wide to AST-51 · Name", "added a comment", and the report's name linked to its import; (2) the report's name ("Pen test, 10 Nov 2026") and the finding's title; (3) "Company-wide" (or "1 system, company-wide" when mixed reads oddly — keep it plain); (4) "deleted audit finding AUD-1-F2"; (5) pen-test finding rows belong to the import's company.

**Done when:** each of the five reads/behaves as above on staging in E2E Test Company; tests cover each. Say whether old rows change.