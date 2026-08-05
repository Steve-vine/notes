---
id: 01KYHFD866WG4NDMA315EY7HVR
created: 2026-07-27T09:44:59.84631Z
updated: 2026-08-05T13:25:00.589697Z
type: task
title: 'Incident merge: manual "Merge into…" + graph-aware candidate proposals'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 328
sprint: s3fr4ef
assignee: steve
label: null
priority: medium
task_status: done
---
Live case (2026-07-27): IN-1091 and IN-1092 — both `failed_scheduling` observations ("0/9 nodes available: Insufficient cpu/memory"), one cluster-capacity root cause surfacing in two namespaces (`chinwag-v2-test`, `openanswer`) — offered **no merge option**. Two gaps compound:

1. `propose_merges` (`merge.py:90`, ADR 0035) requires the exact same `Finding.entity_id` when an entity resolved; the loose same-system+same-kind fallback only applies when entity resolution *failed*. Symptom-identical incidents on different entities never match.
2. The `MergePanel` on the incident page renders only when candidates exist — there is no manual merge, so the operator who can plainly see the duplication has no escape hatch.

**Fix A — manual merge (UI).** A "Merge into…" control on the incident detail page: searchable picker of active standalone incidents (exclude self, children, masters where structure forbids it), calls the existing `POST /issues/{id}/merge` — the endpoint already accepts any legal pair; only the proposal logic is narrow. Structural rules (`MergeRejected`) keep guarding depth-1 / active-only. Human-gate unchanged (ADR 0025 §5).

**Fix B — widen candidate proposals (graph-aware).** Also propose when findings share signal kind (or alert source) AND their entities are related in the estate graph — e.g. siblings under the same cluster/parent via `part-of`, reusing the ADR 0028 traversal. Reason string should say why ("same signal kind, entities share cluster X"). Keep it a proposal — nothing merges automatically.

DoD: both usable from the incident screen; the IN-1091/IN-1092 pair either gets proposed (B) or is mergeable by hand (A). Likely an ADR 0035 amendment for the widened relatedness rule.