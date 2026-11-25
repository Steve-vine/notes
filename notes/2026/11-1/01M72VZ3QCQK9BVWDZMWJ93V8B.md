---
id: 01M72VZ3QCQK9BVWDZMWJ93V8B
created: 2026-11-10T13:57:07.948778Z
updated: 2026-11-25T12:46:19.417958Z
type: task
title: HIPAA crosswalk completeness review — every library control that serves a requirement is linked to it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1674
comments:
- id: 01M89BW7RS7714V9RNTEW5310M
  author: Steve Vine
  at: 2026-11-25T12:46:19.417793Z
  text: |-
    PR #2164 (stacked on COM-1673 #2163).

    All 72 Security Rule and Breach Notification requirements reviewed. 65 gain links, 7 needed nothing. 323 links added (148 → 471), 132 controls new to HIPAA, all partial, each graded with a note. Library cover doesn't move.

    What was missing: finding where ePHI is and re-assessing on change in the risk analysis; control selection and residual risk in risk management; the access lifecycle across workforce security and access control; malware layers (EDR, mail gateway, application control, media scanning); the incident chain; backup verification and recovery objectives; log review, protection and retention; encryption and key management; business associate due diligence, agreements and flow-down; facility security; breach-notification records.

    For a curator — existing links that look overstated (not changed):
    - 164.310(a)(2)(iv) PES.8 "exactly this": environmental equipment, not repair records for doors/locks/walls. No library control covers that — a real gap.
    - 164.308(a)(7)(ii)(C) BCR.11: an office recovery plan, not emergency-mode operation for ePHI (BCR.2 fits better).
    - 164.316(b)(2)(iii) INS.5: a fixed cycle doesn't cover updates on change.
    - 164.314(a)(2)(i) VEM.3: generic clauses miss the specific BA terms.
    - 164.308(a)(1)(ii)(A) RIM.2: a method doesn't make the analysis thorough across all ePHI.
    - 164.312(e)(2)(i) NES.12: current protocols aren't modification detection.
    - 164.310(d)(2)(iv) DBR.1: a schedule doesn't ensure a copy before equipment moves.
    - 164.402 IMA.8: estimates scale, not the four-factor low-probability test.

    Now look jointly complete (not declared): 164.308(a)(7)(ii)(A), 164.308(a)(6)(ii), 164.312(b), 164.314(a)(2)(i), 164.312(a)(2)(iii).
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

HIPAA's standards are broad (it averages two controls per requirement), so it's one of the most exposed. Review each Security Rule and Breach Notification standard and implementation specification, and link every library control that serves it, graded the same way as today. Edit `data/mappings/hipaa-2013.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.