---
id: 01M72VZ9NTWVHSTM9GYWYDJXKF
created: 2026-11-10T13:57:14.0423Z
updated: 2026-11-25T13:13:30.494252Z
type: task
title: NIST CSF 2.0 crosswalk completeness review — every library control that serves a subcategory is linked to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1676
comments:
- id: 01M89BWS3EK7GZ5MN69QGT8YZZ
  author: Steve Vine
  at: 2026-11-25T12:46:37.166652Z
  text: |-
    PR #2167 (stacked on COM-1675 #2166).

    All 106 subcategories reviewed against NIST's implementation examples. 100 gain links, 6 needed nothing. 423 links added (309 → 732), 143 controls new to NIST CSF, all partial, each graded with a note. Library cover doesn't move.

    What was missing: patching (VUM.1–4) on PR.PS-02 and ID.RA-01; vulnerability discovery sources (pen tests, code analysis, IaC/container scanning, cloud posture); secure development and the software supply chain on PR.PS-06 and GV.SC-09; supplier agreements and changes across GV.SC; stakeholder communication in RS.CO and RC.CO; hardening and access on PR.PS-01 / PR.AA; detection on DE.CM-09; backup and recovery on PR.DS-11 and RC.RP; the governance spine (board, compliance programme, control procedures, risk method on GV.RM-06 / ID.RA-05).

    For a curator — existing links that look overstated, all "does the whole job" (not changed):
    - ID.AM-05 ASM.2: having an owner doesn't prioritise.
    - PR.PS-03 ASM.6: tagging before issue doesn't cover maintenance/replacement.
    - RC.RP-05 DBR.2: checking backups isn't verifying restored assets.
    - ID.AM-08 ASM.11: software only.
    - PR.AA-03 CRD.2: a password policy doesn't authenticate services or hardware.
    - ID.RA-08 SOD.2: internal handling, not receiving outside disclosures.
    - ID.IM-02 VUM.7: pen tests are one source; no third-party exercises.
    - GV.RM-03 RIM.1: reports to leadership, not into enterprise risk management.
    - Also GV.OC-03 ASM.14 at 6 overstates (IP only; ~3 fits).

    Now look jointly complete (not declared): GV.RM-06, ID.RA-05, PR.DS-11, PR.PS-02, ID.RA-08, GV.SC-05, GV.SC-02, RS.CO-02, PR.AT-01; RC.CO-03 nearly.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

Review each subcategory against NIST's implementation examples and link every library control that serves it, graded the same way as today. Edit `data/mappings/nist-csf-2-0.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every subcategory has been reviewed, the additions are graded with notes, and the crosswalk tests are green.