---
id: 01M72VZ016VKRW9AW2B5RME7D9
created: 2026-11-10T13:57:04.166853Z
updated: 2026-11-25T13:04:27.452035Z
type: task
title: PCI DSS 4.0.1 crosswalk completeness review — every library control that serves a requirement is linked to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1673
comments:
- id: 01M89BW1XBX0Q8M04PYQA81MTH
  author: Steve Vine
  at: 2026-11-25T12:46:13.419253Z
  text: |-
    PR #2163 (stacked on COM-1671 #2162).

    All 313 assessable requirements reviewed against their testing procedures. 235 gain links, 78 needed nothing. 509 links added (643 → 1,152), 67 controls new to PCI, all partial, each graded with a note. Library cover doesn't move.

    What was missing: documented procedures and role duties on every x.1.1/x.1.2; patch deployment (VUM.1–4) on 6.3.3; EDR, host intrusion prevention and host firewalls; network change and drift; cloud configuration, access review and logging; log review; the incident plan's components on 12.10.1; key management detail; supplier agreements on 12.8; equipment siting and cabling on 9.2.3. RIM.2 now also serves 12.3.2, so it shows the customised-approach evidence row too.

    For a curator — existing links that look wrong or overstated (not changed):
    - 1.2.7 ACC.8: its own note says it's about people, not rulesets.
    - 10.2.1.7 EVM.7: detects external access; doesn't log system-level object changes.
    - 8.4.2 CRD.3 "exactly this": outside access only; 8.4.2 covers all non-console access to the CDE.
    - 7.2.5.1 ACC.8: recertifies users, not application/system accounts (ACC.23 fits better).
    - 12.9.2 VEM.4: monitors our suppliers — wrong direction.
    - 8.2.3 RAT.4: our remote-user register, not a provider's unique factor per customer.
    - 2.3.2 KMC.3, 3.5.1.1 KMC.2, 3.6.1.2 IDM.4: each narrower than the requirement.
    - 9.4.6 WSS.3: recycling bins don't ensure cross-cut shredding.
    - 9.4.1.2 BCR.3: continuity verification isn't a review of the backup location's security.
    - 5.2.3 THP.1: a strategy doesn't carry out the periodic evaluation.
    - 12.4.2 INA.2: internal audit isn't the quarterly operational review (INS.8 fits better).

    Now look complete (not declared): 1.2.7 (NES.1 alone), 2.2.7 (DBC.12 alone), 6.3.3, 1.2.8, 5.2.1, 8.2.5, 9.2.3, 10.4.1.1, 3.2.1; 12.10.1 bar the payment-brand procedures.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement. Example: PCI 6.3.3 (security patches) links the vulnerability process and supported software but not the patch deployment controls VUM.1–VUM.4.

Review all 313 assessable requirements against their testing procedures and link every library control that serves each, graded the same way as today. Edit `data/mappings/pci-dss-4-0-1.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.