---
id: 01M5X309AQPSNJV3CS040DKMZV
created: 2026-10-26T21:48:58.071351Z
updated: 2026-10-26T22:11:43.622312Z
type: task
title: Every requirement in every framework has a control mapped — the seven no control reaches (4 HITRUST, 3 UK GDPR, incl. a new control for Art. 27) are mapped, a test keeps it that way, and the dashboard explains any shortfall
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1345
sprint: s4zhkvy
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
## What Steve saw

Every control has been reviewed and marked Implemented. On the dashboard every framework shows 100% except **HITRUST at 97%** and **UK GDPR at 95%**.

## Decided (Steve, 2026-10-26)

**Every requirement in every framework loaded has at least one control mapped**, including requirements that won't apply to a given company. Applicability is a company's ruling; the library still covers everything. For example, UK GDPR Art. 27 gets a control even though Steve will mark it Not applicable for a UK company.

## Cause (checked on staging, 2026-10-26)

A framework's figure counts its requirements met, through the controls mapped to them. Seven requirements have **no control mapped at all**, so no assessment can meet them:

| Framework | Met | No control mapped |
|---|---|---|
| HITRUST CSF | 152 / 156 = 97% | 01.u Limitation of Connection Time · 05.j Addressing Security When Dealing with Customers · 10.c Control of Internal Processing · 10.e Output Data Validation |
| UK GDPR | 63 / 66 = 95% | Art. 27 A representative in the UK · Art. 12(5) Free unless unfounded or excessive · Art. 31 Co-operate with the Commissioner |

Every other framework (CIS, Cyber Essentials, HIPAA, ISO 27001, ISO 42001, NIST CSF, PCI DSS and SOC 2) already has a control for every requirement. The HITRUST four were reported as "unreached" in sprint 66 (ADR 0100).

## Behaviour

1. **Each of the seven is mapped.** Map to the existing control that does what the requirement asks; add a new control only where nothing fits, and assess it like any other. Candidates to confirm:
   - **01.u:** the session timeout / idle lock control in Access Control.
   - **05.j:** the client contract / security terms control, or the Trust Centre / DDQ practice.
   - **10.c, 10.e:** secure development, i.e. input and output validation and processing integrity, in the SDLC domain.
   - **Art. 12(5):** the data subject request handling control (the DSR module's).
   - **Art. 31:** the regulator notification / incident cooperation control.
   - **Art. 27: a new control** in the data protection / privacy domain, for example: *"Where the company handles personal data of people in a jurisdiction it is not established in (offering them goods or services, or monitoring them), it appoints a representative there as that law requires, and records who and where."*
     - It's worded to cover EU GDPR Art. 27 too, should EU GDPR be loaded later.
     - It's a new control, so each company assesses it. A UK company with no such processing marks it Not applicable, which is what Steve will do. A ruling of Not applicable on the requirement also takes it out of the figure.
2. **A test keeps it this way.** The crosswalk tests fail if any assessable requirement in any active framework has no live mapping. A framework added in future can't ship with an unreached requirement.
3. **The dashboard explains a shortfall it can't be blamed on anyone for.** If a framework is ever held below 100% by requirements with no control, its card says "3 requirements have no control mapped", linking to the framework's coverage filtered to them. With item 2 this should only appear for a framework someone has edited in the app.

## Notes for the build

- Crosswalk and control data live in the data files and are re-imported every deploy by the seed Job. Change them there, not in a migration.
- **A new control:**
  - Give it a new `controls.csv` row, with a key and a ref in its domain.
  - Look data keys up by `CoreControl.key`, not by ref (see `control-key-vs-ref`).
  - Consider whether its domain's policy wording needs a line. A policy covers its domain's controls by membership, so don't link them separately.
- Follow `adding-a-framework-checklist`: the five count-pinning test files and `test_crosswalk.py`. Run `pytest -q` with no `-m` before pushing.
- Record each mapping's relationship (equal / subset / superset / intersects) honestly. A partial mapping marks the requirement **partly covered**, which is shown as such.
- Update `hitrust-csf-v11-8.SOURCES.md` with where each HITRUST reading came from. Licence rule: public material only; never open the CSF PDF.
- **The new test:** for every active framework, every `assessable` active requirement has ≥ 1 non-deleted mapping. Run it against the seeded data.
- **The dashboard card:**
  - Expose the applicable, assessable requirements with no live mapping per framework. Add it to `Tallies` from `derive_framework`'s `not_covered`, and to the posture/dashboard payload.
  - This is an API change, so regenerate schema.d.ts. Keep `posture.compute` the one arithmetic (ADR 0070).
- **Tests:**
  - the seven are mapped;
  - the Art. 27 control exists and maps to Art. 27;
  - the every-requirement-mapped test passes;
  - the dashboard payload carries the count;
  - the card's line and link show only above 0.