---
id: 01KY72ZBQ57CZF0EBK84KC4R2T
created: 2026-07-23T08:55:17.4777Z
updated: 2026-07-23T11:00:29.6287Z
type: task
title: Squash unpushed vault history when a note is encrypted
number: 330
imported_from: null
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
label: null
---
## Problem

Encrypting a note removes the plaintext from the working tree, but git-sync has usually already committed the plaintext (debounce is ~4s). If that plaintext trips GitHub push protection, the push stays blocked even after encryption — protection scans every commit being pushed, not just the tip (GH013, see DEV-940).

This has now bitten twice for real (2026-07-11 and 2026-07-14, different machines). Both times the manual fix was the same: quit the app, `git fetch`, `git reset --soft origin/main`, recommit, push — i.e. squash the unpushed commits so no outgoing commit carries the plaintext. The GitHub unblock-URL path (option A) proved unreliable (404s), so the squash is effectively the only working remedy.

## Proposal

When a note's body is encrypted, and the vault's local history contains **unpushed** commits touching that note, automatically squash the unpushed range into a single commit of the current state before the next push. The plaintext version then never leaves the machine.

Sketched in the DEV-940 PR (#267) as "worth considering later":

* Only ever rewrite commits that are strictly ahead of the remote tracking ref (`git reset --soft` to the remote head + recommit — same as the manual fix). Never touch pushed history.
* If local and remote have diverged, do nothing and leave the existing GH013 diagnosis in the sync status — a merge under the user is worse than the status quo.
* Must be safe against the sync worker committing concurrently (this runs *inside* the sync loop, holding whatever serialisation sync already has).
* Consider the same squash on the headless sidecar (`--git-sync` / `--sync-only`), which shares the sync worker.

## Design questions

* Trigger: on encrypt (app-side event) vs. detected at push time (sync worker notices an encrypted note whose plaintext is in the unpushed range). Push-time detection also covers plain edits that remove a secret without encrypting.
* Whether to squash unconditionally on encrypt (simple, loses granular local history for that window) or only when a push has actually been rejected with GH013 (reactive, but self-healing).
* Should the user be alerted to the sync error and affected note to prompt them to encrypt it.

## Acceptance

* Encrypting a note whose plaintext was committed-but-unpushed results in a successful subsequent push with no plaintext in any pushed commit, with no manual git surgery.
* Diverged-history and already-pushed-plaintext cases degrade to the current DEV-940 diagnosis rather than attempting a rewrite.
* Covered by gitsync tests (local-only repos, as in the existing suite).

---

Linear DEV-983 · created 2026-07-14 · done 2026-07-14