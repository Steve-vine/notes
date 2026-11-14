---
id: 01M75AYARD2SYDCSGYTFFVC2DJ
created: 2026-11-11T12:57:19.885507Z
updated: 2026-11-14T17:05:12.944969Z
type: task
title: CHM.2 in the control library reads "approved by the Change Advisory Board", without "prior to implementation"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1728
comments:
- id: 01M75VQN5XS0G8C0Q7M5Y4RF2D
  author: Steve Vine
  at: 2026-11-11T17:50:46.973786Z
  text: |-
    Done. PR #1726 (auto-merge on).

    What changed:
    - controls.csv's CHM.2 title now reads "Changes to production infrastructure, systems and components must be approved by the Change Advisory Board".
    - Its guidance now explains each change type, matching the published Change Management Policy v2:
      - major and minor changes are approved by the board before they are made;
      - standard changes are pre-approved through the board's list and logged each time;
      - emergency changes are approved by an emergency approver acting for the board, and confirmed afterwards.
    - Production's CHM.2 description was edited to the same text through Polaris, so production and the seed now match.

    Counts are unchanged, and the control tests pass locally (53).
- id: 01M76B1NPQR8NRKHCR73PJV2AJ
  author: Steve Vine
  at: 2026-11-11T22:18:23.831394Z
  text: |-
    Passed (Claude's pre-UAT pass, staging fcaf1d13, as E2E Admin A).

    Steps: opened Playbook ▸ Controls ▸ CHM.2.

    Seen:
    - The title reads "Changes to production infrastructure, systems and components must be approved by the Change Advisory Board", with no "prior to implementation".
    - The guidance explains each change type, matching the published Change Management Policy v2:
      - major and minor changes are approved by the board before they are made;
      - standard changes are pre-approved through the board's list and logged each time;
      - emergency changes are approved by an emergency approver acting for the board, and confirmed afterwards.
    - Evidence now includes "the list of standard changes" and "a sample of emergency changes and their confirmation".
    - Mappings are unchanged: 7 requirements across 5 frameworks, including SOC 2 CC8.1.

    "Test counts unchanged" is CI's job, and CI was green.

    Screenshot: ~/compass-uat/sprint0-2026-11-11/COM-1728/chm2-control.png
assignee: steve
label:
- chore
priority: low
task_status: done
---
Steve, 2026-11-11, during the SOC2-2026 policy review. CHM.2 said every production change is approved by the CAB *before* it happens. That conflicts with standard changes in the Change Management process: "A change that has been successfully completed a minimum of three times as a minor change and is deemed to be pre-approved. These changes can be completed at any time without seeking CAB approval but must be logged through the process."

**Already done in production:** the CHM.2 title was edited in Compass to "Changes to production infrastructure, systems and components must be approved by the Change Advisory Board". This was done through Polaris.

**This task:** make the same change in the seeded library (`app/backend/src/compass_api/data/controls.csv`, key CHM.2, Control column). Fresh installs and staging then match production. The importer only inserts missing rows, so production keeps the edit either way.

Also check whether the description's "agrees a production change before it happens" and "before implementation" should change to match. Standard changes are pre-approved by the CAB through the standard change list.

**Done when:** controls.csv carries the new wording; test counts are unchanged; staging shows the new title after a deploy.