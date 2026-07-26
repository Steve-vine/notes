---
id: 01KYF6WZ62D6YVF1T3YT68RJSG
created: 2026-07-26T12:37:48.866399Z
updated: 2026-07-26T12:37:48.866399Z
type: task
title: Split backend lint/format/mypy into a job parallel to pytest
label: improvement
assignee: steve
task_status: backlog
priority: low
project: 01KX671DATY39VW6GWK3M2T3DN
number: 319
---
In the backend job, ruff lint + format + `mypy --strict` (~42s+) run **serially before** the ~293s pytest, so a lint/type failure only surfaces after the whole ~9m job and holds a runner the whole time. Split them into a separate fast job that runs in parallel with pytest (both gate the merge). Fast-fail + frees a runner slot sooner.

Acceptance: lint/type failures return in <1m; backend critical path unchanged or shorter.