---
id: 01KZXBW3F64CPQ9M687V1V4RWX
created: 2026-08-13T10:49:47.238578Z
updated: 2026-08-13T19:00:07.070336Z
type: task
title: 'Smoke: the graph''s group glyph and the application/Business Application look-alike'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 681
sprint: savn96w
assignee: steve
label:
- bug
priority: medium
task_status: done
tech: null
---
Two visual findings from Steve's smoke of the Collections sprint on staging, fixed forward in PR #632 (`1e31901`).

**1. The group node wore the tags glyph.** [ISE-678] gave `IconTags` to the Tags screen alone and put `IconCategory` on the Groups nav entry, but `TYPE_ICON` in `EntityGraphView.tsx` was not part of that change. One thing wearing two glyphs across the app is the same fault as two things sharing one, so the canvas now follows the nav.

**2. "Business Applications is a different colour."** The Business Application node was already grape — the type string is passed straight through from `entity.type`, and a new test compares the three Collections' rendered boxes against each other to prove it. What differs on staging is the `application` type: **100 of those against 2 Business Applications**, and the two deliberately shared `IconApps` ("the same shape of thing, told apart by who operates them"). That reasoning held while both drew as blue pills; since [ISE-680] one is a Collection and one is not, so the shared glyph made them read as one type drawn two colours. `application` now takes `IconAppWindow`.

**The test gap that let it through:** the type list the icon-uniqueness test walks was missing `business-application` entirely — which is exactly why two types sharing a glyph passed a test whose whole job is to refuse that. Added.

**Also worth keeping:** jsdom does no layout, but it *does* hold the inline style, so node shape and colour ARE testable after all — "the three Collections look alike, and an application does not" is now a unit test rather than something only staging could tell us. The earlier "judge it on the canvas" note was too pessimistic.