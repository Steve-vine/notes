---
id: 01M5X309AQPSNJV3CS040DKMZV
created: 2026-10-26T21:48:58.071351Z
updated: 2026-10-26T21:49:00.827166Z
type: task
title: The seven framework requirements no control reaches (4 HITRUST, 3 UK GDPR) are mapped to the library, and the dashboard says when a framework is held below 100% by requirements no control covers
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1345
sprint: s4zhkvy
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
## What Steve saw

Every control has been reviewed and marked Implemented. On the dashboard every framework shows 100% except **HITRUST at 97%** and **UK GDPR at 95%**.

## Cause (checked on staging, 2026-10-26)

A framework's figure counts its requirements met, and a requirement is met through the controls mapped to it. Seven requirements have **no control mapped at all**, so no assessment can ever meet them:

| Framework | Met | No control mapped |
|---|---|---|
| HITRUST CSF | 152 / 156 = 97% | 01.u Limitation of Connection Time · 05.j Addressing Security When Dealing with Customers · 10.c Control of Internal Processing · 10.e Output Data Validation |
| UK GDPR | 63 / 66 = 95% | Art. 27 A representative in the UK · Art. 12(5) Free unless unfounded or excessive · Art. 31 Co-operate with the Commissioner |

The HITRUST four were reported as "unreached" when HITRUST was loaded (sprint 66, ADR 0100), and left open with Steve.

## Behaviour

1. **The crosswalk reaches them.** Each of the seven is mapped to the existing control that does what it asks. A new control is added only where nothing in the library fits, and is then assessed like any other. Candidates to confirm when building:
   - **01.u:** the session timeout / idle lock control in Access Control.
   - **05.j:** the client contract / security terms control, or the Trust Centre / DDQ practice.
   - **10.c and 10.e:** secure development, i.e. input and output validation and processing integrity, in the SDLC domain.
   - **Art. 12(5):** the data subject request handling control (the DSR module's).
   - **Art. 31:** the regulator notification / incident cooperation control.
   - **Art. 27:** probably no control; see 2.
2. **Art. 27 is situational.** It applies only to a company that isn't established in the UK. It stays unmapped. A UK company rules it Not applicable on the framework's page; Steve can do this today, with a reason. It then drops out of the figure.
3. **The dashboard explains a shortfall it can't be blamed on anyone for.** When a framework is below 100% only because some requirements have no control, the card says so: "3 requirements have no control mapped". It links to the framework's coverage, filtered to them, so the number is never a mystery.

## Notes for the build

- Crosswalk data lives in the framework data files and is re-imported every deploy by the seed Job. Change it there, not in a migration.
- Follow `adding-a-framework-checklist`: the five count-pinning test files and `test_crosswalk.py`. Run `pytest -q` with no `-m` before pushing.
- Record each mapping's relationship (equal / subset / superset / intersects) honestly. A partial mapping marks the requirement **partly covered**, which is fine and is shown as such.
- Update `hitrust-csf-v11-8.SOURCES.md` with where each HITRUST reading came from. Licence rule: never open the CSF PDF; use public material only.
- **The dashboard card:**
  - Expose the count of applicable, assessable requirements with no live mapping per framework.
  - `core/coverage.derive_framework` already knows `not_covered`, so add it to `Tallies` and to the dashboard/posture payload.
  - This is an API change, so regenerate schema.d.ts. Keep `posture.compute` the one arithmetic (ADR 0070).
- **Tests:**
  - the seven are mapped, or ruled out as expected, in the crosswalk tests;
  - the dashboard payload carries the no-control count;
  - the card shows the line and the link only when the count is above 0.