---
id: 01M0HT09DNZHZZP6J0NTK6Q89G
created: 2026-08-21T09:21:33.109464Z
updated: 2026-08-21T19:37:23.542276Z
type: task
title: Auto-rerun known infra-flake signatures
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 330
sprint: sspwpgk
comments:
- id: 01M0JX7XTPGF8SQ0FK83PVJ65N
  author: Steve Vine
  at: 2026-08-21T19:37:23.542137Z
  text: |-
    Done — PR #320, squash-merged to main 2026-08-21.

    A `workflow_run` workflow that reruns a failed CI run once, but only when EVERY failed job's log matches an infrastructure signature.

    The design constraint worth stating: a rerun re-executes the jobs, so a wrong guess cannot turn a broken PR green — it fails again. The only thing at risk from over-matching is a few minutes of runner time, which is what lets the signature list be broad. Every signature in it is a transport failure (EAI_AGAIN, no such host, "Try again", "Resource temporarily unavailable", 502/503/504, TLS handshake timeout, "Failed to download action"); none can be produced by application logic being wrong.

    What it must not do is retry forever or paper over a flaky test, so: one attempt only (gated on run_attempt == 1); EVERY failed job must match, so a single ordinary test failure stops the rerun and a flaky test stays visibly red — that is a bug to fix, not to retry; staging is excluded, because a failed deploy deserves a human rather than a retry against a half-upgraded release; and a log that cannot be read counts as a real failure, not a clean one. Each run writes a job-summary table of every failed job, its verdict, and the signature that decided it, so the decision is auditable rather than magic.

    Written against the REST API through actions/github-script rather than the gh CLI: the runner image has no gh, and adding one for this would undo part of what COM-327 just bought.

    Note workflow_run only fires for the copy of a workflow on the DEFAULT BRANCH, so this did nothing on its own PR — its first real exercise is the first infra flake after this merge.

    Sprint context that sharpens the case: the six flakes on 2026-08-20 were the motivation, and three more happened during this sprint while the causes were being fixed. Every one would have been caught by this.
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Six flakes on 2026-08-20 each cost a manual rerun and 15–25 min of wall clock. Add a small workflow (workflow_run on failure) that greps the failed job's log for the known signatures — setup-uv "fetch failed", `EAI_AGAIN`, zot 502, codeload timeout — and retriggers failed jobs once (with a rerun cap). Cheap insurance while COM-327/328/329 remove the causes.