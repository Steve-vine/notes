---
id: 01KZXJAYMWCC0B8WZZE3HBZM2X
created: 2026-08-13T12:42:45.276685Z
updated: 2026-08-13T18:59:38.188717Z
type: task
title: The Kubernetes read credential reads everything, and only writes stay enumerated
project: 01KX671DATY39VW6GWK3M2T3DN
number: 684
sprint: sevhjex
comments:
- id: 01KZXKAK0H5G37NK6DQNYS8VX8
  author: Steve Vine
  at: 2026-08-13T13:00:01.937873Z
  text: |-
    2026-08-13 — code and docs DONE; the per-cluster re-run is outstanding, so this is not closable yet.

    Landed:
    - ADR 0100 (docs/decisions/0100-the-kubernetes-read-credential-reads-everything.md) + README row — PR #634, merged to main as c0e7102. Docs-only, so the code CI jobs path-skipped; changes + secret-scan green.
    - create-ise-clusterrole.sh — commit ef80d12 in ~/code/scripts (separate repo, outside the ISE pipeline). ise-readonly is now apiGroups/resources ["*"] with get/list/watch, plus pods/log named explicitly: a resources wildcard matches resources, NOT subresources, so dropping it would silently re-break the pod_logs evidence query. ise-readwrite untouched; the -type ro downgrade path untouched. Validated with kubectl apply --dry-run=client.

    OUTSTANDING — the change is inert until the script is re-run per cluster, with cluster-admin, one run each. Every existing credential still holds the old narrow grant, so until then: custom-kind adoption still 403s, and pod_resource_usage still fails on metrics.k8s.io. Re-running is idempotent.

    Not done deliberately: the staging pointer was not pushed. This commit is docs-only — there is nothing in it to deploy, and pushing would rebuild images for a markdown file. main is exactly one commit ahead of staging as a result.

    Cross-reference: ISE-685 (the 403 → "install metrics-server" message) is still Backlog. Its wrong message will outlive this fix on any cluster not yet re-run — which is precisely the population most likely to hit it.
- id: 01KZY0SSDRY5Z1D0ZVP1Q356EZ
  author: Steve Vine
  at: 2026-08-13T16:55:31.511763Z
  text: |-
    2026-08-13 (later) — 1 of 7 clusters done and verified. **BLOCKED on the other 6** — needs Steve.

    **g5: applied and verified end to end.**
    ```
    ise-readonly rules:  ["*"] ["*"] [get list watch]
                         [""]  ["pods/log"] [get]
    ```
    Checked as `system:serviceaccount:ise-integration:ise`:
    - `list pods.metrics.k8s.io` → **yes** — the gap the task was written around is closed on g5; `pod_resource_usage` can now answer.
    - `get pods/log` → yes. The explicit subresource rule is load-bearing exactly as the script's comment says: a `resources: ["*"]` wildcard matches resources, not subresources.
    - `list rollouts.argoproj.io` → yes (an unserved group, so kubectl warns — but the authorisation is granted, which is the point: no future CRD adoption needs a cluster-admin).
    - `delete pods` → **no**; `patch deployments.apps` → yes. Writes are still the enumerated action catalogue, unwidened, as the ADR requires.

    **The remaining 6 are unreachable from this host.** env-production-uk-pri, env-production-us-pri, env-staging-uk, env-staging-us, mgnt-production-uk-pri, mgnt-staging-uk are all private EKS endpoints reached over Twingate, and Twingate is not running:

    ```
    twingate status  →  not-running
    ```

    `twingate start` needs an interactive sudo password ("sudo: A terminal is required to authenticate"), which I cannot supply. Symptom without it: the endpoint DNS resolves (intermittently — sometimes `Try again`, i.e. EAI_AGAIN) and then the TCP connect to :443 times out. Worth writing down because those two errors look like different faults and are the same one.

    **To finish this task, Steve:** start Twingate (`! twingate start` in the session, or from the desktop app), then the re-run is six commands — the script is idempotent and does NOT rotate the token, so no credential in ISE needs updating:

    ```
    for c in env-production-uk-pri env-production-us-pri env-staging-uk env-staging-us mgnt-production-uk-pri; do
      ~/code/scripts/create-ise-clusterrole.sh -type ro -kubeconfig ~/.kube/$c.yaml
    done
    ~/code/scripts/create-ise-clusterrole.sh -type rw -kubeconfig ~/.kube/mgnt-staging-uk.yaml
    ```

    **Note the `-type` per cluster — this matters.** An `ro` run DELETES the write role. From the staging DB, only `mgnt-staging-uk` has a `write_credential_ref` among the six (`mgnt-staging-uk-write`), so it must be `rw`; the other five are read-only and take `ro`. g5 is `rw` (`g5-write`) and is already done. Running the wrong type would silently revoke a working write grant.

    Until then, on those six: custom-kind adoption still 403s and `pod_resource_usage` still fails on `metrics.k8s.io` — it just now says so correctly, per ISE-685.
- id: 01KZY56MJDVVFF6YBKT1KGMVCC
  author: Steve Vine
  at: 2026-08-13T18:12:26.829549Z
  text: |-
    2026-08-13 — **CORRECTION to my previous comment. Do NOT re-run the script on the six clusters.** Steve is applying the change directly.

    Two things I had wrong. Twingate is not installed on this dev host at all — it runs only in pods — so "start Twingate and re-run" was never a route. And more usefully: **re-running the script is not what the change requires.**

    Walking `create-ise-clusterrole.sh -type ro` against a cluster ISE is already integrated with, six of its seven steps are no-ops:

    | step | effect on an already-provisioned cluster |
    |---|---|
    | `namespace ise-integration` | no-op, exists |
    | `serviceaccount ise` | no-op, exists |
    | **`clusterrole ise-readonly`** | **the entire change** |
    | `clusterrolebinding ise-readonly` | no-op, already bound to the same SA |
    | **`-type ro` branch** | **deletes the `ise-readwrite` role + binding** |
    | `secret ise-token` | no-op — same secret, token NOT rotated |
    | emit `/tmp/ise-<cluster>-ro.yaml` | no cluster change |

    So ISE-684 on each remaining cluster is one `kubectl apply` of the `ise-readonly` ClusterRole — cluster-scoped, idempotent, and live immediately because the binding already points at it:

    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata: { name: ise-readonly }
    rules:
      - apiGroups: ["*"]
        resources: ["*"]
        verbs: [get, list, watch]
      - apiGroups: [""]
        resources: [pods/log]
        verbs: [get]
    ```

    **Applying just the role is strictly safer than the script re-run**, and it retires the `-type` hazard my previous comment spent a paragraph warning about. `mgnt-staging-uk` is the one of the six carrying a `write_credential_ref`; an `ro` run there would have silently stripped its write grant. With the bare apply there is nothing to get wrong, and no kubeconfig carrying a never-expiring token gets written into `/tmp` six times for a change that touches one RBAC object.

    Remaining: env-production-uk-pri, env-production-us-pri, env-staging-uk, env-staging-us, mgnt-production-uk-pri, mgnt-staging-uk. (g5 is done and verified.)

    **Verification per cluster**, as `system:serviceaccount:ise-integration:ise` — the first is the gap this task was written around, the last two prove writes were not widened:

    ```
    kubectl auth can-i list pods.metrics.k8s.io --as=system:serviceaccount:ise-integration:ise   # expect yes
    kubectl auth can-i get  pods/log            --as=system:serviceaccount:ise-integration:ise   # expect yes
    kubectl auth can-i delete pods              --as=system:serviceaccount:ise-integration:ise   # expect NO
    kubectl auth can-i patch deployments.apps   --as=system:serviceaccount:ise-integration:ise   # yes only on mgnt-staging-uk
    ```

    `pods/log` is worth actually checking rather than assuming: a `resources: ["*"]` wildcard matches resources, **not** subresources, which is why that second rule exists at all.

    Follow-up worth raising separately: give `create-ise-clusterrole.sh` a role-only mode, so the next RBAC change is not a full re-provision.
- id: 01KZY7X08461M2147MQXR6ZYKS
  author: Steve Vine
  at: 2026-08-13T18:59:36.836126Z
  text: |-
    2026-08-13 — **COMPLETE.** Steve applied and verified the `ise-readonly` ClusterRole on the remaining six clusters (env-production-uk-pri, env-production-us-pri, env-staging-uk, env-staging-us, mgnt-production-uk-pri, mgnt-staging-uk). With g5 already done, all 7 integrated clusters now carry the wildcard read grant.

    The task is closed on all five scope items:

    - `ise-readonly` rewritten as the wildcard rule, `pods/log` kept explicit — ✅ (script commit ef80d12)
    - `ise-readwrite` untouched, ro-run downgrade path preserved — ✅
    - script header policy block rewritten — ✅
    - ADR 0100 — ✅ (PR #634, c0e7102)
    - **re-run against every integrated cluster — ✅, 7 of 7**

    **What this closes, live:** `metrics.k8s.io` is now readable by `system:serviceaccount:ise-integration:ise` everywhere, so `pod_resource_usage` can answer on every cluster rather than 403ing — the concrete gap this task was written around. And Kind Dictionary adoption is no longer gated on a cluster-admin: a new CRD preset enabled in the UI now works immediately, on every cluster, which was the whack-a-mole the ADR set out to end.

    **Worth confirming once during smoke testing**, because it exercises this and ISE-685 together on a cluster that is not g5: run a `pod_resource_usage` evidence query on one of the EKS systems. Green means the grant landed through ISE's own credential path, not just in RBAC theory. If anything is still denied, ISE-685 means it will now say "the cluster credential is not permitted to read pod metrics (403 denied)" rather than sending you to install metrics-server — so the failure, if there is one, will name itself.

    **Process note for the next RBAC change.** The instruction I first wrote here — re-run the provisioning script per cluster with the right `-type` — was wrong, and wrong in a way that carried real risk: an `ro` run on `mgnt-staging-uk` would have silently deleted its write role. The change was one `kubectl apply` of a single cluster-scoped object; six of the script's seven steps are no-ops on an already-provisioned cluster. **A provisioning script is not the unit of change for a change to one object it happens to manage.** The follow-up (a role-only mode on `create-ise-clusterrole.sh`) is worth raising as its own task so this is not re-derived next time.

    Moving to Review with the rest of Sprint 64.
assignee: steve
label:
- improvement
- tech_debt
priority: high
task_status: review
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