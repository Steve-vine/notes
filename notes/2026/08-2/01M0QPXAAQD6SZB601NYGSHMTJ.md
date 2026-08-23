---
id: 01M0QPXAAQD6SZB601NYGSHMTJ
created: 2026-08-23T16:22:56.599492Z
updated: 2026-08-23T16:23:02.693938Z
type: task
title: Actor enrichment sweeps the whole audit log and OOMs the worker — filter per item instead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 395
sprint: s5gwx0s
assignee: steve
label:
- bug
priority: high
task_status: active
---
Fix-forward for COM-390, found on staging the moment `AuditLog.Read.All` consent landed (2026-08-23 16:18).

**What happened.** `enrich_actors` fetches the directory audit log **once per pass** over a window covering the oldest pending item, then matches locally. With 11 pending items dating back to 18 Aug the window was 5 days, and `graph_get_all` accumulated **23,000+ audit records** into a single list. The worker (512Mi limit) was **OOMKilled, exit 137**, mid-pass.

**The real defect is complexity, not the memory limit.** The sweep is O(tenant audit volume) when it should be O(pending items): it fetched 23k records to find at most 11. Raising the limit would only move the cliff.

- [ ] Replace the tenant-wide sweep with **one filtered query per pending item**: `activityDateTime` window **and** `targetResources/any(t: t/id eq '<id>')`, which directoryAudits documents as supported. Bounded by the size of a validation queue a human works — naturally small.
- [ ] Pick the filter id **by kind**, because the group is not a target resource on a membership change: `user_created`/`member_added`/`member_removed` → the user id; `group_created`/`group_deleted` → the group id. The both-endpoints rule stays a local check against `modifiedProperties`, unchanged.
- [ ] `graph_get_all` gains `max_items` — stop paging at a ceiling — as a belt-and-braces guard so no caller can ever accumulate unboundedly again. Log when it caps: no silent truncation.
- [ ] Escape single quotes in ids before they enter the OData filter.
- [ ] Test that the query carries the id filter (not a bare time window), and that a tenant with a huge audit log is never swept.

**Not** raising the worker memory limit: that hides the bug rather than fixing it.

Refs: COM-390 (the code), COM-275 (the overlap guard that is currently masking the crash — syncs skip for 30 min after a stranded claim), ADR 0045 §7.