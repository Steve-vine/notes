---
id: 01KYH76XE8TC74BYEE9HDYTFR6
created: 2026-07-27T07:21:43.62456Z
updated: 2026-08-07T10:06:36.686703Z
type: task
title: Wallboard second-stage staleness — dim tiles to "last known state" after ~15 min
project: 01KX671DATY39VW6GWK3M2T3DN
number: 322
sprint: sak4nk6
blocked_by:
- 01KYH76K7J53A4BQ91TBCN5MCE
comments:
- id: 01KYHWVPRMDD94H5Q210PWQTR2
  author: Steve Vine
  at: 2026-07-27T13:40:05.012115Z
  text: |-
    Done — PR #299 (feature/ise-322-second-stage-staleness), stacked on ISE-321.

    - VERY_STALE_AFTER_MS = 15min added alongside STALE_AFTER_MS; stalenessTier() returns fresh | stale | very_stale off the same server-relative freshness scalar.
    - Past 15min, tiles wash out (grayscale+dim VERY_STALE_TILE_FILTER): status word + name stay legible, fill keeps only a faint tint — reads as neither green nor alerting, distinct from all four live states. Alert pulsing drops. Banner stays, turns grey, reads "Showing last known state — Xm old". Never-evaluated stays plain stale (no last state to show).
    - Applied to the wallboard AND the in-app Dashboards tile via the shared helpers.
    - Tests: tier boundaries (fresh/stale/very-stale/null) + a very-stale wallboard render.

    Local gates green: build/lint/prettier + FE tests. Base is feature/ise-321 (retargets to main once 321 merges). Moving to Review.
assignee: steve
priority: low
task_status: done
---
Follow-up from ISE-293. Today the 90 s stale banner is the only stale treatment: under it, tiles keep their full colour indefinitely. A board that has been dead for hours still shows confident deep-green tiles, and a banner people walk past daily gets tuned out — the one failure a status wall must never have.

- Add a second threshold (`VERY_STALE_AFTER_MS = 15 * 60_000` alongside `STALE_AFTER_MS` in `dashboardStatus.ts`), driven by the same single freshness scalar (and by the server-relative age once ISE-321 lands).
- Past it, tiles dim/desaturate to a "last known state" treatment: keep the status word and name legible, drop the fill saturation hard (e.g. greyed fill with a muted tint of the level colour), and label the board "showing last known state — Xm old". The banner stays.
- Applies to the wallboard first; the in-app board tile stale marker can adopt the same treatment cheaply since the helpers are shared.
- Respect the calm-when-green design: very-stale must read as *neither* green nor alerting — visually distinct from all four live states.
- Tests via the injectable `nowMs`: fresh / stale / very-stale rendering.