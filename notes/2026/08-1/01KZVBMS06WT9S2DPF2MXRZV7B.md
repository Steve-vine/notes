---
id: 01KZVBMS06WT9S2DPF2MXRZV7B
created: 2026-08-12T16:07:18.278296Z
updated: 2026-08-12T16:08:15.838139Z
type: task
title: Subfinder live progress via -v stderr parsing
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 127
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- follow_up
- feature
priority: low
task_status: backlog
---
## Context

Brief 014 attempted to add a live progress counter for subfinder via streaming `Popen` (and a follow-up PTY-based design correction). Both failed — empirical investigation showed subfinder buffers `-oJ` JSONL output **internally at the application level**, regardless of any client-side technique. See:

* `docs/briefs/014-subfinder-progress-streaming.md` (Final correction section)
* `docs/sessions/014-subfinder-progress-streaming.md` (closeout, including diagnostic evidence)
* `docs/architectural-standards.md` § "Scanner Runner Output Streaming"

The honest UX shipped is a "Working…" spinner during the run, asset count at completion. No live counter.

## What works that we didn't use

Subfinder's **stderr** under `-v` (verbose mode) **does** stream live. Per-source events, per-discovery events, and progress signals all arrive incrementally throughout the run. Specifically, the `[<source>] <subdomain>` lines on stderr fire as each subdomain is discovered.

This is the only viable path to a live counter for subfinder. Cost: \~80–120 LOC of stderr parsing + tests + dropping `-silent` (which conflicts with `-v`).

## Approach (if revisited)

1. Drop `-silent`, add `-v -no-color` to the subfinder invocation.
2. Parse stderr lines matching `^\[<source>\] <subdomain>$` (after stripping ANSI codes — `-no-color` should suppress them but verify).
3. Track unique subdomain count across stderr matches.
4. Emit `progress(current=count, total=null, phase="enumerating")` on each match.
5. Asset emits to dispatcher still happen at the end (subfinder's stdout JSONL is still buffered) — only the `progress.current` count is live.
6. New test fixture: capture real `-v` stderr from a subfinder run and replay it to the parser.

## Why deferred

The buffering finding from Brief 014 is a UX limitation, not a functional bug. "Working…" with a spinner is a defensible UX for a 30s scan step. Adding a live counter is nice-to-have. Cost-benefit doesn't justify the parser complexity right now.

Reopen when:

* A user explicitly complains about the lack of progress feedback for subfinder
* DEV-167 lands API-keyed sources, making subfinder runs longer (more sources = more time = more justification for a live counter)
* We need the same parser for a different reason (e.g. per-source cost/quality analysis from `[<source>]` attribution)

## Out of scope

* Per-source attribution (skipped/failed/produced-results events). The original DEV-168 framing wanted this; Brief 014 deferred it because the silent-success gap meant the bar would freeze short of 100%. Same caveat applies if revisited.
* Replacing subfinder with a different enumeration tool.
* Patching subfinder upstream to flush per result.

---

Imported from Linear [DEV-170](https://linear.app/stevevine/issue/DEV-170/subfinder-live-progress-via-v-stderr-parsing) · parent DEV-168