---
id: 01M79F3H1B3SDE0DDBFRA761WT
created: 2026-11-13T03:27:02.187147Z
updated: 2026-11-13T11:38:13.203113Z
type: task
title: The activity log and Polaris's chat show no identifiers or internal keys anywhere
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1785
sprint: spsp226
comments:
- id: 01M7AB6T9QZ7VHJBKDSFN90KQE
  author: Steve Vine
  at: 2026-11-13T11:38:10.103024Z
  text: |-
    Built — PR #1780 (feature/com-1785-activity-no-ids, c20d2cb5), auto-merge set. It is rebased onto COM-1786 and has migration 0836_activity_no_identifiers.

    **What a person now sees**

    Pen tests:
    - Reports read "created pen-test report Pen test, 6 Nov 2026". A report with no tester no longer reads "Pen test: Pen test, …".
    - Findings read "updated pen-test finding Open redirect on Pen test: Acme, 6 Nov 2026".
    - Finding details read "Systems: — → AST-51 · CRM", "Vulnerabilities: — → VUL-12", "Retest outcome: — → Not retested".

    Links moved when a duplicate asset is deleted:
    - They read "R-14 is now linked to AST-46 instead of AST-48", "CloudCo is now a recipient of DAT-46 instead of DAT-48", "root now holds Administrator on AST-46 instead of AST-48".
    - The "Asset: <id> → <id>" line is gone.
    - Decision links aren't recorded in the activity log at all, so there was nothing to reword.

    Records with no name of their own are named by what they are about:
    - "updated assessment of ACC.1"
    - "created treatment plan for R-14"
    - "updated content section of Access Control Policy"
    - "created access request ACR-41 · joiner"
    - "switched the mail catcher on until 14 Nov 2026 18:00 UTC"
    - One-of-a-kind settings read by their noun ("updated SSO setting").

    Details:
    - A field that points at a record names it.
    - People are named, including "Retired by".
    - Stored keys read as words.
    - Anything still unnameable reads "(not named)" instead of an id.

    Entity filter: every type has a screen name (no more "pentest_findings" / "audit_findings"), listed alphabetically. "SAP entry" is capitalised, old rows included.

    Company: technology asset dependencies, treatment plans, asset risk links, recipients, access entries and similar rows now carry their company, so Admin ▸ Activity filtered by company shows them.

    Polaris chat: the line under a message reads "Company: E2E Test Company · Page: Risks", in old conversations too. Polaris still receives the company id; the person never sees it.

    Old rows: migration 0836 rewrites old rows wherever the record can still be traced. Where it can't, the row keeps its noun and drops the id.

    **Guard test:** a new test fails if a logged table has no screen name or no company (unless it's on the shared list). Future tables can't slip back to showing ids.

    **Checks** (after the rebase onto COM-1786):
    - ruff, mypy, and the unit suite (2204) pass. The guard test covers 1786's new table.
    - Integration tests pass: the new activity tests and the migration test (seeds old rows, then upgrades), plus the vulnerability move, company-wide and Polaris tests (28).
    - Before the rebase: eslint, tsc and prettier pass, and full vitest passed 4019 of 4020. The one failure is the known DevicesPage parallel flake, which passes alone.
    - No OpenAPI drift.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Leftovers seen in the sprint 116 round-4 pre-UAT pass and re-check on staging (6e988b9d / ee4bff02, 2026-11-13), after COM-1771, COM-1780 and COM-1782. Not started — for Steve to decide.

**What happens:**
- Pen-test finding rows' details show "Vulnerability ids: — → <id>", "System ids: …" and raw values like "not_retested"; summaries say "pentest finding" / "pentest import". The Entity filter shows the raw keys "pentest_findings" and "audit_findings".
- When a duplicate asset is deleted, the moved data recipients, access entries, asset risk links and decision links log "updated inventory risk link <id>" with "Asset: <id> → <id>" in the details (COM-1780 covered dependencies, installed software and data locations only).
- Other entity types still show raw identifiers: "updated mail catcher switch <id>", "deleted coverage proposal <id>", "updated content section <id>", "created treatment plan <id>", "updated assessment <id>", "access request <id>", Secrets "Retired by: — → <id>". Older plan-entry rows say "sap entry" in lower case.
- Technology asset dependency rows carry no company, so Admin ▸ Activity with a company filter shows none.
- Polaris's chat shows a context line under each message: "Company: E2E Test Company (company id 5e053577-…) · Page: …" — the identifier is visible.
- An import with no tester reads "Pen test: Pen test, 6 Nov 2026".

**What it should do:** every row and the chat name things in screen words with their references (e.g. "pen-test finding", "Pen test, 6 Nov 2026"), never identifiers or internal keys; rows belong to their company.

**Done when:** each item above reads in screen words on staging, old rows included where they can be traced; tests cover each.