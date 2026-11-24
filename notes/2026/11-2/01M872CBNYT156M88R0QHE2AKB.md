---
id: 01M872CBNYT156M88R0QHE2AKB
created: 2026-11-24T15:21:53.086545Z
updated: 2026-11-24T16:27:28.51908Z
type: task
title: When a put-back finishes, the compare list shows the records as Same at once, not Missing for another 25 seconds
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2144
sprint: szwetpq
comments:
- id: 01M8763SP7AHTNY965QHZP4DEP
  author: Steve Vine
  at: 2026-11-24T16:27:06.823198Z
  text: |-
    Pre-UAT re-check on staging c7e9ad0d6 (24 Nov, 16:20–16:27), as E2E Admin A in E2E Test Company only, one browser.

    Setup: I made two technology assets, AST-67 "E2E UAT124 recheck asset A" and AST-68 "E2E UAT124 recheck asset B". I took backup BKP-2 ("COM-2144 re-check"), which was Ready in about 30 s. I deleted both assets through the screens, then used Restore ▸ Open to compare on BKP-2. Inventory: Technology asset said "2 missing, 0 changed" and both rows said Missing.

    While I worked, a page watcher logged the banner, the Technology asset count, both rows and the "N records chosen" bar every time the screen changed.

    **Passed: as soon as the banner says a put-back has finished, the counts and the affected rows reflect it, without a reload**
    - First put-back: I ticked only AST-67, chose Put back… ("Comes back from deleted"), gave a reason, put back 1 record, closed the window and stayed on the screen. At the exact moment the green "Last put-back: 1 record put back from BKP-2 by E2E Admin A, 24 Nov 2026, 16:24" appeared (21.3 s after asking), the count already read "1 missing, 0 changed" and AST-67 read Same. AST-68 still read Missing and was unticked. There was no moment where the banner said finished and the list disagreed.
    - Second put-back: I ticked AST-68 and did the same. When "Last put-back: … 16:25" appeared (20.3 s after asking), the count read "0 missing, 0 changed" and AST-68 read Same, in the same update.
    - After a reload: the banner (16:25), "0 missing, 0 changed", AST-67 and AST-68 both Same, nothing ticked.
    - Small note, not a failure: for about 0.2–0.3 s before each finished banner, the row already read Same while the blue "Putting back 1 record from BKP-2" progress bar was still showing and the count was still the old one (screenshot 04). It never happened after the banner said finished.

    **Passed: ticks for records that were put back are cleared, so they can't be put back twice by accident**
    - After each put-back the "1 record chosen / Put back…" bar went away in the same update as the banner. The returned row shows Same, which has no tick box.
    - The record not ticked (AST-68 during the first put-back) stayed unticked and Missing, and was not put back.
    - "Not put back" didn't apply because nothing ticked was refused, and it never appeared. That case, a refused or failed put-back keeping its tick with the reason, is covered only by the component test below. I didn't see it in the browser.

    **Passed (by reading the code; I didn't run it): a component test fails on the old behaviour and passes on the new**
    - CopyCompare.test.tsx › "after a put-back" has two tests. The first makes the compare reads slow on purpose and checks that the moment "Last put-back" appears, the counts, the row and the open record already say Same, the put-back record is unticked, and the refused one stays ticked with its reason. It also checks that nothing more is asked afterwards. The second checks that a failed put-back reads the screen again and keeps the ticks with why. CI was green on #2134. On the old code the first assertion after the banner should fail, because the old screen re-read only after showing the banner. I didn't run the test against the old code myself.

    Other: when I chose Close it on the opened copy, the browser console showed two 409 errors from compare reads that were still in flight as it closed. The screen showed nothing wrong. Noting it only.

    Clean-up: I closed the opened copy, deleted BKP-2 (typed BKP-2, now listed as Deleted 16:26), and deleted AST-67 and AST-68 again through the screens. The browser is closed.

    Screenshots (~/compass-uat/backup-and-restore/COM-2144/):
    - 01-before-both-missing.png
    - 02-first-put-back-banner-moment-list-scrolled.png: taken at the moment of the first banner, but the list was scrolled down so the banner is out of view. The watcher log above is the evidence for that moment.
    - 03-first-put-back-settled.png: banner 16:24, "1 missing", AST-67 Same, AST-68 Missing and unticked
    - 04-second-put-back-300ms-before-finish.png: the brief in-progress state described above
    - 05-second-put-back-finished.png: banner 16:25, "0 missing", both Same
    - 06-after-reload.png
- id: 01M8764E776R18RAE1VP02PPM3
  author: Steve Vine
  at: 2026-11-24T16:27:27.847009Z
  text: |-
    Merged: #2134, c7e9ad0d6, 24 Nov ~15:55 GMT. Frontend only. On staging c7e9ad0d6 since 16:20 GMT (deploy and Browser smoke 41/41 green). The re-check on staging passed; see the pre-UAT comment above.

    Cause: the screen declared a put-back finished as soon as it read that, and only then asked again for the counts and records, reusing any read already in flight. Fix: when a put-back ends (done or failed), the screen drops in-flight reads, rereads the counts, list and any open record, and only then shows it finished. Ticks follow the put-back whether the window is open or closed, and records not put back stay ticked with their reason.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Fix-forward on COM-2139/COM-2122, found in the pre-UAT pass on staging 0234a65f3 (screenshot `~/compass-uat/backup-and-restore/COM-2139/03-finished-list-still-says-missing.png`).

**Chain:** independent (frontend only, unless the fix needs an API change).

**What happened**

In Open to compare, the Admin ticked a deleted technology asset (AST-66) and its installed software, then chose Put back and stayed on the screen. The banner said "Last put-back: 2 records put back from BKP-1", but for 10–25 seconds afterwards the counts still read "Technology asset 1 missing" and the row still said Missing. The server already answered Same. An Admin could think it failed and tick it again.

**Done when**

- As soon as the banner says a put-back has finished, the area counts and every affected row reflect it, without a reload.
- Ticks for records that were put back are cleared, so they can't be put back twice by accident.
- A component test fails on the old behaviour and passes on the new.