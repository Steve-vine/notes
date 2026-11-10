---
id: 01M73MXCVCRJDQEHGB5KS466TT
created: 2026-11-10T21:13:06.156931Z
updated: 2026-11-10T21:13:19.066042Z
type: task
title: SOC 2 exact set closes the auditor's gaps — audit logging, customer commitments, leavers, network baselines and drift, mobile devices, device encryption and server-room power
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1694
sprint: s6acz3m
assignee: steve
label:
- improvement
priority: high
task_status: active
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