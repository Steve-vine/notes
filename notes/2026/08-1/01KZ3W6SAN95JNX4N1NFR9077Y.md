---
id: 01KZ3W6SAN95JNX4N1NFR9077Y
created: 2026-08-03T13:14:59.285332Z
updated: 2026-08-05T14:49:38.416545Z
type: task
title: 'Estate: production clusters have no kind dictionary — all Rollouts unsynced'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 512
order: 1.5
sprint: skxht3g
comments:
- id: 01KZ3ZTCXDFAE126JF0D61YY9W
  author: Steve Vine
  at: 2026-08-03T14:18:07.661328Z
  text: |-
    Precondition verified — this is now SAFE to action, but it needs you: it's an authenticated admin change in the UI, not a code change.

    **The blocker is cleared.** ISE-510 is live on the running instance: I checked the deployed images (zot.citops.net/ise/backend:staging-20260803-1318) and the database is at alembic head 0090, which only exists on the branch carrying the shared-cross-key guard. So adding the dictionary entries will no longer collapse the prod Rollouts into merged blobs — each will resolve as its own entity even where they share DataDog service tags.

    **Current state (read straight from the live DB):**
    - env-production-uk-pri — 0 kind entries
    - env-production-us-pri — 0 kind entries
    - env-staging-uk / env-staging-us — 2 each (Rollout + ExternalSecret)
    - mgnt-production-uk-pri, mgnt-staging-uk — 0 (as you suspected, worth deciding whether that's intentional)
    - g5 — 0, but the integration is disabled, so it doesn't matter

    **Exactly what to add** to both production Systems (Settings → the System → Kind dictionary), copied from what env-staging-uk already stores:
    1. Rollout — group `argoproj.io`, version `v1alpha1`, plural `rollouts`, entity_type `workload`, owns `replicasets`, datadog_scope_tag `kube_rollout`
    2. ExternalSecret — group `external-secrets.io`, version `v1`, plural `externalsecrets`, entity_type `other`, no scope tag

    Both are one-click presets in the editor, so you shouldn't need to type any of that — and the Add flow probes the cluster before saving, so a wrong version fails loudly rather than silently discovering nothing.

    **Why I stopped rather than doing it:** the instance authenticates through EntraID and I hold no admin session. The only ways round that would be break-glass (reserved for Entra outages) or writing system.config directly into Postgres — which would bypass the editor's validation and the audit record. Neither is appropriate for a production config change.

    **Related:** ISE-513 (PR #438, in review) makes this self-announcing — once deployed, both production Systems will show "This cluster serves 2 kinds ISE is not watching", naming Rollout with "env-staging-uk already maps it" and the count of invisible objects, with a button that fills the form. You may prefer to wait for that release and action this from the callout, which also confirms the fix works on the exact case that motivated it.
- id: 01KZ47VCJC2B24BJSDHXV6K5YK
  author: Steve Vine
  at: 2026-08-03T16:38:28.684716Z
  text: |-
    Confirmed complete by Steve 2026-08-03. Verified against the live DB: env-production-uk-pri and env-production-us-pri now each carry 2 kind-dictionary entries, matching both staging clusters.

    The prod Rollouts and ExternalSecrets will be discovered on the next Kubernetes sync of each cluster, and — because ISE-510 shipped first (alembic head 0090, guard live) — workloads sharing a DataDog service tag will resolve as distinct entities rather than collapsing into merged blobs.

    Still open as a separate question from the original ticket: mgnt-production-uk-pri and mgnt-staging-uk have no dictionary either. Worth deciding whether that's intentional; ISE-513's gap callout will now tell you directly on each System's detail page.
assignee: steve
priority: high
task_status: done
---
Found in Sprint 46 Estate testing (full cluster-vs-DB diff). env-production-uk-pri and env-production-us-pri have no kind-dictionary entries on their System config, so none of their Argo Rollouts are discovered: 34 Rollouts missing in prod-uk (chinwag-prod/-demo, chinwag-v2-prod/-demo, openanswer, scout-prod) and 31 in prod-us. ExternalSecrets are likewise undiscovered. Staging clusters have the Rollout + ExternalSecret entries; production was never configured. g5, mgnt-production-uk-pri and mgnt-staging-uk also have no dictionary (may be intentional — check).

**Fix:** add the Rollout and ExternalSecret preset entries to both production Systems (Settings → kind dictionary editor).

**Order matters:** do this AFTER ISE-510 is fixed — prod Rollouts share DataDog service tags the same way, so syncing them now would permanently collapse them into merged blobs on first discovery.

Services and namespaces verified 1:1 on all four clusters; no other sync gaps.