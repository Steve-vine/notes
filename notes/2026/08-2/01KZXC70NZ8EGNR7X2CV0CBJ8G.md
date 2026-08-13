---
id: 01KZXC70NZ8EGNR7X2CV0CBJ8G
created: 2026-08-13T10:56:08.131631Z
updated: 2026-08-13T11:12:59.135467Z
type: task
title: Collections in Estate
project: 01KX671DATY39VW6GWK3M2T3DN
number: 682
sprint: savn96w
comments:
- id: 01KZXD1J0M8MY08AWCBHN89TW6
  author: Steve Vine
  at: 2026-08-13T11:10:14.548108Z
  text: |-
    Fixed forward in PR #633 (9e44e15), deployed to staging.

    Diagnosis from the screenshots: chinwag.prod.uk is not a different kind of node — it is the node the graph is ROOTED on. The root's colour was forced to gray ("you are here" written in hue) and that overrode its Collection grape. Both entities are business-application; the bold label in both images is the other root cue.

    Fix: colour now says KIND, always — for the root too. Focus is said the other way: a gray ring set off the node (an outline, not another shadow, so it composes with the severity glow), plus the heavier border, bolder label and darker fill the root already had. Test asserts a BA-rooted graph draws root and sibling in the same hue and shape, with the ring and bold weight only on the root.

    Second image — the root unaffected by Collapse collections: that one is deliberate and stays. Every node in the response hangs off the root, so folding it would fold the entire canvas into a single box; the three folded counts you can see (+77, +31, +1) would all disappear into the uk node. Collapse is for putting a branch away, and the root is not a branch — it is what you are looking into. That reasoning is now a comment where the fold happens so it does not get "fixed" later. If you would rather have a genuine "collapse everything", say so and it becomes a different control rather than this one.

    Root cause worth noting: this was pre-existing (rooting on a group did the same), invisible until colour started carrying meaning.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Uncollapsed
![CleanShot 2026-08-13 at 11.55.17.png](attachments/01KZXC70NZ8EGNR7X2CV0CBJ8G/CleanShot-2026-08-13-at-11.55.17.png)

Collapsed
![CleanShot 2026-08-13 at 11.55.56.png](attachments/01KZXC70NZ8EGNR7X2CV0CBJ8G/CleanShot-2026-08-13-at-11.55.56.png)