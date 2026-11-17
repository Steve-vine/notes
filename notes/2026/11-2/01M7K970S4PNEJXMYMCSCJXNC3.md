---
id: 01M7K970S4PNEJXMYMCSCJXNC3
created: 2026-11-16T22:56:29.476481Z
updated: 2026-11-17T20:31:42.769837Z
type: task
title: 'Decision record IDs: D-n becomes DEC-n'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1888
sprint: s7nqsy0
comments:
- id: 01M7KDZBCHPYC8NAGZK3A10D66
  author: Steve Vine
  at: 2026-11-17T00:19:41.073353Z
  text: |-
    Done — PR #1875, merged 5aecd72d.
    Every decision record now reads DEC-n with its old number: on the Decisions list and page, every link to a decision (risks, controls, exceptions, incidents, content, initiatives), exports and packs, and in Polaris. New decisions carry on as DEC-(next).
    D-n still finds the record: in search, the Decisions list's search box, through Polaris, and in the address (/decisions/D-7 or /decisions/DEC-7 opens decision 7).
    Text written before the change keeps its wording. ADR 0157 lists DEC.
    Assumptions: no migration, because numbers are unique and the old prefix is read, not stored. The supersede dialog's title shows "Supersede decision 7" for a moment until the decision loads, instead of building the reference itself.
    To check on staging: decisions read DEC-n; search "D-<n>"; open /decisions/D-<n>. Before release, run the same uniqueness check on a copy of production (decision numbers are unique by constraint).
- id: 01M7MGYH7P67MMC2X50S1V1XNH
  author: Steve Vine
  at: 2026-11-17T10:30:54.454668Z
  text: |-
    Pre-UAT on staging 44d15b9a — Passed
    - Every decision record reads DEC-n with its old number: Passed. As E2E Admin A, the Decisions list shows DEC-1…DEC-11. The decision page header and trail read "DEC-3 · …", and the decision it supersedes reads DEC-2. Control INS.10 lists DEC-10, and so does Initiative INI-1's Decisions tab. Polaris's list_decisions and get_decision answer DEC-n.
    - D-n still resolves: Passed. In the address, as Admin A and the Viewer, /decisions/D-3 and /decisions/DEC-3 both open decision 3 at /decisions/3, and /decisions/D-11 opens DEC-11. The top search bar finds DEC-3 for "D-3", and so does the Decisions list's own search box. Polaris finds DEC-3 for get_decision "D-3", list_decisions query "D-3" and search "D-3".
    - New decision records are DEC-(next): Passed. Admin A created "E2E pre-UAT COM-1888 decision" (Proposed), which became DEC-11. It shows in the list and a search for "DEC-11" finds it.
    - ADR 0157 lists DEC: Passed (D- → DEC-, COM-1888).
    - Switch-over check on a copy of production: Couldn't check on staging, because it's a step before release.
    - Tests: PR #1875 changes 6 test files. No app/e2e selector reads a decision ID.
    - Small leftover, not a Done-when point: Polaris's "Record a decision" tool still says "Compass gives it the next number (D-n)". It's in the tool's description in the code (assistant/tools/decisions.py); Polaris's answers do use DEC-n.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1888/
    Left behind: DEC-11 "E2E pre-UAT COM-1888 decision" (Proposed). Decisions can't be deleted, and DEC-10 from an earlier pre-UAT is already there.
assignee: steve
label: null
priority: medium
task_status: done
---
From Steve's testing of round 2 (staging 43d03f09): every reference should be three letters, a dash and a number. Decision records (the playbook's, shared by every company) are **D-n** today.

**Behaviour.** This works the same way as COM-1887 (risks and gaps) and COM-1886 (checks):
- D-7 becomes **DEC-7**, keeping its number, and the counter carries on.
- The new form shows everywhere an ID is shown:
  - the Decisions list and page;
  - every link to a decision (risks, controls, exceptions, incidents);
  - exports and packs from now on;
  - Polaris's tools, answers and MCP instructions.
- Old D-n IDs still find the record in the address, in search and through Polaris, and old links redirect.
- Text written before the change keeps its wording.

**Done when**
- On staging, every decision record reads DEC-n with its old number, and D-n still resolves.
- New decision records are numbered DEC-(next).
- The three-letter reference ADR (from COM-1887) lists DEC.
- The switch-over is checked on a copy of production data before release.
- Tests cover formatting, old IDs resolving, a new record, and the e2e selectors.

**Where** (for the builder): models/decision_record.py (`DECISION_REF_PREFIX`), the route or search that resolves an ID, frontend decision pages, assistant/tools (posture decisions) and MCP instructions. Built after COM-1887.