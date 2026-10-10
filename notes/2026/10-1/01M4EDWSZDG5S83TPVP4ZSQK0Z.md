---
id: 01M4EDWSZDG5S83TPVP4ZSQK0Z
created: 2026-10-08T18:55:00.077469Z
updated: 2026-10-10T18:16:24.340508Z
type: task
title: HITRUST's 156 controls are mapped to the Compass controls that satisfy them — readiness comes from assessments already made
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 877
sprint: sfkkkex
blocked_by:
- 01M4EDWB7JZG4NSWXHHX7X6V34
comments:
- id: 01M4KGFJGMAFWVAMP384EXZNZ6
  author: Steve Vine
  at: 2026-10-10T18:16:24.340204Z
  text: |-
    Merged to main as PR #901 (2026-10-10). Goes to staging with the rest of the sprint.

    Every HITRUST control now lists the Compass controls behind it, graded, with a note saying why. HITRUST has a readiness figure on its page and on the Dashboard, derived from assessments already made. No Compass controls were added.

    THE READING — 156 controls
    - Fully covered: 78
    - Partly covered: 74
    - Unreached: 4
    398 rows, using 267 of Compass's 383 controls.

    UNREACHED — for a decision on whether the library should grow
    - 01.u Limitation of Connection Time — nothing limits when a high-risk application can be connected to.
    - 05.j Addressing Security When Dealing with Customers — nothing covers the security terms given to customers before they get access.
    - 10.c Control of Internal Processing — nothing asks applications to check for corrupted data during processing.
    - 10.e Output Data Validation — nothing asks applications to check what they put out.

    BY DOMAIN (fully / partly / unreached)
    - Information Protection Program 10 / 8 / 0
    - Endpoint Protection 2 / 0 / 0
    - Portable Media Security 2 / 2 / 0
    - Mobile Device Security 2 / 0 / 0
    - Wireless Security — no control of its own
    - Configuration Management 6 / 5 / 0
    - Vulnerability Management 2 / 2 / 2
    - Network Protection 5 / 3 / 0
    - Transmission Protection 2 / 7 / 0
    - Password Management 0 / 3 / 0
    - Access Control 13 / 4 / 1
    - Audit Logging & Monitoring 5 / 4 / 0
    - Education, Training and Awareness 1 / 1 / 0
    - Third Party Assurance 3 / 3 / 1
    - Incident Management 3 / 3 / 0
    - Business Continuity & Disaster Recovery 5 / 1 / 0
    - Risk Management 5 / 0 / 0
    - Physical & Environmental Security 6 / 8 / 0
    - Data Protection & Privacy 6 / 20 / 0
    Privacy is the thinnest, as expected: 20 of its 26 controls are only partly covered.

    HOW IT WAS GRADED — differs from the other frameworks, on purpose
    The other crosswalks are held to 100% cover. This one is not. Compass holds a HITRUST control by its name, not the requirement statements beneath it (ADR 0100), so:
    - "Does exactly this" is claimed on 12 rows only, where the control is a single idea (Clock Synchronization, Return of Assets, Cabling Security, Screening is NOT one of them, and so on).
    - Everywhere else the leading control "does part of this".
    - A control is called fully covered only where three or more Compass controls span it, or the set was judged to close it. Each such call carries its reason in the note.
    My first pass graded 66 rows as exact matches and came out at 117 fully covered. I regraded it down: an exact match against a control whose detail we cannot see is an overclaim. The readiness percentage is unaffected by this; it changes how many controls read "fully covered" versus "partly covered".

    TIERS — nothing applied, a decision for Steve
    Counting HITRUST as a ninth framework lifts 72 controls over a tier threshold:
    - 38 Specialised → Expected: ACC.13 ACC.2 ACC.7 BCR.14 CHM.6 CLD.2 CLD.9 END.17 END.20 END.21 IDM.10 IDM.19 IDM.7 IMA.6 INS.5 INS.6 KMC.2 KMC.7 KMC.8 KMC.9 NES.24 PDH.1 PDH.12 PDH.16 PEO.1 PEO.3 PEO.7 PES.16 PES.6 PES.7 PES.9 SOD.4 THP.7 VEM.14 VEM.4 VEM.9 VUM.10 VUM.14
    - 34 Expected → Essential: ASM.5 BCR.1 BCR.21 BCR.8 CHM.2 CHM.5 CLD.5 EVM.13 EVM.17 EVM.24 EVM.3 EVM.6 EVM.7 IDM.16 IMA.11 INA.1 INC.11 INS.17 INS.19 INS.2 INS.7 NES.17 NES.8 NES.9 PEO.4 PES.17 PES.3 RIM.7 SEA.10 SOD.17 SOD.9 VEM.11 VEM.3 VUM.7
    Tiers are stored, so none of these moved. The tier report will list all 72 until somebody rules.
    My recommendation: do not count HITRUST as a vote. It is assembled from ISO, NIST, PCI and HIPAA, so its agreement with them is not independent evidence that a control is basic. That would be a one-line change to the rule and its own decision record. Until then the 72 stand as reported drift.

    Technical
    - data/mappings/hitrust-csf-v11-8.csv, registered in the importer.
    - CI caught one thing after the first push: the crosswalk rules test requires an exact match to be graded 10, and HITRUST had to be registered in it. Fixed in the same PR; HITRUST is exempt from the 100%-cover rule and has its own pinned counts instead.
    - The tier tests used to assert no drift on a fresh library. They now assert no drift with HITRUST taken out of the evidence, and count the 72.
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 66, HITRUST Framework (ADR in COM-875; the library is COM-876). This is the bulk of the sprint's content work. Nobody assesses anything again: each HITRUST control is tied to the Compass controls that satisfy it, and a company's existing assessments turn into a HITRUST readiness figure.

## What people see

- **Each HITRUST control lists the Compass controls behind it**, graded as on every other framework (does this, does this and more, does part of this), with a note saying why.
- **HITRUST gets a coverage figure** on its own page and on the Dashboard's compliance by framework.
- **A control in Compass shows HITRUST** among the frameworks it answers to.
- **Where nothing in Compass reaches a HITRUST control, it shows as unreached**, not papered over. Those are reported to Steve as a list, to decide whether the Compass library should grow. This task adds no Compass controls.

## Notes (technical)

- **Data file.** `data/mappings/hitrust-csf-v11-8.csv` with `core_key,requirement_ref,relationship,strength,note,coverage_complete`, keyed on the control's `key` (ADR 0059 §5).
- **Built requirement-first** (COM-428): for each of the 156, which set of Compass controls together satisfies it. Not a keyword match, and not control-first.
- **A HITRUST control is broad.** Each stands for many requirement statements Compass does not hold, so expect mostly `subset_of` and `intersects_with`, with `equal` rare. Set `coverage_complete` only where the set has been judged to close the control, and say why in the note (ADR 0056 §2).
- **Cross-checks, not copies.**
  - HITRUST categories 01 to 12 descend from the ISO 27002 structure, so the ISO 27001 crosswalk is a useful second opinion on each row.
  - HITRUST's published mappings to ISO, NIST and HIPAA are a third.
- **Every row resolves.** A test in the shape of `test_mappings.py`: no row whose `core_key` or `requirement_ref` is skipped by the importer.
- **Tiers do not move** (ADR 0069 §2: stored, not computed). Run the tier drift report with HITRUST present, attach what it would change as a comment, and apply nothing.
- **Report in the task comment:** covered / partly covered / unreached, overall and per domain, plus the list of unreached controls. Expect category 13 (Privacy Practices) to be the thinnest.

**Done when:** staging shows a HITRUST coverage figure derived from existing assessments, every HITRUST control lists its contributing Compass controls or shows as unreached, and Steve has the unreached list.