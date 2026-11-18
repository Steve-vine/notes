---
id: 01M7PVGENDYMKMQK9S97BYPNXH
created: 2026-11-18T08:13:56.269826Z
updated: 2026-11-18T10:07:10.647203Z
type: task
title: Ask Polaris offers Draft from this document and Draft from a description on a new flowchart that only has its Start shape
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1930
sprint: s6y6p7g
comments:
- id: 01M7PY13GSGGK5RX577RF2VZ6K
  author: Steve Vine
  at: 2026-11-18T08:57:59.065638Z
  text: |-
    Done — PR #1921, merged 4e160551.
    A new flowchart that only has its Start shape now counts as empty, by the same rule the imports use. Ask Polaris offers Draft from a description and, in a document, Draft from this document, as on an empty canvas. The draft replaces the lone Start without showing it as "removed".
    The sections to draft from are listed by their heading (or their opening words if they have no heading), not "main". Polaris is given the same names.
    A link Polaris couldn't match (e.g. ZZZ.99) now stays on the proposal's Left out line for the whole answer, even when Polaris proposes again without it. That second proposal is why it showed only in the chat summary before.
    To check on staging (needs Polaris): in a procedure, Insert ▸ Flowchart…, then Ask Polaris. Both drafts should be offered, with the sections named by their headings. Then ask for a link to ZZZ.99 and look for it on the Left out line.
- id: 01M7Q1ZSSQ3ZXDX7P3FVFXAWSM
  author: Steve Vine
  at: 2026-11-18T10:07:10.647004Z
  text: |-
    Pre-UAT on staging 27151cd9 — Passed
    As E2E Admin A, in E2E Test Company, on "E2E pre-UAT COM-1930 Start-only canvas" (a procedure with two sections). Polaris's AI was on.
    - A Start-only canvas offers both drafts: Insert ▸ Flowchart… opened a canvas holding only "Start". Ask Polaris offered "Draft from this document" and "Draft from a description", the same as on an empty canvas. Passed.
    - Sections listed by their headings: "Returning a laptop" (the section's heading) and "Records are kept for two years in the asset register." (a section with no heading, shown by its opening words). No "main". Passed.
    - Drafted and kept: with "Returning a laptop" ticked, Polaris proposed Line manager / Service Desk / Finance lanes with a "Damaged?" decision (9 steps added, nothing marked removed). Keep, then Done, put it in the document's draft. Passed.
    - Left out line: the panel showed "Left out, as nothing in Compass matched: Collect the laptop: control 'ZZZ.99': No control matches 'ZZZ.99'." Passed.
    Observation: on my first ask ("link Check it for damage to ZZZ.99, and Wipe the laptop to ACC.3"), Polaris didn't try ZZZ.99 at all. It knew from earlier in the chat that no such control exists, so the panel had no Left out line and ZZZ.99 was only in its summary and chat. The line appears when Polaris actually attempts the link. Screens re-04 and re-05.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1930/re-*
assignee: steve
label:
- bug
priority: high
task_status: review
---
Pre-UAT, 2026-11-18 (COM-1909):
- In a procedure with text, Insert ▸ Flowchart… then Ask Polaris. The canvas starts with a Start shape, so the panel offers only "Ask Polaris": neither Draft from this document nor Draft from a description appears.
- They only appear after the Start shape is deleted.
- The imports already treat a Start-only canvas as empty; Ask Polaris doesn't.
Screenshots: ~/compass-uat/s6y6p7g/COM-1909/11-draft-from-document-panel.png, 12-start-removed.png.

Also from the same pass:
- The section to draft from was labelled "main": it should use the section's own heading.
- A link Polaris left out (a made-up control, ZZZ.99) showed only in its chat summary. The panel's "Left out" line should list it.

**Done when**
- A new flowchart with only its Start shape offers Draft from this document (in a document) and Draft from a description, exactly as an empty canvas does. The rule for "empty" is the same one the imports use.
- The sections to draft from are listed by their headings.
- A link Polaris couldn't match is shown in the panel's Left out line.

Independent: frontend (plus the screen event if needed).