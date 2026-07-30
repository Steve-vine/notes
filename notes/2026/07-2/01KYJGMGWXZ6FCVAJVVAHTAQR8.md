---
id: 01KYJGMGWXZ6FCVAJVVAHTAQR8
created: 2026-07-27T19:25:41.149086Z
updated: 2026-07-30T10:21:10.964515Z
type: task
title: 'Stale open incidents: surface recovered-alert incidents for review (queue, cues, wallboard-honest counts)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 339
order: 0.0
sprint: s3fr4ef
assignee: steve
label: null
priority: medium
task_status: todo
---
Live finding (2026-07-27, MCP acceptance testing): **33 of 37 open/acknowledged incidents had alerts that had already recovered** — the signal self-healed but the incident sat open indefinitely. The queue reads as 37 fires when ~4 are real. An operator had to ask Claude to dig this out with `list_incidents(alert_status: "recovered")`; ISE should surface it itself.

Deliberately human-gated: an incident is human-owned (ADR 0025) — a recovered *signal* is evidence, not resolution (the alert may be flapping, or the fix unverified; `recovered` ≠ `resolved` in SIGNAL_STATUSES for a reason, and reactivation exists precisely because recovered things come back). So this is a **review loop**, not auto-resolve.

Scope (vertical):

1. **Queue**: a "recovered N h ago" treatment on the alert-status pill for open incidents whose signal is recovered — plus a one-click queue filter ("stale open" preset: status open/acknowledged/reactivated + alert recovered). Needs `recovered_at` surfaced (finding's transition time — check what promotion/alert-lifecycle already stamps; may need a small read-time derivation from the audit trail rather than a migration).
2. **Cue**: the incident brief + MCP cues block gains an `alert_recovered` cue ("this incident's alert recovered 6h ago and has stayed clear — verify and resolve?"). Both surfaces get it for free via `build_cues`.
3. **Review affordance**: from the filtered queue, resolving is the existing one-click transition (cascades to signal + children); consider a bulk-resolve on the filtered set — T-shirt it during design, don't assume.
4. **Honesty elsewhere**: wallboard/Overview counts that say "N open incidents" should not silently include stale ones — decide whether to split the count ("37 open, 33 recovered-quiet") or leave (design call with Steve).

Explicitly out: auto-resolving after a quiet window (that would be a policy ADR — note it as a possible follow-up once the review loop shows the numbers are trustworthy).

DoD: an operator seeing the queue immediately knows which open incidents still have a live alert; the IN-1095-style case ("recovered 6¼ hours, stayed clear") is visible without asking Claude to enumerate it.