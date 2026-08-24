---
id: 01KYSWTRE97AVAK2NJBVH7XPKS
created: 2026-07-30T16:14:21.466261Z
updated: 2026-08-05T07:40:26.864701Z
type: task
title: Scrolling bug in Search tab
project: 01KY6W9951TW0904DT0GGJVGE7
number: 382
sprint: segj1dz
comments:
- id: 01KZ1B34AFEHHSEY5F69WCWRPH
  author: Steve Vine
  at: 2026-08-02T13:37:24.81449Z
  text: |-
    Fixed on branch sprint-35 (commit 50f545c).

    Root cause: the app is a fixed-viewport desktop shell (.shell is 100vh), but html/body in theme.css had no height/overflow lock. On macOS, reaching the end of an inner scroller (a long note opened in the Search overlay) rubber-bands the whole document — dragging the view up so the top tabs scroll off and empty space shows at the bottom. It's most visible on Search because that's where a long note gets opened over the results, but the leak was global.

    Fix:
    - theme.css: html, body { height: 100%; overflow: hidden; overscroll-behavior: none } so only inner containers scroll and the document can't rubber-band.
    - NotePane .content: overscroll-behavior: contain as a targeted backstop against scroll-chaining when you hit the end of a long note.

    Verified: npm run check passes (0 errors, 0 warnings). CSS-only change — no logic touched.

    Note: I can't do a screen-capture visual pass here, so please confirm the scroll behaviour looks right in the app (Search tab, open a long note, scroll to the bottom). Moving to Review.
- id: 01KZ8DTEQKEMP5AZ66XZ9MY5TN
  author: Steve Vine
  at: 2026-08-05T07:39:47.313365Z
  text: 'Shipped: PR #374, released in 0.13.0. Moving to Done.'
assignee: steve
priority: medium
task_status: done
---
On the search tab, if I open a note that’s longer than the display size can show, when I scroll to the bottom the whole window scrolls up slightly as I hit the end, the top of the tabs is lost  and some extra content appears at the bottom.  Example screenshots attached, first one showing view at the top of the note and second showing what happens when scrolling to the bottom.

![CleanShot 2026-07-30 at 17.12.52.png](attachments/2026/07/01KYSWTRE97AVAK2NJBVH7XPKS/CleanShot-2026-07-30-at-17.12.52.png)

![CleanShot 2026-07-30 at 17.14.02.png](attachments/2026/07/01KYSWTRE97AVAK2NJBVH7XPKS/CleanShot-2026-07-30-at-17.14.02.png)