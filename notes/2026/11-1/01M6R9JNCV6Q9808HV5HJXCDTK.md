---
id: 01M6R9JNCV6Q9808HV5HJXCDTK
created: 2026-11-06T11:23:21.371497Z
updated: 2026-11-06T11:23:31.701494Z
type: task
title: 'Collect now can''t read or keep captures: three of the worker''s task lanes have no access to evidence storage'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1617
sprint: s1jcke1
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found in Claude's pre-UAT pass on staging, 6 Nov 2026. Sprint "Evidence Collection - Integrations", affects COM-1602, COM-1603 and COM-1606.

## What happens

- **Collect now** on a collected check runs on the worker's interactive lane.
- Only the main worker container mounts the evidence storage (`/data/storage`). The execution, status and interactive containers don't.
- So after a Collect now, judging the check's rule fails with FileNotFoundError on the newest capture. The rule shows **Can't tell, "The check couldn't run this time"**, and no gap is raised.
- And a Collect now whose answer has changed would write the new capture (and any held capture) to that container's temporary disk. That file is invisible to the API and lost when the pod restarts. It didn't happen on staging: both Collect nows found nothing new.

## Fix

- In `chart/templates/worker/deployment.yaml`, mount the storage volume in every worker container (`worker-execution`, `worker-status`, `worker-interactive`) as the main one does.
- Add a chart test that every worker container mounts storage when it's enabled.

**Done when:** on staging, Collect now on a check with a rule judges it Passing or Failing, not Can't tell; and a changed capture taken by Collect now opens as a PDF.

**Chain:** independent (chart only).