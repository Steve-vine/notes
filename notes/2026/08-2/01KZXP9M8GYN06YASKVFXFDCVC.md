---
id: 01KZXP9M8GYN06YASKVFXFDCVC
created: 2026-08-13T13:51:56.176724Z
updated: 2026-08-13T20:41:31.825618Z
type: task
title: A host-shaped native key must join case-insensitively — DataDog's MPWXDataWH never meets the register's mpwxdatawh
project: 01KX671DATY39VW6GWK3M2T3DN
number: 690
sprint: sevhjex
comments:
- id: 01KZYDQKEZVQCDD3JSDB1TXGZR
  author: Steve Vine
  at: 2026-08-13T20:41:31.359587Z
  text: |-
    2026-08-13 — DONE, PR #642 merged to main (migration 0133).

    **Host-shaped only, as scoped.** `native_keys.py` holds the one rule: `datadog:host:`, `dns:`, `k8s:node:` fold; everything else keeps exact-match semantics. A test pins the boundary with `datadog:service:CHECKOUT` failing to match `datadog:service:checkout` — deliberately, because folding an `entra:` GUID or a scoped k8s key (whose namespace and object name ARE case-sensitive in Kubernetes) would silently merge things that are genuinely distinct. That is a worse failure than the one being fixed and an invisible one.

    **Folded at both ends, as required.**
    - *Lookup*: `_resolve_alias_keys` runs two queries — exact for everything, plus `lower(native_key)` for host-shaped keys — and merges them.
    - *Mint*: this turned out bigger than the task's line reference suggested. `cross_keys_for` builds a set of names and emits three keys per name, and only SOME of the names arrived folded — `fqdn()` and the reported identity did; `server.hostname` itself and its short form did not. Folding the single point of emission covers all of them and also collapses case variants into one key, which is what keeps the "no duplicate keys" invariant intact.

    **Exact wins over folded** on a collision, with a test. If two aliases differ only in case, the one matching character-for-character is the better answer; quietly preferring the other is precisely the wrong-but-plausible binding this join must not invent.

    **Migration 0133** indexes `lower(native_key)`. Two things worth recording:
    1. A functional index **must also be declared on the model**. I reasoned it should be migration-only (assuming Alembic cannot reflect expression indexes) — wrong. It reflects them as a textual index element, so a migration-only index is reported as `remove_index` and `test_migrate_zero_to_head_and_models_match` fails. Caught by running that one test locally in ~7s rather than discovering it on an 11-minute CI run.
    2. Not unique, deliberately — two aliases may legitimately differ only in case, and the join resolves that by preferring the exact match.

    **No backfill migration.** `link_findings_to_entities` re-links every unpinned finding on each sync regardless of its current `entity_id`, so IN-1224 and the two uppercase keys already waiting (`MPUSASQLDS`, `MPWXHVHOST8`) resolve on the next pass with nobody touching them. IN-1224's manual attach is pinned, so the fixed join will not fight it — the `entity_pinned_by IS NULL` filter excludes it.

    Verified: 6 new tests; the full `test_signal_entity_join` (20), `test_servers_register` (25), `test_discovery`, `test_unknown_assets`, `test_servers_coverage` suites green; ruff, mypy strict green; PR CI green (backend 8m45s).
assignee: steve
label:
- bug
priority: high
task_status: review
tech: null
---
IN-1224 reports "the signal names `datadog:host:MPWXDataWH`, which matches nothing in the estate" while the host is registered and carries nine aliases — including `datadog:host:mpwxdatawh`. The two differ only in case.

**Cause.** `discovery.link_findings_to_entities` joins on `EntityAlias.native_key.in_(keys)` (`discovery.py:598`) — plain SQL equality, case-sensitive in Postgres. The register lowercases what it publishes: `fqdn()` folds host and domain (`servers.py:255-256`) and `cross_keys_for` folds the reported identity hostname (`servers.py:445`). DataDog takes its key straight from the monitor's `host:` tag (`datadog.py:428`) with the machine's own casing. Hostnames are case-insensitive by definition — DNS, NetBIOS and Windows all treat them so — and ISE is the only party in the chain that does not.

That the current binding worked at all is luck: registering the machine as `MPWXDataWH` would have produced a matching key via the un-lowercased `server.hostname` branch.

**Measured on staging 2026-08-13** (`finding` rows with a `datadog:host:` key and no entity): 14 distinct keys unbound, 2 bound. Case-folding fixes **1** of the 14 — `MPWXDataWH`, 3 findings. The other 13 have no alias even case-folded, because those hosts are simply not registered yet; that is fleet coverage, not this bug. But two more uppercase keys are already waiting — `MPUSASQLDS` and `MPWXHVHOST8` — and each will hit this the moment its server is registered. The defect grows with the Windows fleet, so fix it before the fleet lands rather than after.

**Scope**
- Case-insensitive matching for **host-shaped keys only**: `datadog:host:`, `dns:`, `k8s:node:`. All three name DNS hostnames, where case-folding is correct by RFC. Do **not** blanket-fold every native key — `entra:` GUIDs, scoped k8s workload keys and `datadog:service:` are not hostnames and must keep their exact-match semantics.
- Fold at BOTH ends — mint and lookup — so a stored mixed-case alias and a mixed-case incoming key both resolve. Folding only at lookup leaves aliases minted by other connectors unmatched from the other direction.
- Keep the lookup indexed. `in_()` over `lower(native_key)` needs a functional index on `entity_alias`, or a stored normalised column; a sequential scan here runs on every sync.
- Backfill: re-link existing unbound findings once the join is fixed, so IN-1224 and its two siblings resolve without a human touching them. The ADR 0073 §4 unknown-asset back-fill is the existing mechanism.
- Test with a real mixed-case pair end to end — register `Host-01`, ingest a `datadog:host:HOST-01` finding, assert it binds. A test that only exercises lowercase proves nothing here.

Related: ISE-691 (no way to correct a wrong attachment). The manual attach on the finding is the interim repair for IN-1224 — pinned, so the fixed join will not fight it.