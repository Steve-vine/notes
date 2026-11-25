---
id: 01M72VZD9E7TS7Z2T1TBB1SPJK
created: 2026-11-10T13:57:17.742256Z
updated: 2026-11-25T13:15:56.224009Z
type: task
title: CIS Controls v8.1 crosswalk completeness review — every library control that serves a safeguard is linked to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1677
comments:
- id: 01M89BWZ0J98XDSKR5DTCDB5MA
  author: Steve Vine
  at: 2026-11-25T12:46:43.217819Z
  text: |-
    PR #2168 (stacked on COM-1676 #2167).

    All 153 safeguards reviewed against their v8.1 text. 99 gain links, 54 needed nothing (mostly narrow safeguards with one exact control). 163 links added (234 → 397), 64 controls new to CIS, all partial, each graded with a note. v8 keeps the crosswalk it shipped with.

    What was missing: automated patching (VUM.1 on 7.3, VUM.2 on 7.4, VUM.3 on 12.1, VUM.4 on 7.2–7.7); EDR on 10.x/13.x; cloud and container controls; infrastructure as code; network drift, wireless and firewall configuration; mobile device management; the incident response chain across Control 17; supplier contract clauses on 15.3–15.7; pen test findings on 18.3; detection tuning on 18.4; retention and disposal on 3.4/3.5.

    Tier effect: controls reaching an IG1 safeguard rise from 81 to 124, and the tier rule proposes those Essential. Left for a curator.

    For a curator — existing links that look wrong or overstated (not changed):
    - 1.2 ASM.3: about taking equipment off site, not unauthorised devices. Looks wrong.
    - 18.4 VUM.10 (threat modelling): design-stage, not validating measures. Looks wrong.
    - 7.3/7.4 VUM.8 "does the whole job": a process isn't automated patching — should be partial now VUM.1/2 are linked.
    - 7.3 ASM.11, 7.4 SOD.14, 4.6 CHM.1: loose.
    - 12.5 ACC.27 "does the whole job": a directory isn't network AAA (RADIUS/TACACS).
    - 13.1 EVM.1 "does the whole job": central logs aren't centralised alerting.
    - 10.2 THP.10 "does the whole job": doesn't mention automatic signature updates.

    Now look complete (not declared): 7.3, 7.4, 12.1, 10.1, 15.4; 13.3 already discharged.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement. Example: safeguards 7.3/7.4 (automated OS and application patch management) don't link the automated patching controls VUM.1/VUM.2.

Review each safeguard and link every library control that serves it, graded the same way as today. Edit `data/mappings/cis-controls-v8-1.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every safeguard has been reviewed, the additions are graded with notes, and the crosswalk tests are green.