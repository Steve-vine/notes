---
id: 01M7K35RK7GS47CNZ7EK4JT3HP
created: 2026-11-16T21:10:56.87106Z
updated: 2026-11-16T23:26:06.988381Z
type: task
title: Discarding Polaris's corrected check leaves its "Change proposed" verdict behind, with only Dismiss
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1878
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: active
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