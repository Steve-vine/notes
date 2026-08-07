---
id: 01KYH76K7J53A4BQ91TBCN5MCE
created: 2026-07-27T07:21:33.170583Z
updated: 2026-08-07T09:40:49.919642Z
type: task
title: Wallboard stale age must be clock-skew safe — compute freshness server-relative
project: 01KX671DATY39VW6GWK3M2T3DN
number: 321
sprint: sak4nk6
comments:
- id: 01KYHWH89QXD6P9FY01XX3242T
  author: Steve Vine
  at: 2026-07-27T13:34:22.519836Z
  text: |-
    Done — PR #298 (feature/ise-321-board-freshness-server-relative → main).

    Freshness is now anchored to the server clock, never the TV's wall clock:
    - server_time added to all four board payloads (public BoardGrid/BoardServiceDetail + authed DashboardServiceList/DashboardServiceDetail).
    - New freshnessAnchor / serverNow / useServerNow in dashboardStatus.ts: anchor the server time to performance.now() at receipt and advance it monotonically. isStale, the top-right freshness text and the compactAge status ages all route through the server-relative now.
    - Drift-immunity unit tests (±drift never flips the banner) + server_time asserted on the board payloads.

    Local gates green: frontend build/lint/prettier, 17 FE tests, 12 board/dashboard BE tests, mypy. Moving to Review.

    Note: surfaced and fixed three unrelated Sprint-26 defects that were blocking main (PR #297, merged) before building this.
assignee: steve
label: null
priority: medium
task_status: done
---
Follow-up from ISE-293 (found 2026-07-27 reviewing the shipped freshness logic).

**Problem:** `isStale()` and `compactAge()` in `app/frontend/src/components/dashboardStatus.ts` compare `last_evaluated_at` against the TV's `Date.now()`. A wallboard TV is exactly the device with an unmanaged, driftable clock (same failure class as the ISE-198 clock-skew spinner). A clock >90 s ahead shows a permanent false stale banner; a clock behind masks a real evaluator stall for as long as the drift. Status ages ("red for 23m") skew the same way.

**Fix:** never trust the client wall clock for freshness.
- Include the server's now in the board payloads (e.g. `server_time` on the grid/detail responses — both the public `/board/{token}` reads and the authed dashboard reads, so the in-app board benefits too).
- On each successful poll, compute age server-side-relative: `(server_time − last_evaluated_at)` + elapsed since receipt measured with a monotonic client timer (`performance.now()`), not `Date.now()`.
- Route `isStale`, the top-right freshness text, and `compactAge` status ages through the same helper. The helpers already take an injectable `nowMs`, so tests extend naturally (drifted-clock cases: ±10 min drift must not change banner behaviour).