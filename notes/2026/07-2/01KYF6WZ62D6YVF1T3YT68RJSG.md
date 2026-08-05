---
id: 01KYF6WZ62D6YVF1T3YT68RJSG
created: 2026-07-26T12:37:48.866399Z
updated: 2026-08-05T12:03:04.123582Z
type: task
title: Split backend lint/format/mypy into a job parallel to pytest
project: 01KX671DATY39VW6GWK3M2T3DN
number: 319
sprint: sr2f21y
comments:
- id: 01KYFE6VGE2T2E17VTR0Y953SQ
  author: Steve Vine
  at: 2026-07-26T14:45:32.814715Z
  text: |-
    Done — PR #277 (feature/ise-319-split-lint), green.

    Split ruff lint + format + mypy out of the backend job into a parallel backend-lint job. Verified on this PR: backend-lint completed in ~50s (running concurrently with pytest), so a lint/type failure now surfaces in <1m instead of after the full test job; backend (test) job dropped the ~42s of static checks. All jobs green.

    One deliberate deferral: backend-lint is NOT yet a branch-protection required check. Adding a required check that a branch can't produce would block that branch's PR — so it can only be added safely once every sprint branch predating this job (272-277) is merged to main. Until then it gates in practice (visible red on the PR + it reddens the staging/main push, which re-runs the whole suite). Documented in the job comment. Recommend adding `backend-lint` to main's required checks as a one-line follow-up after this sprint releases to main.

    Trade-off noted: the parallel job re-adds a uv install (needs its own venv) — cheap now that ISE-315/316 keep installs + cache on-LAN.
assignee: steve
label: null
priority: low
task_status: done
---
In the backend job, ruff lint + format + `mypy --strict` (~42s+) run **serially before** the ~293s pytest, so a lint/type failure only surfaces after the whole ~9m job and holds a runner the whole time. Split them into a separate fast job that runs in parallel with pytest (both gate the merge). Fast-fail + frees a runner slot sooner.

Acceptance: lint/type failures return in <1m; backend critical path unchanged or shorter.