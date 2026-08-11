---
id: 01KZPZ58A07KAY2S8Z9Z7NJKQ0
created: 2026-08-10T23:12:09.024354Z
updated: 2026-08-11T13:58:14.135666Z
type: task
title: The DataDog↔Kubernetes join is sound and unpopulated — 1 of 421 workloads carries the label it needs
project: 01KX671DATY39VW6GWK3M2T3DN
number: 651
sprint: s1rgnyx
comments:
- id: 01KZQZTXCGBAHCXZ7W28RJCHXN
  author: Steve Vine
  at: 2026-08-11T08:43:13.167968Z
  text: |-
    Decision (Steve, 2026-08-11): option 1 — label the workloads. Option 2 (resolve `service:X` against workloads by name) is dropped, not deferred: it infers a relationship the estate never stated, and dropping it removes this task's dependency on ISE-647's disambiguation rule.

    That splits the work by owner:

    - **Estate (Steve, Helm/manifests)**: add `tags.datadoghq.com/service` to the Deployments/Rollouts that have a DataDog service. Not an ISE change, and it fixes the DataDog↔k8s join for impact, blast radius and graph edges too — not just alert linkage.
    - **ISE (this task)**: make the gap visible and self-explaining, so an unfed join stops looking like a broken one. Two parts: (a) a coverage surface naming workloads that DataDog alerts on but that carry no service label, and (b) the unlinked-incident explanation saying *which* gap applies — "no workload publishes `datadog:service:openanswer`" rather than a silently empty entity field.

    Scope of this task is now (a) + (b) only. Acceptance restated: for a DataDog alert that resolves to nothing, ISE names the missing label as the reason and points at the candidate workload; once the label is added, the alert resolves to the workload with no ISE change.
- id: 01KZRBKJT9QT22NR2HDW6FVX0B
  author: Steve Vine
  at: 2026-08-11T12:08:55.881694Z
  text: |-
    PR #596 (stacked on #595). The ISE half is built; the estate half is yours and needs no further ISE change.

    **The classification is by counting, not inference.** `coverage_gap.explain` asks how many entity aliases publish an identifier of this *shape* — `datadog:service:`, deliberately not `datadog:`, because otherwise a populated monitor namespace would vouch for an empty service one. Zero means the platform is genuinely absent; more than zero means the join demonstrably works and this subject is simply not on it.

    That is the distinction that was missing. Unknown Assets has always been the integration backlog (ADR 0073 §4), so its implicit advice was "integrate the platform" — which for 58 of 60 DataDog alerts is the wrong advice, since Kubernetes is integrated seven times over.

    **Two screens**: a Gap column on Unknown Assets ("Not labelled" / "Not integrated", full sentence on hover), and the sentence on an incident whose signal names a subject nothing claims, beneath the ISE-639 panel.

    **Nothing guesses.** No name matching, no candidate suggestion — a suggestion would be option 2 in softer clothing, and would still assert something the estate has not said.

    **What is left, and it is not code**: the labels. Once a workload publishes `datadog:service:openanswer`, its alerts resolve with no change to ISE — that is the join working as designed. The acceptance clause about alerts resolving is met by the labelling, not by this PR, and I would rather say that plainly than mark it done.

    One incidental hardening: `_annotate_entity_link` now takes a required session rather than an optional one, because an optional one would silently omit the explanation for any caller that forgot to pass it — the exact failure mode this task exists to fix, one layer down.
assignee: steve
label:
- improvement
priority: high
task_status: review
---
Found 2026-08-10 verifying [ISE-638] on staging after deploy. That fix works and still leaves 58 of 60 DataDog alerts unlinked, because the last hop is missing from the **estate**, not from the code.

**How the join is designed to work.** DataDog is `source_of_record = False` (`connectors/datadog.py:470`) — deliberately, per ADR 0073 §3 / ISE-469: *"a source of record for NOTHING: DataDog holds Monitors and Alerts, and neither is a thing in the estate. Its identifiers attach as **aliases** to entities other sources own."* So DataDog can never mint `datadog:service:X`. Kubernetes mints the workload and publishes `datadog:service:{label}` as a cross key, read from the workload's `tags.datadoghq.com/service` label. A DataDog alert then resolves onto that workload.

**How populated it is** (staging, 2026-08-10):

| | |
| --- | --- |
| Kubernetes workload aliases | **421** |
| …carrying a `datadog:service:` cross key | **1** (`chinwag-chat`) |
| DataDog alerts now naming a subject ([ISE-638]) | 18 of 60 |
| …that resolve to an entity | 2 |

One workload in the entire estate carries the label the join depends on. Nothing in the `openanswer` namespace does, which is why the Kora synthetics alerts still resolve to nothing despite naming `service:openanswer` correctly.

**Two ways to close it, and they are not alternatives so much as different owners:**

1. **Label the workloads** — add `tags.datadoghq.com/service` to the Deployments/Rollouts that have a DataDog service. This is the join working exactly as designed, it costs ISE nothing, and it makes the alert→workload link *true* rather than inferred. It is an estate change (Helm/manifests), so it is not ISE's to make — but ISE could surface the gap: "this workload is alerted on by DataDog and carries no service label" is a hygiene report ISE already has all the inputs for.
2. **Resolve `service:X` against workloads by name** — the suffix-match [ISE-638] deliberately deferred, matching `_resolve_unscoped_kube_keys` (ISE-254, ADR 0045 §3). It needs [ISE-647]'s disambiguation rule first, because four clusters carry the same workload names, and it infers a relationship the estate has not stated.

**Recommendation**: 1 as the real fix, 2 as the fallback for services with no Kubernetes home at all. Option 1 also fixes the DataDog↔k8s join for everything else that depends on it (impact, blast radius, graph edges) rather than just for alert linkage.

Worth noting the shape: this is the third time in Sprint 59 that a *correct* mechanism turned out to be **unpopulated** rather than broken — no desk-executable playbooks ([ISE-640]), no state slices for 12 systems ([ISE-644]), and now one service label in 421. A capability nobody has fed looks identical to one that does not work.

**Acceptance**: a DataDog alert on a service that runs in Kubernetes resolves to that workload; and where it does not, ISE says which of the two gaps applies rather than showing an unlinked incident.