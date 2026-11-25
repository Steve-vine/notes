---
id: 01M72VYQHXGS7YHHJMZDE4QWRR
created: 2026-11-10T13:56:55.485711Z
updated: 2026-11-25T12:46:06.46596Z
type: task
title: ISO 27001:2022 crosswalk completeness review — every library control that serves a requirement is linked to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1671
comments:
- id: 01M89BVV41YAXWQ0JG5YAH1CTD
  author: Steve Vine
  at: 2026-11-25T12:46:06.46583Z
  text: |-
    PR #2162 (bottom of the stack of eight; auto-merge on).

    Every requirement reviewed — all 25 clauses 4–10 and all 93 Annex A controls. 92 gain links, 26 needed nothing. 403 links added (340 → 743), 146 controls new to ISO 27001, all partial, each graded with a note. Library cover doesn't move (no "jointly complete" flag changed).

    What was missing: automated patching (VUM.1–3) on A.8.8/A.8.19; the awareness modules on A.6.3; mobile and endpoint management; the identity lifecycle on A.5.16–18; supplier agreements, due diligence and exit terms; cloud posture and drift; logging sources on A.8.15/16; BIA and recovery objectives on A.5.30; backup integrity; the privacy controls on A.5.34; change and secure development; opportunities and treatment tracking in clause 6.

    Worth knowing: a requirement now reads Met for a company only when the newly linked controls are implemented too, so ISO figures can dip where a company hasn't assessed them. 28 controls newly reach a framework that lifts their proposed tier — left for a curator.

    For a curator — existing links that look overstated (not changed):
    - A.5.6 VUM.14 (threat intelligence) "does the whole job": isn't membership of special interest groups.
    - A.5.35 VUM.7 (pen test): not an independent review of how security is managed.
    - A.7.13 PES.8 "exactly this": environmental equipment only, not all equipment.
    - A.7.5 BCR.12: evacuation protects people, not facilities.
    - 4.3 control selection: its own note says it doesn't set the scope boundary.
    - A.5.37 DCS.5: environment documentation isn't operating procedures.

    Now look jointly complete (not declared): A.8.8, A.8.15, A.5.30, A.6.3, A.5.18, A.5.20, A.8.24, A.8.32. A.5.37 is close to discharged by INS.8 (documented procedures run on schedule).
assignee: steve
label:
- improvement
priority: high
task_status: active
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement. Example: the automated patching controls (VUM.1–VUM.3) are linked only to Cyber Essentials.

ISO 27001 is held as titles only (licensed wording), so judge each Annex A control and clause against its full intent and against what a certification auditor asks for. Link every library control that serves it, graded the same way as today. Edit `data/mappings/iso-27001-2022.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.