---
id: 01M5ENAS2PCSE5QHH02JQF1D73
created: 2026-10-21T07:20:39.766739Z
updated: 2026-10-21T07:45:36.783792Z
type: task
title: Give the background scheduler 350 MB of memory — it now idles at 216 MB of its 256 MB
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1191
sprint: sq3fav7
comments:
- id: 01M5EPR8C8PYF2280JFPH426EW
  author: Steve Vine
  at: 2026-10-21T07:45:29.992378Z
  text: |-
    Done — merged in PR #1189, on staging since 08:36 BST (with COM-1190).

    - The background scheduler on staging can now use up to 350 MB, up from 256 MB. It's using 216 MB and running with no restarts.
    - Production gets the same 350 MB at the next release.

    My calls:
    - The scheduler now reserves 256 MB (it was 128 MB), roughly what it actually uses. That way the server makes room for it rather than treating it as first to stop when memory runs short.
    - The smaller "evaluation" size was raised to 350 MB as well, since it's the same scheduler.
assignee: steve
label:
- chore
priority: medium
task_status: review
---
Found after the sprint 81 staging deploy (2026-10-21 05:10 BST): the background scheduler (Celery Beat) sat steady at 216 MB of its 256 MB limit. It imports the whole app, so it grows with each module; at 128 MB it once crashed in a loop (COM-767). Steve asked for 350 MB.

## Notes (technical)

- `chart/values-staging.yaml` beat limit 256Mi → 350Mi.
- `chart/values.yaml` presets `evaluation` and `production` beat limit 256Mi → 350Mi, so production gets it at the next release (unless the Argo CD env pins its own).
- Requests 128Mi → 256Mi everywhere: a request below what the pod actually uses lets the node overcommit and evict it first.

**Done when:** on staging the Beat pod's limit is 350Mi and it runs without restarts.