---
id: 01M79F3H1B3SDE0DDBFRA761WT
created: 2026-11-13T03:27:02.187147Z
updated: 2026-11-13T10:04:28.314115Z
type: task
title: The activity log and Polaris's chat show no identifiers or internal keys anywhere
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1785
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: active
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