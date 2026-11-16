---
id: 01M7K8NW1Z9F0D78GBBD4B4H4B
created: 2026-11-16T22:47:07.583203Z
updated: 2026-11-16T23:05:29.417594Z
type: task
title: 'Check IDs: CHB-n for built-in checks (the same in every company) and CHC-n for custom checks, in place of CHK-n'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1886
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: active
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