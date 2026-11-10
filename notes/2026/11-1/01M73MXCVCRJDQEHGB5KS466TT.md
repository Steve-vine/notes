---
id: 01M73MXCVCRJDQEHGB5KS466TT
created: 2026-11-10T21:13:06.156931Z
updated: 2026-11-10T21:50:26.840225Z
type: task
title: SOC 2 exact set closes the auditor's gaps — audit logging, customer commitments, leavers, network baselines and drift, mobile devices, device encryption and server-room power
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1694
sprint: s6acz3m
comments:
- id: 01M73Q1RB7S9K8VSZ9ZNM25C9X
  author: Steve Vine
  at: 2026-11-10T21:50:26.15154Z
  text: |-
    Done, merged as #1693 and deployed to staging at 4f5e554e (2026-11-10).

    **What's in it:**
    - **Joint carriers added:**
      - EVM.2 (CC7.2-01);
      - INS.21 (CC2.3-06/-07, in place of INS.22 there);
      - IDM.2 (CC6.2-03);
      - END.4 (CC7.1-01);
      - END.15 and KMC.6 (CC6.7-04);
      - KMC.1 (CC6.7-03, replacing END.20);
      - PES.8 (A1.2-05, the on-site server rooms).
    - **New control END.23** (key s112.END.2): network device configuration compared with its baseline, and drift or unauthorised change detected, alerted and corrected. It carries CC7.1-02 with END.2. Tier Specialised.
    - **The set:** 159 controls (135 existing, 24 new) and 261 links, all generated from `audit/soc2-exact-set/final.json`.
    - **Audit notes:** the 16 A-SCEND and Carbide items that asked for these controls now point at them. A-SCEND now has no uncovered request: P-7, the customer list, is answered by INS.21.

    **Pre-UAT: Passed.**
    - Deploy run 42906884854: Helm, rollout, smoke check and Browser smoke all green.
    - Database: SOC 2 has 261 live links to 159 controls, with 55 "complete together" flags.
    - CC7.1 lists END.2, END.4, END.23, NES.11, THP.16 and VUM.8.
    - A1.2 lists PES.8 beside CLD.7 and BCR.8 for A1.2-05.

    **Tests:** 419 controls, SOC 2 count 261, and tier drift 98→99. END.15 now reaches three frameworks, so it's proposed Expected and left for a curator.

    **Released as v0.20.0** from 4f5e554e (Steve: "yes, release v0.20.0 from 4f5e554e").

    **One note for Steve:** environmental detection and alerts (A1.2-02, -04) are carried by CLD.7, whose wording says "data centre locations". If the on-site server rooms aren't read as data centre locations, a premises monitoring control would be needed there too.
assignee: steve
label:
- improvement
priority: high
task_status: review
---
**Why.** Re-pointing the A-SCEND and Carbide items at the exact set (COM-1692) showed points where the control carrying them today only reaches part of what A-LIGN will test. Steve (2026-11-10) agreed to add each as a joint carrier of the point concerned, with a new control for network drift. He also confirmed that on-site server rooms hold in-scope infrastructure that needs battery backup.

**What changes:**

| Control | Point of focus | Alongside | What it adds |
|---|---|---|---|
| EVM.2 audit logs collected centrally | CC7.2-01 | EVM.6 | the logs detection and the auditor rely on |
| INS.21 customer commitments register | CC2.3-06, -07 | VEM.8, INS.23 (replaces INS.22 on these two points) | commitments reach customers through contracts, SLAs and DPAs |
| IDM.2 leavers process | CC6.2-03 | IDM.3 | removal tied to the leaving date |
| END.4 network device baselines | CC7.1-01 | END.2 | routers, switches and firewalls |
| **new: network configuration drift detected** | CC7.1-02 | END.2 | drift on network devices after deployment |
| END.15 mobile device management | CC6.7-04 | END.3 | phones and tablets |
| KMC.6 laptop and workstation disk encryption | CC6.7-04 | END.3 | encrypted laptops |
| KMC.1 portable media encryption | CC6.7-03 | PES.12 (**replaces END.20**) | memory sticks and drives, plus phones and tablets |
| PES.8 backup power for critical equipment | A1.2-05 | CLD.7, BCR.8 | on-site server rooms |

- **Set size:** 151 → 159 controls (eight added, END.20 out).
- **Records:** the set and its decisions are updated in `audit/soc2-exact-set*`.
- **Crosswalk:** regenerated from `final.json`.
- **Audit notes:** the A-SCEND and Carbide items that asked for these controls now point at them.
- **Other frameworks:** unchanged.

**Where.** Data, tests and `audit/`. **Independent.**

**Done when:**
- On staging, SOC 2 shows the new links and the new control.
- All 61 criteria are still fully covered.
- The shape test is green.
- Then release v0.20.0 (Steve, 2026-11-10).