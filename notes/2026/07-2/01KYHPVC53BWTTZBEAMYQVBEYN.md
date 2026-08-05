---
id: 01KYHPVC53BWTTZBEAMYQVBEYN
created: 2026-07-27T11:55:02.691783Z
updated: 2026-08-05T13:39:06.079673Z
type: task
title: Evidence over MCP + a real Kubernetes evidence catalogue (live cluster reads)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 333
sprint: sax9eff
assignee: steve
priority: high
task_status: done
---
Fixes the root cause of the IN-1092 complaint: the Kubernetes connector declares the `evidence` capability (`kubernetes.py:512`) but implements **zero** evidence queries — only DataDog (`datadog.py:871`) and MCP-evidence connectors do — so no surface can see the live cluster, only the synced snapshot.

- **Expose the evidence layer over MCP**: `list_evidence_queries` (from each connector's `evidence_catalogue`, scoped to the pinned incident's context) + `fetch_evidence` (bounded, read-only, ADR 0027/0031 contract). Role-gated; requires a pinned session.
- **NEW: Kubernetes `evidence_catalogue`/`fetch_evidence`** — bounded live reads the IN-1092 investigation needed: describe pod (status/conditions/events), node capacity + allocatable + current requests, recent scheduler/kubelet events for an entity, pending-pod reasons, workload rollout status, recent pod logs (tail-bounded, redaction list applies). Validated query names only — never arbitrary reads, matching the base-class contract.
- Evidence fetches are deterministic connector calls — **zero ISE AI-token spend** — and each result is stamped to the session (audit task records it, and the payload becomes citable Evidence on the incident as with in-app investigations).
- Benefits every surface, not just MCP: diagnose/analyse runs and the demoted in-app chat get the same catalogue for free.

Vertical DoD: from a pinned Claude session on a FailedScheduling incident, "what's actually happening on the cluster?" returns live node capacity + pending-pod reasons — the exact question IN-1092's chat couldn't answer.