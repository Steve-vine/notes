---
id: 01M738WTED20BDV96DH6S82TWB
created: 2026-11-10T17:43:04.397986Z
updated: 2026-11-10T22:33:51.25947Z
type: task
title: Audit notes re-pointed at the exact set — Carbide and A-SCEND requests mapped to the agreed SOC 2 controls, and the gap report brought up to date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1692
sprint: s6acz3m
blocked_by:
- 01M738WJ7NHWBD8ZNVCSFVQHM2
comments:
- id: 01M73HXG6MVMW758AMNKY367XR
  author: Steve Vine
  at: 2026-11-10T20:20:43.860243Z
  text: |-
    Done, merged as #1692. The audit notes now point at the exact set.

    **What changed:**
    - **Carbide and A-SCEND items:** every Carbide control, every Carbide evidence item and every A-SCEND request now names the exact-set controls whose evidence answers it. The old list is kept as `compass_before`. Full request descriptions were read from A-SCEND, read-only.
      - A-SCEND: 164 of 181 requests are fully answered by the set. Verdicts are now 137 covered, 43 partial and 1 gap; before they were 79, 93 and 9.
      - Carbide: 41 of 59 controls are fully answered (15 covered, 43 partial, 1 gap). Of the 267 evidence items, 233 are fully answered.
      - The two remaining gaps are A-SCEND P-7 (customer list) and Carbide CNS16 (inspecting encrypted traffic).
    - **`soc2-mapping.md`:**
      - the overstated-links section is closed;
      - its five privacy references are corrected (PDH.8, PDH.2, PDH.13, PDH.17, ACC.14);
      - a new section, "Against the exact set", lists every item that needs a control outside the set.
    - **Other files:**
      - `compass-soc2-criteria.json` is rebuilt from the set;
      - the old appendix is marked superseded;
      - the README log is updated.

    **For Steve to decide: 17 A-SCEND requests and 18 Carbide controls need a control outside the set.**
    - **Possible gaps in the set:**
      - audit logging (EVM.2), which A-LIGN tests under CC7.2 in 7 items;
      - the customer commitments register (INS.21);
      - removing leavers' access within a deadline (IDM.2);
      - network-device baselines (END.4);
      - mobile devices (END.15);
      - laptop encryption (KMC.1);
      - office UPS (PES.8, the open A1.2-05 question).
    - **Evidence beyond SOC 2's points of focus:**
      - pen test reports (VUM.7, VUM.11);
      - IDS and IPS (NES.16, NES.18);
      - CCTV (PES.5) and visitor logs (PES.17);
      - labelling (INC.4) and asset owners (ASM.2);
      - separate environments (CLD.4), a judgement call;
      - the network diagram (NES.8);
      - the employment contract (INS.7), AUP (INS.1) and NDA (PEO.3);
      - DPIA (PDH.12).
assignee: steve
label:
- chore
priority: medium
task_status: done
---
**Why.** Evidence collection works from `audit/`: collect in Compass, then copy to Carbide, then to A-SCEND. Its mapping files still point at controls from before the exact set. Once COM-1691 lands, each Carbide control and each A-SCEND request should point at the agreed SOC 2 controls. That way, evidence gathered for the set answers what both platforms ask.

**What changes:**
- Re-point `audit/mapping/carbide-controls.json` and `audit/mapping/ascend-requests.json` at the agreed set.
- Flag any request that now points at a control outside the set. That's either evidence the auditor wants that SOC 2 doesn't need, or a sign the set is missing something; it goes back to Steve.
- Rewrite the "overstated links" part of `audit/soc2-mapping.md` as closed.
- Add an entry to the log in `audit/README.md`.

**Where.** `audit/` only. **Independent.** Blocked by COM-1691.

**Done when:**
- Every Carbide control and A-SCEND request maps only to controls in the agreed set, or is listed for Steve with the reason.
- The README log records the change.