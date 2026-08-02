---
id: 01KZ0YS5SCMTFC6ETBSCN76Y7R
created: 2026-08-02T10:02:15.724228Z
updated: 2026-08-02T10:28:36.354059Z
type: task
title: Resources are named by their source of record
project: 01KX671DATY39VW6GWK3M2T3DN
number: 471
sprint: s7j0986
blocked_by:
- 01KZ0YRK9K11JD5JQGHZYK9J8E
assignee: steve
priority: high
task_status: todo
---
Make the estate readable. Today 73 of 246 production hosts are called `i-0abc…` or a raw UUID, because DataDog names them and DataDog only ever had the instance id.

- **The source of record names the Resource.** AWS knows an EC2 instance's Name tag; Kubernetes knows a Deployment's name. Most of the naming problem disappears as a consequence of the source-of-record decision.
- **Scope for display comes from the containment graph, not the string.** Names are not unique — two clusters each have a `checkout`, two accounts each have a `web-01` — so a Resource is *displayed* with enough of its containment path to disambiguate (`checkout` in `shop` on `prod-uk`). Never bake scope into the name; that repeats the native-key mistake.
- **Never invent a name, but always render type and scope.** An EBS volume with no Name tag stays `vol-0abc…`, shown as "EBS volume vol-0abc… in Staging" — readable even when the identifier isn't.

**Retires the existing rule** that only renames an entity while a single integration knows it (`_named_only_by` in `discovery.py`). That rule exists because ISE had no way to decide whose name should win; declaring sources of record settles it, so the machinery goes rather than being worked around.

**Acceptance**: no entity in the estate is displayed as a bare opaque identifier with no type or scope; renaming at source is reflected on the next sync regardless of how many integrations know the entity.

Depends on the source-of-record task.