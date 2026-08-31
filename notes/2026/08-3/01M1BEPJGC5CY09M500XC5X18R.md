---
id: 01M1BEPJGC5CY09M500XC5X18R
created: 2026-08-31T08:24:32.003672Z
updated: 2026-08-31T16:38:27.28683Z
type: task
title: Bulleted lists style
project: 01KY6W9951TW0904DT0GGJVGE7
number: 412
sprint: segj1dz
comments:
- id: 01M1CAZ172K1Y0B320K79SNEGK
  author: Steve Vine
  at: 2026-08-31T16:38:12.961042Z
  text: |-
    PR #407 (brief-412-bulleted-lists-style).

    Cause: a Live list line got the read view's 1.4rem indent and then drew the bullet inside it, so the bullet sat where Read puts the text and a wrapped line came back under the bullet instead of under the item's text. Read uses list-style: outside — the marker hangs in the ul padding and every line of the item starts on the same column.

    Fix: non-task list lines get text-indent -1rem on top of that padding, and the bullet widget becomes the marker box it reserves — fixed 1rem width, glyph right-aligned against the text column, swallowing the source space after the mark. Task items keep the flat indent (Read's own list-style: none exception puts the checkbox in the text column), and a list inside a quote or callout drops the hang with the indent it borrows.

    Measured against Read in a lab: bullet, ordered and task items now all sit on Read's 37px text column and wrap onto it (bullets were 48px first line / 37px wrap before). Also checked with the caret on the line, inside a blockquote, and three levels deep.

    Known remaining difference (pre-existing, not touched): nested items are indented by their source whitespace in Live and by nesting depth in Read, so level 2+ sits shallower in Live. Fixing that means hiding the source indentation and indenting by depth, which trades a jump when the caret enters the line — say the word and I'll raise it as a follow-up.
assignee: steve
priority: medium
task_status: review
---
Bulleted lists have a formatting issue in Live view...
![CleanShot 2026-08-31 at 09.23.00@2x.png](attachments/2026/08/01M1BEPJGC5CY09M500XC5X18R/CleanShot-2026-08-31-at-09.23.00@2x.png)

In Read view they look OK...
![CleanShot 2026-08-31 at 09.24.42@2x.png](attachments/2026/08/01M1BEPJGC5CY09M500XC5X18R/CleanShot-2026-08-31-at-09.24.42@2x.png)
Fix the live view so it looks like the read view.