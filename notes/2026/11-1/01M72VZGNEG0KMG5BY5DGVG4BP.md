---
id: 01M72VZGNEG0KMG5BY5DGVG4BP
created: 2026-11-10T13:57:21.198516Z
updated: 2026-11-25T12:28:17.205145Z
type: task
title: Cyber Essentials 3.3 crosswalk completeness review — every library control that serves a requirement is linked to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1678
comments:
- id: 01M89AV4XHA9HF75NG8TD79JCF
  author: Steve Vine
  at: 2026-11-25T12:28:15.153555Z
  text: |-
    Done — merged to main in PR #2161 (not yet on staging; it goes with the other eight crosswalk reviews).

    All 41 Danzell requirements reviewed: 22 gain links, 19 needed nothing. 31 links added (87 → 118), all partial, each graded with a note. Coverage figures don't change: no requirement's "jointly complete" flag moved.

    What was missing: host firewalls on block-by-default; the six-monthly rule review; the device baseline on default passwords; MFA on firewall admin; phone/tablet passcode and auto-lock; automated patching on the 14-day rule; browser and email-client auto-update; account review and revocation; time-limited admin; the cloud shared-responsibility split; the IaaS/PaaS baseline; backup schedule; on-access scanning.

    Tier effect: ASM.14, IDM.15 (key CRD.8) and END.17 (key MDM.5) now reach Cyber Essentials, so the tier rule proposes Essential. Left for a curator.

    For a curator — existing links that look overstated (not changed):
    - SCP3 MDM.3, SCP4 RAT.1, SCP5 CLD (s42.CLD.8) — all "does the whole job": each covers managing or finding devices/services, not deciding what's in scope.
    - SU2 ASM.11 — CE needs unsupported software removed or isolated; a plan to remove it isn't enough.
    - FW3 NES.13 — a bastion host isn't one of the two routes CE allows (MFA or trusted addresses).
    - SU4 VUM.4 (key PAM.4) — its guidance allows a compensating control when a patch is late, which contradicts the auto-fail.
    - UAC5 (declared complete) — no linked control requires MFA on every cloud service for every user.
    - MP1 (declared complete) — nothing covers phones/tablets (official app store, sandboxing).

    Now look jointly complete (not declared): FW4 (NES.8 + DBC.10 + DBC.11); FW6 (ENE.5 + s42.NES.1); SC6 (ACC.22 + CRD.8).
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

Review each Danzell requirement against the question set and link every library control that serves it, graded the same way as today. Edit `data/mappings/cyber-essentials-3-3.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.