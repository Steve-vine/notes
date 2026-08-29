---
id: 01M16PAPHFA03Y9FWG161RR8Q4
created: 2026-08-29T12:01:22.991156Z
updated: 2026-08-29T17:08:08.527112Z
type: task
title: Membership changes don't reach the mirror until the daily full crawl
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 508
sprint: s2fcksg
comments:
- id: 01M16Q9XFZ3SWBE9K05E73F3HR
  author: Steve Vine
  at: 2026-08-29T12:18:25.918745Z
  text: |-
    **Forced full crawl, 2026-08-29 — measured, and it found drift in both directions.**

    Delta links nulled at 12:00:59Z; the 12:15 tick ran a full pass.

    - **Duration: 149.7s (~2.5 min)** — 12:15:00.02Z → 12:17:29.70Z. Compare a delta pass at 5–9s.
    - The missing membership landed: Natasha Berlinski now appears in `compass-vendormanagers`, ~1h47m after the change was made in Entra.
    - **`memberships_count` went 70,866 → 70,826.** One membership was added, so the crawl dropped ~41 the mirror was still carrying.

    That last figure matters more than the reported symptom. **Membership *removals* aren't surfacing either** — the mirror held ~41 memberships that no longer existed in Entra, i.e. Compass was showing people as holding access they had already lost. For an access-governance tool that is the worse direction of the two, and it means the recertification and coverage screens have been reading from a mirror that over-states access, at up to 24 hours of drift. Whatever fix is chosen must be verified against removals, not just additions.

    **On shortening the backstop:** at 2.5 minutes a pass, an hourly full crawl is a ~4% duty cycle and is affordable as an interim mitigation while this is fixed — it would have cut this incident from ~7 hours to under an hour. Still a mitigation: it narrows the window, it does not close it, and the cost scales with tenant size (1,557 users / 3,342 groups / 70k memberships today).
assignee: steve
company: null
label:
- bug
priority: urgent
task_status: todo
---
**Observed on staging, 2026-08-29.** A membership change made through New Requests → Membership Change was written to Entra successfully and was still absent from Compass an hour later.

## What happens

The 15-minute delta pass only re-reads a group's members when that group **surfaces** in `/groups/delta`. Group *creation* surfaces one; a **membership-only change does not**. So a new member is invisible to Compass until the next 24-hour full crawl.

Confirmed on the live mirror:

| Fact | Evidence |
|---|---|
| Entra write succeeded | `POST /groups/1c683b86-.../members/$ref` → 204, worker log 10:30:57Z |
| Group mirrored fine | `directory_groups` row, created 10:25:33Z — group creation *does* surface |
| Membership never mirrored | `directory_group_members` = **0 rows** for that group after 4 delta passes |
| Mirror frozen | `memberships_count` 70,866 unchanged 10:30Z → 11:45Z |
| Backstop is the only repair | `last_full_completed_at` = 2026-08-28 17:20Z, so the change would have landed ~17:20Z — **~7 hours late** |

`directory_sync.py:565-571` states the intended mechanism:

> `$deltaToken=latest` mints a deltaLink without enumerating; the query params are baked into the token […] `$expand=members` is what makes a membership-only change surface its group in the delta at all

That is the assumption that is not holding. Most likely cause: minting with `$deltaToken=latest` carries `$select` through but **not** `$expand`, so the stored token isn't watching members. Confirm against Graph before fixing — this last step is inference, everything above it is measured.

Introduced by COM-316 (the delta pass, merged 2026-08-20). Before that every pass was a full crawl, so this could not happen.

## Why no test catches it

`tests/test_directory_sync.py` drives a fake tenant that decides what the delta returns, so it asserts *Compass's assumption about Graph* rather than Graph's behaviour. No test can fail here regardless of what Microsoft does. Whatever the fix, it needs a check that pins the real behaviour — a contract test against a live tenant, or a startup/health assertion that the minted token actually reports a membership-only change.

## Candidate fixes

1. **Handle `members@delta` in the delta pass.** `_run_delta_pass` deliberately avoids it (`directory_sync.py:796-800`) in favour of re-reading edges via `$batch`. Reading `members@delta` to decide *which* groups to re-crawl keeps the tested reconciliation and fixes the surfacing gap.
2. **Mint the token by enumerating** rather than with `$deltaToken=latest`, so `$expand` is definitely carried. Costs one full enumeration per mint, which only happens after a full pass.
3. **Shorten the backstop** — mitigation, not a fix. See the sibling consideration below.

## Blast radius beyond the reported symptom

Any membership change is up to 24 hours stale, whether made in Compass or directly in Entra. That also degrades out-of-band change detection: a membership added directly in Entra isn't flagged until the daily crawl, which is the opposite of what that feature is for.

## Immediate mitigation applied
Delta links nulled on staging at 2026-08-29 12:00:59Z to force a full crawl. That is a workaround for one incident, not a fix.
