---
id: 01KYAE3QN39PSD50A5BY5WTJRE
created: 2026-07-24T16:07:38.403722Z
updated: 2026-07-24T16:08:23.96033Z
type: task
title: 'ADR + model: per-integration Kubernetes kind dictionary'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 256
sprint: s5khymf
assignee: steve
label:
- brief
priority: medium
task_status: backlog
---
Design decision + config model for making the Kubernetes connector's discoverable kinds extensible. Motivating case: Argo Rollouts are invisible (workload discovery and the pod→owner chain are hard-coded to Deployment/StatefulSet/DaemonSet), so Rollout-managed apps produce no workload entity, edges, baselines or pod-obs rollup.

**Decision (taken with Steve 2026-07-24, capture in the ADR):** the dictionary maps a kind onto a canonical entity type — `{GVK} is-a {entity type}` (e.g. `Rollout.argoproj.io/v1alpha1 → workload`) — NOT open relationship triples (`<CRD> - <relationship> - <parent>`). Rationale: containment edges (part-of namespace, runs-on node) are derived from the object's own metadata and pods at discovery time, never from config; what config must supply is only what the CRD *is*. Mapping to a canonical type inherits the full workload semantics bundle (edges, owner-chain membership, baseline shape, lifecycle). Open config-authored relationships (e.g. depends-on) remain the Relationship Mapping sprint's separate edge-authoring work.

**Entry shape:** GVK (group/version/kind + plural for the custom-objects API) → canonical type, plus optional overrides where convention doesn't hold: replica JSONPaths (default `spec.replicas`/`status.readyReplicas` — the scale-subresource convention), DataDog monitor scope tag (e.g. `kube_rollout`, feeds ISE-254 resolution), owner-chain participation (owns ReplicaSets directly like Deployment, or pods directly like StatefulSet).

**Scope decisions:**
- **Per integration instance**, stored in `System.config` (JSONB, exists) — not a global setting. Two clusters can know different CRDs.
- Built-ins (Deployment/StatefulSet/DaemonSet) become locked dictionary entries — same mechanism, not special cases.
- Write actions (scale/restart) stay OFF for custom kinds in this slice — restart semantics are per-CRD (Rollout uses `spec.restartAt`, not the annotation) and dangerous to generalise.
- Native keys: custom kinds mint the ADR 0045 scoped form `k8s:{system_id}:{ns}/{kind}/{name}` — kind slug from the dictionary entry.

Deliverable: the ADR (amends ADR 0027 connector contract; references 0045) + the config schema. Headless by design — the screen lands in the dictionary-editor task.