---
id: 01M7K35RK7GS47CNZ7EK4JT3HP
created: 2026-11-16T21:10:56.87106Z
updated: 2026-11-17T19:50:15.259053Z
type: task
title: Discarding Polaris's corrected check leaves its "Change proposed" verdict behind, with only Dismiss
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1878
sprint: s7nqsy0
comments:
- id: 01M7KE4V1NWQD5RDH2DGBFG1V2
  author: Steve Vine
  at: 2026-11-17T00:22:40.949306Z
  text: |-
    Done — PR #1870, merged 50702c4d.
    When Polaris answers "Change proposed", discarding its corrected check now closes the verdict too, the same as approving it does. Nothing is left on the control's Evidence tab with only Dismiss, and "Ask Polaris to check this" is available again straight away.
    A verdict still open from before this fix (its corrected check already discarded) no longer says "Needs you" and is grey, not yellow. It reads "Polaris proposed a corrected check (CHK-8), which was discarded on <date> by <person>.", with what Polaris said underneath and a Dismiss button.
    Assumption: nothing clears old leftovers automatically. Each one shows the new wording until someone dismisses it.
    To check on staging: CHM.1 ▸ Evidence ▸ CHK-7 should show the leftover wording. Press Dismiss to clear it (the coordinator does this after deploy), then check that "Ask Polaris to check this" is enabled.
- id: 01M7MJ42JHJRXQ1AFS2PG7XNFY
  author: Steve Vine
  at: 2026-11-17T10:51:24.624829Z
  text: |-
    Pre-UAT on staging 44d15b9a — Passed (one point Couldn't check)
    - Discarding the corrected check closes its verdict too: in E2E Test Company as E2E Admin A, CHC-2 had "Polaris: Change proposed" (Dismiss) and "Polaris proposes CHC-3" (Approve / Discard). I pressed Discard on CHC-3. Both went at once, and after a reload neither shows on CHC-2's page or on ACC.13's Evidence card. Behind the screen, Polaris's job shows both the verdict and the corrected check as discarded at 10:44:53 by E2E Admin A. Review dropped from 3 to 2. Passed.
    - The leftover's wording ("Polaris proposed a corrected check (CHK-8), which was discarded on <date> by <person>", Dismiss, no "Needs you"): Couldn't check. In Test Company (looked only, pressed nothing), CHM.1 ▸ Evidence ▸ CHC-7 (was CHK-7) shows no verdict at all. Polaris's record shows that verdict was already dismissed on 16 Nov at 21:06 by Bob Smith, before this build reached staging, so there's no leftover anywhere to look at. A new leftover can't be made now that discarding closes both. Steve: this wording can only be judged from the tests.
    - "Ask Polaris to check this" available again once the verdict is closed: on CHC-2 it was greyed out while the verdict was open, and enabled straight after the discard, on both the check's page and ACC.13's card. On Test Company's CHC-7 it's also enabled. Passed.
    - Tests: the staging deploy run is green. I didn't read the test files.
    - CHK-7's leftover cleared: CHC-7 shows no leftover (dismissed 16 Nov, see above).
    Screenshots: ~/compass-uat/s7nqsy0/COM-1878/
assignee: steve
priority: medium
task_status: done
---
Defect from Steve's testing of round 2 (staging 43d03f09).

**What happens.** When Polaris checks a check and answers **Change proposed**, it gives two things:
- the verdict, which explains what's wrong;
- a corrected check, which has Approve.

Approving the corrected check replaces the old one. If the corrected check is discarded instead, the verdict stays on the control's Evidence tab as "Polaris: Change proposed", marked "Needs you", with only a Dismiss button and nothing to approve. While it's there, "Ask Polaris to check this" is greyed out.

**Seen on** Test Company, CHM.1 ▸ Evidence ▸ CHK-7.
- Polaris proposed CHK-8 on 14 Nov at 10:02.
- CHK-8 was discarded at 10:04.
- The verdict is still open now.

**Done when**
- Discarding the corrected check closes its verdict too. Approving it already does.
- A verdict that is still open with no corrected check (one left over from before this fix) doesn't say "Needs you". It reads: "Polaris proposed a corrected check (CHK-8), which was discarded on <date> by <person>", with Dismiss. It never looks as if it's waiting for an approval.
- "Ask Polaris to check this" is available again once the verdict is closed.
- Tests cover: discarding closes the verdict; the leftover wording; and the menu item being enabled again.
- CHK-7's leftover verdict on staging is cleared when this ships.

**Where** (for the builder): collection/CollectionCard.tsx (`verdict`, `replacement`, `needsYou`, the menu item disabled when there is a verdict), `VerdictReview`, the discard route for a Polaris proposal, core/collection/polaris_revalidate.py.