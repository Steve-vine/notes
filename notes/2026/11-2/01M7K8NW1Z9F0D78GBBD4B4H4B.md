---
id: 01M7K8NW1Z9F0D78GBBD4B4H4B
created: 2026-11-16T22:47:07.583203Z
updated: 2026-11-17T19:50:15.373546Z
type: task
title: 'Check IDs: CHB-n for built-in checks (the same in every company) and CHC-n for custom checks, in place of CHK-n'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1886
sprint: s7nqsy0
comments:
- id: 01M7KF8A370WHJ7JZ4RJYG5TQY
  author: Steve Vine
  at: 2026-11-17T00:42:03.239312Z
  text: |-
    Done — PR #1872, merged 2e0cdc26.
    Every built-in check now reads CHB-1 to CHB-12, the same in every company; a built-in check added later takes CHB-13. Custom checks read CHC-n with the number they had (CHK-24 is CHC-24), and the company's counter carries on from where it was.
    An old CHK ID still works: in the address (it opens the check and the address moves to the new ID), in search, in a workflow draft and with Polaris, who answers with the new ID. The check's page shows "Formerly CHK-n" in Details.
    All checks sorts by ID with built-in checks before custom ones. Gap lines, workflow sentences, the Review screen and Polaris all use the new IDs.
    Assumptions: workflows the switch-over named "CHK-n · …" are renamed "CHC-n · …" so the list reads like the checks (their saved versions keep the old name); a bare number in search finds both CHB-n and CHC-n.
    To check on staging: CHK-24 in the address opens CHC-24 in Test Company, and CHK-12 opens the built-in check it was there. Before release, run on a copy of production: SELECT company_id, number FROM (SELECT company_id, number FROM former_check_numbers UNION ALL SELECT company_id, number FROM collected_checks) x GROUP BY 1,2 HAVING count(*) > 1; — it must return no rows.
- id: 01M7MJ3T9NCCQ9CXPG44SZ7P11
  author: Steve Vine
  at: 2026-11-17T10:51:16.149182Z
  text: |-
    Pre-UAT on staging 44d15b9a — Passed
    - CHB-1 to CHB-12 in every company: E2E Test Company's All checks lists CHB-1 … CHB-12 then CHC-2. Polaris's check list (read only) gives the same CHB-1 … CHB-12, with the same names, in Test Company, Moneypenny and Demo. Passed.
    - Custom checks keep their numbers as CHC-n: E2E's CHC-2 says "Formerly: CHK-2". Test Company has CHC-1 … CHC-7, CHC-24, CHC-25, CHC-26. Passed.
    - CHK-24 opens CHC-24 in Test Company, and CHK-12 opens the built-in check it was: as E2E Admin A with Test Company selected (looked only, changed nothing), /automation/evidence-collection/CHK-24 moved to …/CHC-24, and CHK-12 moved to …/CHB-1 (Everyone has MFA registered). In E2E, CHK-4 → CHB-1, CHK-7 → CHB-4, chk-7 (lower case) → CHB-4, CHK-15 → CHB-12, and the old /checks/CHK-7 link → CHB-4. CHK-1, which named nothing, says "Check not found." Passed.
    - Search: CHK-4 finds "CHB-1 · Everyone has MFA registered", CHK-2 finds CHC-2, CHB-3 and CHC-2 find themselves. In Test Company, CHK-24 finds CHC-24 (the live check, plus its change waiting in Review). Passed.
    - Polaris accepts CHB-, CHC- and old CHK- IDs and answers with the new ones: asked about CHK-7 in E2E, and Polaris answered "id: CHB-4". CHC-2 and CHB-12 also work. Passed.
    - Sorting: All checks sorts by ID with built-in first and numbers in order (CHB-1 … CHB-9, CHB-10, CHB-11, CHB-12, then CHC-2). Passed.
    - Gap wording: GAP-139 (raised by CHB-12 during this pass) reads "Raised by Compass check: CHB-12 · Secrets are rotated on time". Passed.
    - Next built-in is CHB-13 everywhere, the switch-over check on a copy of production, and the tests: can't be seen on staging. The ADR 0142 amendment is in (§ "Amendment (2026-11-17, COM-1886)"). The production-copy check before release is still for Steve or the release step.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1886/
assignee: steve
priority: medium
task_status: done
---
From Steve's testing of round 2 (staging 43d03f09). Steve: "I want to use a different ID for built-in so that if any get added in the future, they'll follow on. Change the ID's to use CHB-xxx for built-in checks and CHC-xxx for custom checks."

**Today.** Every check in a company shares one counter (CHK-n, COM-1805 / COM-1834). Built-in checks were numbered after whatever custom checks a company already had: CHK-12 to CHK-23 in Test Company, but CHK-1 to CHK-12 in Moneypenny. A built-in check added to Compass later takes the next free number in each company, so it lands among the custom checks.

**Behaviour** (assumptions decided here, not by Steve)
- **Built-in checks: CHB-n, the same in every company.**
  - Built-in checks ship with Compass, so their number belongs to Compass, not to a company: CHB-3 is the same check everywhere.
  - They are numbered CHB-1 upwards in the order Compass lists them today.
  - A built-in check added later takes the next CHB number.
  - A retired built-in check keeps its number, and nothing else takes it.
- **Custom checks: CHC-n, per company, keeping their numbers.** CHK-24 becomes **CHC-24**. Nobody has to learn new numbers, and references in gaps, workflows and audit evidence still match.
  - The company's counter carries on from where it is, so the next custom check in Test Company is CHC-(last + 1).
  - Gaps left where built-in checks used to take numbers stay unused. IDs are never reused, so a gap is harmless.
  - A proposal waiting at Review gets its CHC number when proposed, as today.
- **No padding.** IDs read CHB-3 and CHC-24, like ACR-41, AST-14 and WF-7. "xxx" is taken as a placeholder for the number.
- **Old CHK IDs still work.**
  - A CHK-n typed into the address, searched for, or given to Polaris finds the check it now names: CHB-n or CHC-n for that company.
  - Old links redirect.
  - Activity lines written before the change keep their wording.
  - The check's page shows "Formerly CHK-n" in Details, so old references can be followed.
- **Everywhere an ID shows**, it uses the new form:
  - lists (All checks, the Built-in Checks tab from COM-1885), sorted by prefix and then number, so Built-in sorts before Custom;
  - check pages and the control's Evidence tab;
  - gap text ("Raised by Compass check CHB-3", "Raised by workflow…");
  - workflow sentences and the builder;
  - the Review screen;
  - exports and audit packs;
  - Polaris's tools and MCP instructions ("Every check has an ID … (CHB-3, CHC-24)").

**Done when**
- On staging:
  - every built-in check reads CHB-1 to CHB-12 in every company (Test Company, Moneypenny, E2E Test Company and Demo alike);
  - every custom check reads CHC-n with its old number;
  - CHK-24 in the address opens CHC-24 in Test Company, and CHK-12 opens the built-in check it was there.
- The next built-in check added to Compass is CHB-13 in every company.
- Polaris accepts CHB-, CHC- and old CHK- IDs, and answers with the new ones.
- An amendment to ADR 0142 records the two prefixes, built-in numbers belonging to Compass, and old IDs resolving.
- The switch-over is checked on a copy of production data before release. The check: every check keeps a unique ID, and every old CHK ID resolves to exactly one check.
- Tests cover:
  - numbering a new company (CHB fixed; CHC from 1);
  - a built-in check added later;
  - old IDs resolving (address, search, Polaris);
  - sorting;
  - gap and workflow wording;
  - the e2e and Browser smoke selectors that read CHK IDs.

**Where** (for the builder): core/checks/numbers.py (`BuiltInCheckNumber`, the per-company counter, `ref_for`, `builtin_ref`), models/collected_check.py (`check_ref`, `next_check_number`), api/v1/collected_check_ids.py, the address/route that resolves an ID, search, core/workflows (sentences), gap wording, assistant/tools and MCP instructions, frontend lists and pages, app/e2e. This needs a migration: built-in numbers become Compass's, and the old CHK IDs are kept for resolving. It is on the chain. Land it before COM-1884 and COM-1885, so their new screens use the new IDs from the start.