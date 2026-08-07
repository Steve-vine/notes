---
id: 01KYAN36KWNQ2J5J6FN5AW227X
created: 2026-07-24T18:09:40.988587Z
updated: 2026-08-07T10:07:01.706804Z
type: task
title: Kind Dictionary RBAC failures are invisible in the UI
project: 01KX671DATY39VW6GWK3M2T3DN
number: 262
sprint: s5khymf
comments:
- id: 01KYASA2AYDTJX22VEH6QTSC3K
  author: Steve Vine
  at: 2026-07-24T19:23:20.286403Z
  text: |-
    Work complete; moved to Review. Branch `feature/ise-262-kind-dictionary-rbac-surfacing` pushed to origin. (PR creation is blocked by a transient GitHub API incident — I'll link the PR here once it recovers.)

    Both gaps closed:
    1. Save-time: "Add kind" now ALWAYS probes first (the same cluster-scoped `list` discovery uses — probe_kind was already correct, the flow just didn't run it on save). A save the credential can't list isn't blocked — it saves and is loudly flagged (inline probe result + persistent toast with the exact 403), so RBAC provisioned ahead of time still works but nothing is added blind.
    2. Ongoing: new GET `/systems/{id}/kind-dictionary/status` probes each custom entry live; the panel shows a saved-but-unlistable entry with an "unavailable" badge + the 403 in a tooltip, clearing on its own once the probe next succeeds. Admin (reveals read credential); built-ins omitted.

    Sync behaviour unchanged (acceptance c). Tests: status availability/clears/empty (API), Add-auto-probes + unavailable-badge (card). OpenAPI + types regenerated; all gates green (BE ruff/format/mypy/pytest, FE build/eslint/prettier/vitest).
- id: 01KYAVSFBZFVWD7K92XBJV38VA
  author: Steve Vine
  at: 2026-07-24T20:06:42.303007Z
  text: 'PR now open: #243 → main (https://github.com/Steve-vine/ise/pull/243). GitHub API recovered. Already released to staging (CI green).'
assignee: steve
priority: medium
task_status: done
---
Found live on env-staging-us (2026-07-24): the Rollout preset was enabled, but the cluster's `ise` ServiceAccount lacks `list` on `rollouts.argoproj.io` — discovery 403s every sync and mints nothing. The operator saw **no signal anywhere**: saving the dictionary entry produced no warning, and the integration page shows no degradation. The only evidence was a WARNING in the worker logs (`kubernetes discovery: custom kind argoproj.io/v1alpha1/Rollout unavailable: (403) Forbidden`) — "silent empty discovery" is exactly the failure mode ISE-258/257 specified against.

Two gaps to investigate and close:

1. **Save-time validation (ISE-258 spec, not working):** the editor was to probe the cluster on save — CRD exists? listable with current RBAC? — and surface the result inline. Either the probe wasn't implemented, or it checks the wrong thing (e.g. `get` on the CRD definition vs `list` on the resources at cluster scope — the discovery path does a cluster-scoped `list`, so the probe must match that verb+scope exactly).

2. **Ongoing degradation surfacing (ISE-257 spec, not working):** a dictionary entry whose kind is unavailable should surface per-integration per the ADR 0031 capability-degradation pattern — e.g. an entry-level status on the Kind Dictionary panel ("Rollout — unavailable: RBAC forbidden since 17:49") and/or the integration health surface — not just a log line. The connector already detects and logs the condition, so this is plumbing the existing signal to the screen, both at first failure and at recovery (warning clears when the 403 stops).

Acceptance: with a dictionary entry the credential cannot list — (a) saving it shows the RBAC failure inline with the exact missing permission; (b) the integration page shows the degraded entry with the reason while the condition persists, and clears when RBAC is fixed; (c) worker log behaviour unchanged (sync still succeeds).