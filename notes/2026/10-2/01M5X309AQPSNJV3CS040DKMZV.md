---
id: 01M5X309AQPSNJV3CS040DKMZV
created: 2026-10-26T21:48:58.071351Z
updated: 2026-10-27T07:43:20.49415Z
type: task
title: Every requirement in every framework has a control mapped — the seven no control reaches (4 HITRUST, 3 UK GDPR, incl. a new control for Art. 27) are mapped, a test keeps it that way, and the dashboard explains any shortfall
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1345
sprint: s4zhkvy
comments:
- id: 01M5X898EBQJXEWR5SPR6D1BX7
  author: Steve Vine
  at: 2026-10-26T23:21:14.951715Z
  text: |-
    Done — PR #1357 merged (3074b05d).

    What changed:
    - Every requirement in every framework now has at least one control mapped, so HITRUST and UK GDPR can reach 100% like the others.
    - Six of the seven are mapped to existing controls as "partly covered": the control does part of the requirement, and the coverage pages say so.
    - UK GDPR Art. 27 has a new control of its own.
    - A test now fails if any requirement in any framework file has no control. The exceptions list it replaced also still named three HIPAA requirements and one NIST requirement, which had already been mapped.
    - On the Dashboard, a framework held down by requirements with no control shows "n requirements have no control mapped" under its bar. The line links to that framework's Crosswalk tab with "Only unmapped" already on. With the shipped library it only appears after someone unmaps a requirement in the app.

    The mappings, for you to check. All are "does part of this" (subset_of) and partly covered unless noted; the number is the strength.

    HITRUST:
    - 01.u Limitation of Connection Time:
      - NES.23 (key RAT.3), remote sessions disconnect when idle, 5;
      - ACC.8 (ACC.22), devices lock after 15 minutes, 3.
      - Nothing in the library sets permitted connection hours, so it stays partly covered.
    - 05.j Addressing Security When Dealing with Customers:
      - INS.5 (INS.10), contractual obligations identified, 5;
      - IDM.3 (ACC.6), access provisioning, 4;
      - INS.3 (INS.1), security policy given to external parties, 3.
    - 10.c Control of Internal Processing:
      - SOD.1, the secure development framework, 4;
      - SOD.3 (key SOD.4), code analysis, 4.
    - 10.e Output Data Validation:
      - SOD.1, 4;
      - SOD.3 (SOD.4), 3.
    - These four readings come from the HITRUST control names only, and no CSF text was consulted. That's recorded in hitrust-csf-v11-8.SOURCES.md.

    UK GDPR:
    - Art. 12(5) Free unless unfounded or excessive:
      - PDH.10 (PDH.12), access requests, where a refusal gives its reasons, 4;
      - PDH.15 (s42.PDH.4), correction and erasure, 3.
      - No control says that responding is free of charge, so it stays partly covered.
    - Art. 31 Co-operate with the Commissioner:
      - PDH.7 (PDH.9), ICO registration, 4;
      - IMA.3 (IMA.4), the contact register including regulators, 4;
      - IMA.8 (IMA.10), breach notification to the regulator, 3.
    - Art. 27 A representative in the UK: the new control **PDH.19** (key s89.PDH.1), "does all of this and more" (superset_of), 10, fully covered.
      - Wording: "Where the company offers goods or services to people in a jurisdiction it is not established in, or monitors them, it appoints a representative there in writing as that jurisdiction's data protection law requires, and records who and where."
      - Its "What good looks like" covers: identify the jurisdictions; appoint in writing before processing starts; record who, where and when, and name them in privacy information; record why none is needed.
      - It's Specialised, which is what the tier rule proposes for a control only UK GDPR reaches.

    Other calls:
    - The Dashboard line links to the Crosswalk tab rather than Coverage, because that's where "Only unmapped" lives. That switch is now kept in the page address, so the link can turn it on.
    - I didn't add a line about representatives to the Personal Data Handling policy. A policy covers its domain's controls by membership, so PDH.19 is covered as it stands. Worth a look when that policy is next reviewed.

    To smoke-test on staging, once deployed (the seed import adds the control and mappings):
    - HITRUST shows 100%.
    - UK GDPR shows 65/66, because PDH.19 is new and not yet assessed. Mark it Not applicable for Test Company and Company One, and UK GDPR goes to 100%.
    - Each framework's Crosswalk tab, with "Only unmapped" on, is empty.
- id: 01M5Y50KXEESYB5AMQF12QC4RW
  author: Steve Vine
  at: 2026-10-27T07:43:20.493949Z
  text: |-
    Correction to my Done comment: "UK GDPR reads 65/66 until PDH.19 is marked Not applicable" was the wrong step.

    The figure counts requirements, not controls. Art. 27 leaves the count only when the requirement itself is ruled out of scope. To do that, open UK GDPR, go to Art. 27, click "Rule out of scope" and give a reason. UK GDPR then reads 65/65.

    Marking the control alone never moves the figure:
    - PDH.19's "Not applicable" status button, with "In scope" still on, counts as not implemented (as designed: the Dashboard treats it the same way).
    - Even with "In scope" switched off on PDH.19, Art. 27 is left with no control in scope and reads "not assessed", so it is still not met.

    Staging check (2026-10-27): Test Company's PDH.19 has status Not applicable, In scope on. Art. 27 has no scope decision.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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