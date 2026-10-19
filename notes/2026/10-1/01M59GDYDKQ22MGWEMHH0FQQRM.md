---
id: 01M59GDYDKQ22MGWEMHH0FQQRM
created: 2026-10-19T07:18:48.499981Z
updated: 2026-10-19T18:09:32.087931Z
type: task
title: A PR whose code has already passed CI exactly as it stands goes green at once, so a stacked task merges minutes after its parent instead of after another full run
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1105
sprint: sjlj05e
comments:
- id: 01M59RQ4E0C3MKSP7T6CAW747D
  author: Steve Vine
  at: 2026-10-19T09:43:38.176476Z
  text: |-
    Merged in PR #1100 (2026-10-19).
    - The changes job lists this PR's ci-pass-v1-<tree>-* cache keys (scripts/ci/already-passed.py) and skips backend-static, backend-unit, backend-test, frontend, sast and chart where the exact tree already passed. Each of those jobs records its pass as its last step (.github/actions/record-pass).
    - deps-scan, secret-scan and migrations always run.
    - A failed lookup runs everything.
    - ADR 0041 has the amendment "a pass for an identical tree stands", including the accepted limits: whole-tree key, runner image outside the tree, eviction means a full run.

    Proven on the PR itself:
    - Run 1 recorded all six passes.
    - An empty commit (same tree, new SHA, same PR ref, which is the restack case) skipped all six.
    - The whole run took 2 min 4 s, against ~25 min for a full run.

    Still open from "done when": the next module sprint's stack shows the saving.
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Sprint 77, CI / Build optimisation. Raised 2026-10-19 from the review of sprint 77's tasks. Start after sprint 76 is on staging.

## Why

Every task in the Attestations stack (COM-1093..1102) ran PR CI twice. The second run, after restacking onto the just-merged parent, tested a tree **byte-identical** to the one that had already passed — 10 of 10 tasks (checked with `git rev-parse <head>^{tree}` across the two runs of each branch). The same holds for the Software discovery stack (COM-964..968).

That second run is the serial part of a sprint: each task waits ~25–35 minutes for it after its parent merges. Over a 10-task stack, that's about 5 hours spent re-proving code that is already proven.

## What changes

- When a PR's code is exactly what an earlier green run tested, each test job reports green straight away and says why ("this exact code passed in run N").
- Anything different — one changed file, a different base that brings in other merges, a changed workflow — runs the full suite as today.
- The PR stays the only gate (ADR 0041). Its meaning becomes "this exact code has passed every check", and the record of which run proved it is in the job summary.
- The push-to-main backstop is unchanged and still catches the combined-state cases.
- Add an amendment to ADR 0041 saying a green result for an identical tree stands.

## Notes (technical)

- Key: the tree hash of the code under test — the `refs/pull/N/merge` commit's `^{tree}` — so the key covers the workflow and `scripts/ci/` too. A per-job subtree key (e.g. `HEAD:app/backend` + workflow + scripts) would also skip backend jobs on frontend-only follow-ups. Decide whichever is simpler to prove safe; the whole-tree key is the conservative choice.
- Store: a lookup-only `actions/cache` entry `pass-<job>-<tree>` written as the last step of a green job; restore with `lookup-only: true` at the start, and skip the remaining steps on a hit. Cache entries don't count against the Actions artifact storage quota (memory: release blocked by Actions storage quota), but check before relying on that.
- Applies to backend-static, backend-unit, backend-test, frontend, deps-scan, sast, chart, migrations. secret-scan always runs (it's cheap, and it scans commit history, not the tree).
- `deps-scan` checks advisories that change over time even when the tree doesn't. Either leave it out of the skip or let it hit only within 24h — say which in the PR.
- Must not interact with `auto-rerun.yml` (a skipped-by-cache job is green, never failed) or the `changes` fail-safe (COM-202).
- Prove it on a throwaway two-PR stack: the child's restack run must short-circuit, and a one-line change to the child must run in full.

**Done when:** a restacked child whose tree is unchanged goes green in under 2 minutes; any tree change runs everything; the job summary names the run that proved it; ADR 0041 carries the amendment; the next module sprint's stack shows the saving.