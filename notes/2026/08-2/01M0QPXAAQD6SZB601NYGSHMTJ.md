---
id: 01M0QPXAAQD6SZB601NYGSHMTJ
created: 2026-08-23T16:22:56.599492Z
updated: 2026-08-23T16:59:51.286259Z
type: task
title: Actor enrichment sweeps the whole audit log and OOMs the worker — filter per item instead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 395
sprint: s5gwx0s
comments:
- id: 01M0QS0PVKKQ58XC06RYSKQEVP
  author: Steve Vine
  at: 2026-08-23T16:59:44.883106Z
  text: |-
    Fixed, merged (PR #395) and verified on staging (`staging-20260823-1648`).

    **Before**: one sweep per pass, 23,000+ audit records accumulated into a single list, worker OOMKilled (exit 137).
    **After**: **11 filtered queries** for 11 pending items. Worker at 287Mi against its 512Mi limit, zero restarts through a full mirror sync plus enrichment, zero cap warnings.

    Real results on the tenant — 7 of 11 items attributed:

    - 5 × `group_created` and 2 × `member_removed` resolved to named people (`S.Vine@`, `N.Brambles@`, `D.Dandy@`) with the tenant's own `performed_at`, all earlier than `observed_at` as expected.
    - **Two app actors fired for real**: `ConnectSyncProvisioning_MPWXAADC_bd89f9fc875b`. That's on-prem AD Connect creating groups — exactly the case COM-390's brief called out as signal rather than a failure to resolve a person, and it'll render with COM-391's service badge instead of pretending to be a user. Good confirmation the app path isn't theoretical.
    - The remaining 4 are correctly `pending` with **no** reason — the read succeeded and found no match in the window, which is "not yet available", not "unavailable". They'll retry until the 7-day give-up then stamp `unknown`. Correct behaviour, not a miss.

    The lesson worth carrying: the original design traded "fewer requests" for "unbounded response size", and that trade is only safe when you know the collection is small. `graph_get_all` accumulates everything into one list, so any caller assuming a small collection is one busy tenant away from an OOM — hence `max_items` as a general guard rather than just fixing this one call site.

    Checked memory headroom while I was there: worker 287Mi/512Mi, worker-execution 182Mi/384Mi. No concern — the earlier 469Mi reading was the pod sum across two containers with separate limits.
assignee: steve
label:
- bug
priority: high
task_status: review
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