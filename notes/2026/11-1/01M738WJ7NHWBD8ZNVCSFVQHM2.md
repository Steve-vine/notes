---
id: 01M738WJ7NHWBD8ZNVCSFVQHM2
created: 2026-11-10T17:42:55.989881Z
updated: 2026-11-10T20:36:08.079112Z
type: task
title: SOC 2 in Compass becomes the signed-off exact set — unneeded links removed on every environment at deploy, and a test keeps every criterion in the agreed shape
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1691
sprint: s6acz3m
blocked_by:
- 01M738VYSNS10XYX0RYRCGNERX
- 01M738W6271W48YKE8KNCNRH3G
comments:
- id: 01M73JSNTS8EQ1DDW33DR2ATR3
  author: Steve Vine
  at: 2026-11-10T20:36:07.12968Z
  text: |-
    Done, merged as #1691 and deployed to staging at 961dcaea (2026-11-10).

    **Pre-UAT: Passed** (staging, checked as Steve via the staging assistant tools and the staging database).
    - **Deploy:** Helm upgrade, rollout, smoke check and Browser smoke are all green (run 42894822429).
    - **Database:** SOC 2 has exactly 253 live links to 151 controls and 55 "complete together" flags (one per set). All 33 `s112` controls are present (10 from COM-1670 and 23 from COM-1690).
    - **SOC 2 coverage report for E2E Test Company:** 61/61 fully covered, 0 partly, 0 not covered. Every row lists exactly the agreed controls.
    - **Spot checks:**
      - **CC6.2:** IDM.3 (provisioning and revoking; carries CC6.2-01 and -03, strength 7) and IDM.5 (account review; carries -02, strength 3). Declared complete. The joiners-only IDM.1 is gone.
      - **CC7.1:** END.2, NES.11, THP.16 and VUM.8.
      - **A1.3:** BCR.8, BCR.15 and BCR.24 (new: test scenarios).
      - **P1.1:** PDH.23 (new: privacy notice; carries P1.1-01 to -07) and PDH.8 (carries -02).
      - Each link's note names the points of focus it carries.
    - **New controls:** CHM.7 shows its full wording, "What good looks like" and evidence, tier Specialised, with CC8.1 under it.
    - **Before the deploy,** staging had no SOC 2 link or "complete" flag made by a person, so the import applied the set cleanly. No criterion moved from a set to a single control, so the new flag withdrawal didn't fire here; its test covers it.
    - **Production:** I couldn't query its database from here. If anyone has added or edited a SOC 2 link on screen in production, the import will leave it in place, and it should be checked after the production deploy.
assignee: steve
label:
- improvement
priority: high
task_status: review
---
**Why.** This is where Steve's three rules (COM-1682) become true in Compass. Once it lands, completing the controls linked to SOC 2 means SOC 2 is met, and nothing more.

**What people see.** Each SOC 2 criterion lists only the controls agreed in COM-1689. Every criterion reads fully covered. A company's SOC 2 figure asks for the agreed set of controls and no more. Other frameworks don't change.

**What changes:**
- **Rewrite** `data/mappings/soc-2-tsc-2017.csv` to the signed-off set:
  - each link with its relationship, strength and a note naming the points of focus it carries;
  - each criterion flagged complete where its set is partial controls.
- **Removed links go everywhere.** The deploy-time import retires links the file no longer claims, so links come off staging and production at the next deploy, and a clean install builds the same set.
- **Check first.** Before merging, look on staging and production for any SOC 2 link a person added or changed on screen. The import leaves those alone, so each needs a decision.
- **Same for the "complete" flag.** Confirm a criterion that moves from a set to a single control loses its "complete" flag on an existing install.
- **New test.** Every SOC 2 criterion has exactly one of the two shapes, and no criterion has a control that does the whole job beside other links.
- **Existing tests move.** The pinned SOC 2 count, `test_privacy_rights_control` if COM-1687 changed P2.1/P4.1/P5.1, and the tier test: most of COM-1669's `_LIFTED_BY_SOC2` names drop out. Proposed tiers are still left for a curator (ADR 0069).

**Where.** Data and tests only: no migration, no API change. **Independent.** Blocked by COM-1689 and, if it has work, COM-1690.

**Done when:**
- On staging, SOC 2 has the agreed number of links and controls.
- Spot checks show the agreed set and nothing else, e.g. CC6.2, CC7.1, A1.3 and P1.1.
- Every criterion reads fully covered.
- The new shape test is green.