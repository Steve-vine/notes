---
id: 01M75AYARD2SYDCSGYTFFVC2DJ
created: 2026-11-11T12:57:19.885507Z
updated: 2026-11-11T12:57:19.885507Z
type: task
title: CHM.2 in the control library reads "approved by the Change Advisory Board", without "prior to implementation"
assignee: steve
priority: low
label: chore
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1728
---
Steve, 2026-11-11, during the SOC2-2026 policy review. CHM.2 said every production change is approved by the CAB *before* it happens. That conflicts with standard changes in the Change Management process: "A change that has been successfully completed a minimum of three times as a minor change and is deemed to be pre-approved. These changes can be completed at any time without seeking CAB approval but must be logged through the process."

**Already done in production:** the CHM.2 title was edited in Compass to "Changes to production infrastructure, systems and components must be approved by the Change Advisory Board". This was done through Polaris.

**This task:** make the same change in the seeded library (`app/backend/src/compass_api/data/controls.csv`, key CHM.2, Control column). Fresh installs and staging then match production. The importer only inserts missing rows, so production keeps the edit either way.

Also check whether the description's "agrees a production change before it happens" and "before implementation" should change to match. Standard changes are pre-approved by the CAB through the standard change list.

**Done when:** controls.csv carries the new wording; test counts are unchanged; staging shows the new title after a deploy.