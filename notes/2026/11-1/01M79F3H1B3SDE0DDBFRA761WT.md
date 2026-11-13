---
id: 01M79F3H1B3SDE0DDBFRA761WT
created: 2026-11-13T03:27:02.187147Z
updated: 2026-11-13T14:32:57.085925Z
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
- id: 01M7AJHW99CVC1TH0JC7D6P5M3
  author: Steve Vine
  at: 2026-11-13T13:46:32.616588Z
  text: 'Follow-up on PR #1780 (commit 9a9a88fa). CI caught a privacy leak in the first version. A line that pointed at a restricted privacy request ("follows on from") named it and its person. It now reads "(restricted)", and the same applies to a disclosure or a request to disclose about that person (ADR 0118). Old log lines never named those, so the migration needed no change. The activity test now orders lines written in the same save by action, not by a random id. Full integration suite locally: 4871 passed. The only errors were the Samba domain-controller tests, which can''t run on this host.'
- id: 01M7AN6VFXF1X5P45J1SJ4CJCJ
  author: Steve Vine
  at: 2026-11-13T14:32:57.08567Z
  text: |-
    Pre-UAT on staging ee0d160c, E2E Test Company, as Admin A. Admin ▸ Activity, company filter on, sweeping the latest 1,500 rows. **Failed.** Every item this task names reads in screen words, but three kinds of row still show internal values, against "no identifiers or internal keys anywhere". They are fixed forward in a new task (linked below).

    **Passed:**
    - **Pen-test reports:** "created pen-test report Pen test, 6 Nov 2026", with no "Pen test: Pen test".
    - **Pen-test findings:** "updated pen-test finding … on Pen test, 6 Nov 2026". Details read "Systems: — → AST-32 · E2E pre-UAT 102 web-1", "Retest outcome: — → Not retested" and "Vulnerabilities: — → VUL-6".
    - **Entity filter:** 264 screen names, alphabetical, with no raw keys.
    - **Records without a name of their own:**
      - "created treatment plan for R-80"
      - "updated assessment of INS.10"
      - "updated content section of …"
      - "created access request ACR-128 · leaver"
      - "switched the mail catcher on until 13 Nov 2026 14:37 UTC"
      - Secrets "Retired by: — → E2E Admin A"
      - "SAP entry SAP-74"
    - **Company filter:** dependency rows ("AST-42 is now depended on by AST-54 instead of AST-55") and asset risk links ("R-76 is now linked to AST-46 instead of AST-45") show with it on.
    - **Polaris:** the line under a message reads "Company: E2E Test Company · Page: Posture ▸ Risks", in new and old conversations alike, with no id.

    **Still wrong:**
    1. **Coverage proposal rows:** "Directory user ids: (not named), (not named), …" repeats hundreds of times in one row (about 6,000 characters), on both sides of the arrow.
    2. **Raw JSON in details:**
       - Content section: "Doc: {"type":"doc",…}".
       - Security Feed match: "Decided snapshot: {"found":"affected",…}", and "versions_not_stated".
       - Collected check: "Rule: {"mode":"at_most",…}".
    3. **Mail catcher detail:** "On until: — → 2026-11-13 14:37:33.545187+00:00".

    **Minor:**
    - "(source: csv_import)" on assets created by CSV import.
    - Lower-case states: "Reading status: reading → read", "Health: ok → error".
    - The label "Cve ids:".
    - The Entity filter says "Plan entry" where the rows say "SAP entry".

    **Couldn't check:** data recipient and access entry rows. E2E Test Company has none in the log.

    Screenshots: ~/compass-uat/spsp226/COM-1785/uat5-*.png
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