---
id: 01M1FEWD3H51JM1XQAMS57AFDZ
created: 2026-09-01T21:44:24.433703Z
updated: 2026-09-04T16:51:08.303015Z
type: task
title: 'The Differ: change detection leaves the sync path'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 763
sprint: s7nj09w
comments:
- id: 01M1J6RFSPFRK0MYVPBR2NZ6YA
  author: Steve Vine
  at: 2026-09-02T23:20:10.806829Z
  text: |-
    Built — PR #707 (feature/ise-763-differ), migration 0147. ISE-765 (#705) and ISE-762 (#706) are merged to main.

    THE LINE, AS THE BRIEF DREW IT
    `reconcile_findings` did five jobs; it now does three. Identity, the field write and the tag half stay in the integration — transcription of what the source said. Transitions (C) and recovery (E) are the Differ's.

    ABSENCE WITHOUT A BATCH
    A complete ingest stamps `signal_sweep` for its `(system, signal_type)`; the Differ reads absence as staleness against it. Three properties, each of which is a way this could have gone wrong and each of which has a test:
    1. **A partial pass must not stamp.** The stamp is written INSIDE the ingest transaction, so a failed pass rolls it back with everything else.
    2. **A source that never stamps is never swept.** Status pages, webhooks and servers compute their own recovery and never call `reconcile_findings` — they claim to have reported nothing, so the Differ leaves them alone. Absence is only observable where somebody claims to have reported everything. Without this the Differ would have closed every status-page incident the provider is still reporting.
    3. **Mass-recovery guard** — a `logger.warning` (so a Platform Log row, user-visible) rather than a refusal. Unlike retirement, recovery is reversible: the next pass that reports the signals re-opens them, so refusing would trade a reversible wrong answer for an incident queue that never clears.

    DELIBERATE DEVIATION FROM THE BRIEF
    The brief says recovery compares `last_seen_at` against the stamp. It cannot: `last_seen_at` is the SOURCE's account of when the thing last happened, and a connector reporting a monitor's last TRANSITION time would look absent while still firing — recovered, confidently, on every tick. Added `finding.last_reported_at`, written by ingest with the pass's own clock, and compared against that. Same intent, one field safer.

    DRIFT MOVED IN, WITH A SCOPE IT NEEDED
    `drift` is now the Differ's. It required extending the sweep scope with an optional KIND: the Obs Loop stamps `(system, observation)` and its detector pass genuinely does not report drift — it never claimed to — so without a kind-scoped stamp the type-wide one would recover every drift observation on every run. The rule is now **a kind with its own stamp is swept only by that stamp**.

    A BUG THE MOVE CREATED AND THE TESTS CAUGHT
    Moving the drift WRITE without the LINK left every drift observation with `entity_id = NULL` — on the Observations screen and on no entity at all, the ISE-639 shape. The Differ now links what it writes.

    CADENCE
    A completed ingest wakes a pass for its own system in a FRESH transaction (that is what takes change detection out of the sync transaction — a poisoned ingest can no longer take it down), and the Conductor's per-minute `dispatch-differ` tick is the backstop. The wake is a direct call rather than a Celery hop: this is a bounded query over one system's signals, and a hop would add a dropped-enqueue failure the backstop has to cover anyway.

    MIGRATION 0147 — THE BACKFILL IS THE LOAD-BEARING HALF
    `differ_status` ← the row's current `status`, `last_reported_at` ← `last_seen_at`. Left NULL, the FIRST Differ pass would read every live signal as changed and push the lot — an audit row each and a notification for whatever it decided had just re-triggered. Backfilled, the first pass finds nothing changed, which is the truth. `transition` stays NULL: ISE has no record of what the last one was and inventing one is worse than the gap. There is a populated migration test.

    Six existing tests changed semantics honestly (promotion is now reached through the Differ's wake; drift reads `result["differ"]["drift"]`; the estate System's observations recover on a Differ pass, which in production is the backstop tick).
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
Build the Differ per ADR 0107 and the boundary spec.

Transition detection moves out of `sync.reconcile_findings` and out of the sync transaction, joining the estate-diff work that `drift` does today. The Differ reads the Signal Store and the Estate, detects change, writes transitions back to the signal, and pushes **only what changed** to the Correlator.

**The behaviour that matters:** a signal still firing in the same way produces nothing new upward. That is the mechanism that ends the repeated surfacing of unimportant things — the other half is the Correlator's importance judgement.

Runs per-minute, paced by the Conductor. Affordable because it makes no network calls — unlike today's Obs Loop, which defaults to 86,400s precisely because it dials out.

**Headless.** No user-facing surface of its own.

**Blocked by** the Differ / Correlator boundary spec.