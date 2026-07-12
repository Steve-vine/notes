---
id: 01KXC3NKDCAECJVN5ANFMBAV0T
created: 2026-07-12T21:27:56.588604026Z
updated: 2026-07-12T21:59:14.250167396Z
type: task
title: Protected-targets guard is inert — default_policy() is never called
task_status: done
assignee: steve
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 54
sprint: sdcd2jr
---
Found while provisioning the g5 write kubeconfig (ISE-46 follow-up).

ADR 0021 says protected_targets are "seeded on every new system" — kube-system, ise, arc-runners, cnpg-system. **They are not.** `risk.default_policy()` exists but NOTHING calls it. Every System row has `risk_policy = {}`, and `check_target_allowed` returns early when the deny-list is empty.

So the blast-radius guard — the one ADR 0021 says "an approver cannot click past" — **does not fire at all today, on any system.** Default-deny still forces approval for every change, but an approver could approve a delete against kube-system and nothing in ISE would stop it. (RBAC would, now that the write principal is namespace-scoped to ise-acceptance — but RBAC is the second line, not the first, and the read-only cluster-wide principal proves the two can diverge.)

Also a plain factual error: the seeded list says `cnpg-system`, but the namespace on g5 is actually **`cnpg`**. So the entry meant to protect ISE's own database protects a namespace that does not exist.

BLOCKS ISE-53's T3 safety leg, which requires proving "protected_targets REFUSES a delete against a protected namespace even when approved". That acceptance criterion cannot pass as the code stands.

Fix:
1. Make `protected_targets(policy)` fall back to DEFAULT_PROTECTED_TARGETS when the policy does not declare the key — fail-safe, not fail-open. An explicit `"protected_targets": []` remains a deliberate opt-out.
2. Correct the default list against the real estate: kube-system, ise, arc-runners, arc-systems, cnpg, traefik, zot, cert-manager, metallb-system — and **compass**, a different product on the same cluster that ISE has no business touching.
3. Test that a system with an empty/absent policy still refuses a protected target.

Workaround until then: set `risk_policy.protected_targets` explicitly on the g5 system (it is admin-configurable), which makes the guard fire without a code change.