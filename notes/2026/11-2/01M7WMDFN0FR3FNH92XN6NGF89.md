---
id: 01M7WMDFN0FR3FNH92XN6NGF89
created: 2026-11-20T14:05:25.536206Z
updated: 2026-11-21T08:09:43.511489Z
type: task
title: A standalone flowchart in a document shows its latest published version, with an option to pin an older one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2027
sprint: s6y6p7g
comments:
- id: 01M7WT2N0GTKPN27DMD101RYF7
  author: Steve Vine
  at: 2026-11-20T15:44:22.031894Z
  text: |-
    Done — PR #2019, merged 1256f3e7.
    - A standalone flowchart in a document now follows its latest published version. When the flowchart is published again, the document's Edit tab and Print preview show the new version straight away.
    - The published document keeps the version it was last published with. That covers its Library reading, portal, PDF and Word of the published version, reviews and attestations. The content page's Read tab also draws the flowchart as published.
    - Until the document is published again it says "Updated flowchart (version N): publish the document to include it". It shows "draft changes" and can't be reviewed until it's published. Its owner gets an action, "Publish <document> to include the updated flowchart". Publishing takes the new version in, and Compare versions shows the change.
    - The flowchart's settings panel has a Version field: "Latest published (version N)", or "Pinned to version N" for any published version. Pinning and unpinning are draft changes, published with the document, and Compare shows them. When a pinned one has a newer version, the note under it says so and offers "Use latest", as the panel does.
    - Discarding a draft can't take a document back to an older flowchart unless it's pinned.
    - Polaris can pin a version when adding a flowchart to a document. Reading a document, it says whether each flowchart follows the latest or is pinned.
    Assumptions: flowcharts already in documents now follow the latest. Their drafts moved on when this was deployed, and their published versions are unchanged. The content page's Read tab still shows the working draft's text, as before, but its standalone flowcharts as published.
    To check on staging: open a document that shows a standalone flowchart, publish a new version of the flowchart, then go back to the document. The Edit tab should show the new version and the note, and the Read tab the old version. Then publish the document. Pin to an older version in the settings panel, publish the flowchart again, and check the pin holds and "Use latest" is offered.
- id: 01M7WXKVRCSTPJJZ6216PM509F
  author: Steve Vine
  at: 2026-11-20T16:46:11.724334Z
  text: |-
    Pre-UAT on staging b65d7ed8: Passed
    Tested as E2E Admin A (the owner and reviewer) and E2E Viewer, in E2E Test Company. I used my own headless Chromium, and the API for setup and checks. I made "E2E pre-UAT COM-2027 follow-me flowchart" (Process) and "E2E pre-UAT COM-2027 document". The step label changed in each flowchart version ("Version one step", then two, three and four), so you can tell the versions apart in every picture.
    - Follows the latest by default: Passed. I published flowchart v1, added it with Insert ▸ An existing flowchart…, and published the document. It was saved as following, not pinned. The Version field in the settings panel read "Latest published (version 1)", with the hint "Moves on each time the flowchart is published".
    - Edit tab shows the new version straight away: Passed. I published flowchart v2. When I next opened the Edit tab it showed the v2 picture, captioned "…version 2", with the note "Updated flowchart (version 2): publish the document to include it". The status read "Published · draft changes" and Review… was disabled with the "unpublished changes" tooltip. An Edit tab already open during the flowchart's publish stays on v3 until reloaded. Typing in it and saving didn't put v3 back: the draft stayed on v4.
    - Published document keeps its version: Passed. The Read tab drew v1. The Library reading pane, as Viewer, drew v1 with "(version 2 is published)". The PDF and Word of published version 1 both have the v1 picture ("Version one step"). Print preview and the draft's Word export have v2, the same as the Edit tab. Later, version 3 of the document (pinned to v1) still printed v1, and version 4 printed v3.
    - Note, unpublished changes, action, publish takes it in, Compare: Passed. Admin A got the action "Publish E2E pre-UAT COM-2027 document to include the updated flowchart … (version 2)", in the Actions list, opening the Edit tab. Publishing the document gave the Read tab v2, no note, and the action went. Compare v1→v2 says "Flowchart …: version 1 → 2" and "Step reworded: 'Version one step' → 'Version two step'", with the diff line.
    - Version field in the settings panel: Passed. The choices were "Latest published (version N)" and "Pinned to version N" for every published version. Choosing "Pinned to version 1" turned the picture into v1, showed "Stays on this version until you choose another" and made it a draft change. Publishing it, Compare v2→v3 says "pinned to version 1" and "version 2 → 1". Pinning to v3 and picking Latest published again unpinned it. Compare v3→v4 says "follows its latest published version" and "version 1 → 3".
    - Pinned, newer version, Use latest: Passed. With the pin on v1 I published flowchart v3. The draft and the published document stayed on v1, with no draft changes. The note read "Pinned to version 1. Version 3 is published. Use latest", the panel offered Use latest, and the owner got the "Take or keep the new version" action rather than the publish one. Use latest in the note gave v3, followed again, and swapped the action for "Publish … to include … (version 3)". Use latest in the panel did the same after I pinned to v2.
    - Existing flowcharts switched to following: Passed. Three E2E documents now show "draft changes", with their drafts moved on and their published versions unchanged (see the report).
    - Draft = print preview; published Read = PDF = Word: Passed, as above.
    - Tests: not checked here (CI).
    Screenshots and exports: ~/compass-uat/s6y6p7g/COM-2027/ (r4-*)
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Steve (testing round 3): after editing a standalone flowchart and publishing it, the document it's linked in still shows version 1 of the chart. Underneath it says "Version 3 is published", but there's no way to change the chart to version 3. By default, a document should always show the flowchart's latest published version, with an option to pin it to an older version if needed.

**Decided (Steve, 20 Nov): option (b).** The document's draft follows the flowchart's latest published version. The published document keeps the version that was current when the document was last published, so what was reviewed and attested to never changes underneath it.

**Done when**
- A standalone flowchart added to a document follows its latest published version by default.
- On the document's Edit tab (the draft), the latest published version of the flowchart shows straight away after the flowchart is published.
- The published document (the Read tab for readers, its PDF, Word, reviews and attestations) keeps showing the flowchart version that was current when the document was last published.
- When a newer flowchart version exists than the one in the published document, the document says so, e.g. "Updated flowchart (version 3) — publish the document to include it". The document then has unpublished changes. Publishing the document takes in the new version, and compare-versions shows the change.
- The flowchart's settings in the document (the right-hand panel) show which version is in use: "Latest published (version N)" or "Pinned to version N". The panel lets a person pin it to any published version, or set it back to latest. Pinning or unpinning is a draft change, published with the document.
- When it's pinned and a newer version exists, the note under it says so and offers "Use latest".
- Assumption: flowcharts already in documents switch to following the latest, since none was deliberately pinned. Their published documents keep what they show now until next published.
- The draft view and print preview show the same version, and the published Read tab, PDF and Word show the same version as each other.
- Tests cover following the latest after a new flowchart publish (draft updates, published document doesn't until republished), pinning an older version, and unpinning.