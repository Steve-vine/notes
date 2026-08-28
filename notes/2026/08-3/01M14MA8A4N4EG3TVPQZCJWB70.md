---
id: 01M14MA8A4N4EG3TVPQZCJWB70
created: 2026-08-28T16:47:42.404123Z
updated: 2026-08-28T20:48:34.636573Z
type: task
title: Actor enrichment kills the whole sync on COM-453's new kinds
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 485
sprint: snq23hz
comments:
- id: 01M14WYVVKH3AGVPP1K0PJNKRP
  author: Steve Vine
  at: 2026-08-28T19:18:46.387502Z
  text: |-
    Done — merged to main as ab3ac3b (PR #481). Full CI green.

    **Two fixes.** `_AUDIT_ACTIVITIES` gains COM-453's three kinds, and the lookup becomes a function with a floor rather than a bare subscript, so the next kind somebody adds degrades to "unattributed" instead of raising. The activity strings are best-effort and worth checking against the tenant's own log — a wrong one is survivable in a way the missing key was not, because it just leaves the item unattributed.

    **And enrichment can no longer fail the pass at all**, which is the one that matters. ADR 0045's COM-390 amendment says it is best-effort and never load-bearing, and calls it after the mirror is banked for that reason. Ordering achieved half of it: the data survived, but an exception still failed the task and showed an errored sync over a mirror that had updated perfectly.

    **Worth knowing about the test, because it went wrong twice in ways that would have shipped a false green.**

    The first draft created a role item and asserted the sync succeeded — and passed against the broken code. The fake tenant had no audit records, so the match loop never ran and the lookup was never reached. Adding a real `Add member to role` record fixed that, plus assertions that enrichment actually queried for the account.

    It then *still* passed — because the wrapper was correctly swallowing the KeyError, which meant the map half was untested. So the two properties are now pinned by separate assertions: the item is **attributed to Ada Lovelace** (fails if the map is wrong, wrapper or no wrapper), and the pass is clean with `last_error` null (verified by making `enrich_actors` raise outright).

    Both confirmed failing against their respective broken states. That double-check is the only reason this is actually covered.
assignee: steve
company:
- moneypenny
label:
- bug
priority: urgent
task_status: done
---
Defect in COM-453, live on staging (`staging-20260828-1640`). **The directory sync now fails on every pass.**

```
Directory mirror sync failed
Task ...sync_directory raised unexpected: KeyError(<UnrequestedChangeKind.directory_role_gained>)
  File ".../directory_sync.py", line 2096, in _best_audit_match
    if activity not in _AUDIT_ACTIVITIES[item.kind]:
KeyError: <UnrequestedChangeKind.directory_role_gained: 'directory_role_gained'>
```

## Why

`_AUDIT_ACTIVITIES` maps an item kind to the Entra audit activity names that could explain it (COM-390). COM-453 added three kinds — `unprocessed_leaver`, `directory_role_gained`, `directory_role_lost` — and **never extended the map**. The moment enrichment reaches an item of a new kind it raises `KeyError`, and the exception propagates out of `enrich_actors` → `_run_delta_pass` → `sync_directory`.

Two lookup sites: `_item_matches` (line ~2008) and `_best_audit_match` (line ~2096).

No test covered enrichment over an item of a new kind, which is why CI was green.

## Two bugs, and the second is the more important one

**1. The map is incomplete.** Needs the three new kinds with their real Entra activity names — `Add member to role` / `Add eligible member to role`, `Remove member from role` / `Remove eligible member from role`, and for a departure `Delete user` / `Hard Delete user` / `Update user` (a disable arrives as an update with a modified property). Worth checking the tenant's own audit log for the exact strings rather than trusting these from memory.

**2. Enrichment can fail the sync at all.** ADR 0045's COM-390 amendment is explicit: *"Best-effort, never load-bearing. Enrichment runs after the mirror pass is banked, so a second Graph endpoint can never put the mirror's correctness at risk."* Running it after the commit achieves half of that — the data survives — but an exception still fails the task, sets `last_error`, and marks the sync failed on the Admin card.

So `enrich_actors` must be wrapped: any failure inside it is logged and swallowed, and the pass still returns its counts. Adding map entries alone fixes today's symptom and leaves the stated property untrue.

Also make the lookup itself defensive (`_AUDIT_ACTIVITIES.get(item.kind, frozenset())`), so a future kind degrades to "no actor match" rather than an exception.

## Blast radius

The mirror **is** still being banked — the commit happens before enrichment — so no data is lost and the provenance backfill landed (16:45:13). But every pass reports failure, `last_error` stays set, the Integrations card shows an errored sync, and **actor enrichment is entirely dead**: it dies on the first new-kind item and never reaches the rest.

Self-healing: no. The offending item persists, so every pass hits it again.

## Tests

- `enrich_actors` over an item of each new kind does not raise, and the pass returns its counts.
- A deliberately unmapped kind degrades to no match rather than an exception.
- A raising `enrich_actors` does not fail `sync_directory` and does not set `last_error` — the ADR 0045 COM-390 property, asserted rather than assumed.
- The existing COM-390 correlation tests keep passing untouched.
