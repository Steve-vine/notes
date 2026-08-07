---
id: 01KZDRMPBJH3MSTB5XCYF82SC2
created: 2026-08-07T09:25:05.010101Z
updated: 2026-08-07T20:14:32.546277Z
type: task
title: Evidence catalogue extension — general-purpose read queries for estate Q&A
project: 01KX671DATY39VW6GWK3M2T3DN
number: 599
sprint: snk16ew
comments:
- id: 01KZEG0TQ2F9BW6938KQN5ZB5S
  author: Steve Vine
  at: 2026-08-07T16:13:39.938152Z
  text: |-
    Done — PR #522 (feature/ise-599-evidence-catalogue-extension).

    AUDIT (against the ISE-595 seed bank). Kubernetes was the only catalogue with a miss worth building:
    - Kubernetes — MISS. All six queries start from a suspect you already named. "What images run in prod right now" / "top memory consumers in namespace X" had nothing.
    - EntraID — covered. app_credential_expiry answers the app-registration question directly; password expiry became SYNCED state in ISE-596, so "users with passwords expiring in 5 days" is an estate query, not an evidence pull.
    - AWS / Azure — covered. Both already carry generic list_resources + describe_resource.
    - Cloudflare / DataDog / Freshservice — covered for their common read questions.
    - M365 — thinnest (service_health_issue, message_center, license_detail), but its user/mailbox questions overlap EntraID. Deliberately left until the full bank lands (ISE-595), per this task's "others as the bank demands".
    - "What does the Chinwag document say" and "what would happen if X stopped responding" are Documents and impact analysis, not Evidence — no gap.

    BUILT — four Kubernetes sweeps that start from "what is actually running":
    - list_namespaces — phase, labels, live pod count (orientation).
    - list_workloads — deployments/statefulsets/daemonsets with container IMAGES and desired/ready replicas; scopeable by namespace, kind or label selector.
    - list_pods — phase, node, restarts, age, images, ready ratio.
    - pod_resource_usage — live metrics-server usage, biggest first, reported AGAINST each pod's requests.

    Decisions worth keeping:
    - A daemonset counts nodes, not replicas. Both are normalised onto desired/ready so the agent reads one shape rather than learning two.
    - Usage alone says nothing — pod_resource_usage returns usage next to requested and a memory_pct_of_request ratio.
    - metrics-server is a cluster add-on, not part of the API server. Its absence is a FACT about the cluster the answer should state, so it degrades to ok=False with a summary (ADR 0031) instead of raising.
    - Sweeps cap at 200 rows. An unbounded pod list is a context-window denial of service.

    ADR 0031 contract untouched — named queries with parameter schemas, side-effect-free, results untrusted, catalogue-guarded. No ADR needed. Assist, incident investigation and the MCP surface inherit all four with zero per-surface wiring (Evidence parity confirmed: no frontend or MCP code names individual query names).

    Tests: 11 new cases in tests/test_kubernetes_evidence.py. ruff + mypy strict + suite green locally.
assignee: steve
label: null
priority: medium
task_status: done
---
The Evidence catalogues were built for incident diagnosis, not open estate questions — Kubernetes offers only six queries (describe_pod, node_capacity, recent_events, pending_pods, rollout_status, pod_logs); a question like "what images run in prod right now" or "top memory consumers in namespace X" has no matching query.

- Audit every integration's `evidence_catalogue` against the question bank (ISE-595); list the misses.
- Extend catalogues with general read queries where synced state can't answer (live-now questions). Kubernetes first; others as the bank demands.
- Keep the ADR 0031 contract untouched: named queries with parameter schemas, side-effect-free by contract, results untrusted, credential access audited. We widen what can be asked, never what can be done.
- All three interfaces inherit automatically (Evidence parity — no per-surface wiring).

Screen: answers in Assist; queries also visible wherever evidence pulls already render.