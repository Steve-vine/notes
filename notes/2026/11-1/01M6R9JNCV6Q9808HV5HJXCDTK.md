---
id: 01M6R9JNCV6Q9808HV5HJXCDTK
created: 2026-11-06T11:23:21.371497Z
updated: 2026-11-06T12:21:45.082695Z
type: task
title: 'Collect now can''t read or keep captures: three of the worker''s task lanes have no access to evidence storage'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1617
sprint: s1jcke1
comments:
- id: 01M6RCXGKVE60T3396ZCX3N2W8
  author: Steve Vine
  at: 2026-11-06T12:21:42.651073Z
  text: |-
    Done: PR #1632 merged. On staging since 63d195ce (12:19 GMT, Browser smoke green).
    - Every worker container (worker, execution, status and interactive) now mounts the storage; checked on the live pod.

    Re-test, as E2E Admin B on ACC.13:
    - Collect now ran on the interactive lane: "filed 1, unchanged 0, held 0".
    - The new capture is in the register with its PDF.
    - The rule was judged with no "couldn't run" error.

    There's also a template test that every lane mounts the store.
assignee: steve
label:
- bug
priority: high
task_status: review
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