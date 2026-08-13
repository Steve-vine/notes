---
id: 01KZXJAYMWCC0B8WZZE3HBZM2X
created: 2026-08-13T12:42:45.276685Z
updated: 2026-08-13T12:42:45.276685Z
type: task
title: The Kubernetes read credential reads everything, and only writes stay enumerated
assignee: steve
task_status: backlog
priority: high
label:
- improvement
- tech_debt
project: 01KX671DATY39VW6GWK3M2T3DN
number: 684
---
`ise-readonly` becomes a wildcard read grant — `apiGroups: ["*"], resources: ["*"], verbs: [get, list, watch]` — replacing the hand-curated allowlist in `~/code/scripts/create-ise-clusterrole.sh`. `ise-readwrite` is NOT widened: writes stay an explicit enumeration of the connector's action catalogue.

**Why.** The allowlist was agreed 2026-07-24 on the reasoning that "RBAC has no deny rules, so an allowlist is the only way to keep the grant enumerable". That bought enumerability, not confidentiality — and ISE-517 then granted `get/list` on every Secret in the cluster, which is the most sensitive read available. Once Secrets are in, the marginal exposure of ingresses, jobs and PVCs is close to nil.

What it cost instead was a permanent whack-a-mole. The Kind Dictionary (ADR 0046) is runtime config — an operator adopts a CRD in the UI, one click from a preset or from the ISE-513 served-kinds gap check. RBAC is out-of-band provisioning: a bash script, run by hand, per cluster, needing cluster-admin. Two different clocks, so every new dictionary entry is a guaranteed 403. The script's own header states the loop: *"add a rule here when enabling a new preset in ISE."* The operators holding these clusters already have far broader access than the role grants; a role that keeps saying no pushes the work outside ISE, which is the opposite of a single pane of glass.

**Do NOT bind the built-in `view` role instead.** Checked on g5: `view` aggregates `batch`, `networking.k8s.io`, `metrics.k8s.io`, `cert-manager.io` — but *not* `argoproj.io` or `external-secrets.io`, because those operators ship no `aggregate-to-view` labels. The two CRD groups ISE actually uses are absent from it. `view` would fix the metrics gap and nothing else.

**Scope**
- Rewrite the `ise-readonly` ClusterRole in `create-ise-clusterrole.sh` as the wildcard rule; keep `pods/log` explicit if the wildcard does not cover subresources (verify against a live cluster — it does not).
- Leave `ise-readwrite` exactly as it is, and keep the ro-run downgrade path that deletes it.
- Rewrite the script's header policy block: it currently states the allowlist stance and its 2026-08-04 Secrets amendment as standing policy.
- ADR 0100 recording the reversal — per the repo's hard rules this is an architecture decision and the current stance lives only in a shell comment, so this is a new ADR, not an amendment.
- Re-run the script against every integrated cluster; the change is inert until it is applied.

**Known gaps this closes** (verified live against `system:serviceaccount:ise-integration:ise` on g5): `metrics.k8s.io` (the `pod_resource_usage` evidence query calls it and is denied today, while metrics-server is installed and Available), plus every future CRD group. It also makes the currently-granted-but-unread `secretstores`/`clustersecretstores` rules moot.

Headless by nature — no screen. The user-facing half of this sprint is the 403 message task.