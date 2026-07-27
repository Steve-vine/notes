---
id: 01KYH76K7J53A4BQ91TBCN5MCE
created: 2026-07-27T07:21:33.170583Z
updated: 2026-07-27T11:56:15.271712Z
type: task
title: Wallboard stale age must be clock-skew safe — compute freshness server-relative
project: 01KX671DATY39VW6GWK3M2T3DN
number: 321
sprint: sak4nk6
assignee: steve
label:
- follow_up
- bug
priority: medium
task_status: todo
---
Follow-up from ISE-293 (found 2026-07-27 reviewing the shipped freshness logic).

**Problem:** `isStale()` and `compactAge()` in `app/frontend/src/components/dashboardStatus.ts` compare `last_evaluated_at` against the TV's `Date.now()`. A wallboard TV is exactly the device with an unmanaged, driftable clock (same failure class as the ISE-198 clock-skew spinner). A clock >90 s ahead shows a permanent false stale banner; a clock behind masks a real evaluator stall for as long as the drift. Status ages ("red for 23m") skew the same way.

**Fix:** never trust the client wall clock for freshness.
- Include the server's now in the board payloads (e.g. `server_time` on the grid/detail responses — both the public `/board/{token}` reads and the authed dashboard reads, so the in-app board benefits too).
- On each successful poll, compute age server-side-relative: `(server_time − last_evaluated_at)` + elapsed since receipt measured with a monotonic client timer (`performance.now()`), not `Date.now()`.
- Route `isStale`, the top-right freshness text, and `compactAge` status ages through the same helper. The helpers already take an injectable `nowMs`, so tests extend naturally (drifted-clock cases: ±10 min drift must not change banner behaviour).