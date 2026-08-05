---
id: 01KZ3YRQB11YWXV5QABPB92A9G
created: 2026-08-03T13:59:44.225192Z
updated: 2026-08-05T12:31:47.557198Z
type: task
title: Estate graph
project: 01KX671DATY39VW6GWK3M2T3DN
number: 515
order: 4.0
sprint: skxht3g
comments:
- id: 01KZ453ZM09K0203J4FEJP6NKT
  author: Steve Vine
  at: 2026-08-03T15:50:44.60879Z
  text: |-
    Done in PR #440 (feature/ise-515-graph-node-legibility). All three parts of the ticket.

    **Icons.** Root cause: `workload` and `other` had no entry in the type→icon map at all, so both fell through to the same fallback — hence 'Other' drawing as a workload. Every one of the 19 entity types now has its own glyph, and a type this build has never heard of draws a question mark rather than quietly borrowing someone else's. A test asserts the map has no duplicates across all 19, so a future entity type can't silently reintroduce this.

    Two knock-on choices while I was in there: `group` and `identity-group` also shared a glyph, so `group` (a tag-derived lens, ADR 0037) takes a tag icon and the people icon goes to `identity-group`, which is a real directory object. And `service` (DataDog's APM view) takes a signal icon — it's a way of watching something, not a thing you can point at.

    **Two lines.** The type now has its own line under the name, as you asked. It previously existed only in the hover title, which is why identifying a node meant pointing at it. The env tag and "+N folded" count sit alongside the type on that second line.

    **Zoom.** Yes, this is possible, and the reason it didn't already work is worth stating: React Flow scales the pill and its text by the same factor, so zooming in made everything bigger and the same words stayed clipped — hovering was the only way to read a long name. The font now shrinks in *flow* units as zoom grows, so it stays the same size on screen while the pill grows around it, and more of the name actually fits. The name also un-clamps from 1 to 2 to 3 lines as you zoom in. It's clamped at both ends: never larger than the designed size when zoomed out (the label would swamp the node) and never below a third (past that the glyphs are sub-pixel and extra characters buy nothing).

    This one is visual, so the tests cover the logic but the look really wants your eye on staging — particularly whether the second line reads well at default zoom and whether the shrink rate feels right as you zoom.

    Full frontend suite green (542), build, eslint and prettier clean.
- id: 01KZ4704MQCA0TAGH489XPKRJ8
  author: Steve Vine
  at: 2026-08-03T16:23:35.831362Z
  text: |-
    RELEASED to main 2026-08-03 (PR #440 merged, main 7dfff2c, no migration). Staging smoke passed and staging reset to main.

    Includes the follow-up fix you caught: 'Other' was still drawing a cube. My first attempt gave `workload` IconCube and left `other` on IconBox — two distinct components that render as near-identical cube outlines, so the uniqueness test passed (it compared component identity) while the canvas was unchanged. 'Other' now draws a puzzle piece. Added a look-alike guard that refuses known-confusable pairs by icon name, verified by reintroducing the bug and watching it fail.

    Lesson recorded: a test asserting "these icons are different objects" says nothing about whether they look different, and looking different is the only thing that mattered here.
assignee: steve
priority: medium
task_status: done
---
In the estate graph, ‘Other’ category has the same icon as workload, ensure that all categories have different icons so they can be differentiated.

The working on the entity pills often doesn’t contain enough information so I have yo hover over them to get the info.  Is it possible to change the size of the text as it zooms in so that as the pills get larger, more text can be fitted on the?
Also make these 2 lines, with the first line being the name and the second the type.