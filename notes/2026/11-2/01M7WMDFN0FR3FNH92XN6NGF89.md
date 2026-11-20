---
id: 01M7WMDFN0FR3FNH92XN6NGF89
created: 2026-11-20T14:05:25.536206Z
updated: 2026-11-20T14:05:31.955195Z
type: task
title: A standalone flowchart in a document shows its latest published version, with an option to pin an older one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2027
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Steve (testing round 3): after editing a standalone flowchart and publishing it, the document it's linked in still shows version 1 of the chart. Underneath it says "Version 3 is published", but there's no way to change the chart to version 3. By default, a document should always show the flowchart's latest published version, with an option to pin it to an older version if needed.

**Done when**
- A standalone flowchart added to a document follows its latest published version by default. Publishing a new version of the flowchart updates what the document shows, with no change needed in the document.
- The flowchart's settings in the document (the right-hand panel) show which version is shown: "Latest published (version N)" or "Pinned to version N". The panel lets a person pin it to any published version, or set it back to latest.
- When it's pinned and a newer version exists, the note under it says so and offers "Use latest".
- Assumption: flowcharts already in documents switch to following the latest, since none was deliberately pinned.
- Read tab, Edit tab, print, PDF and Word all show the same version.
- Tests cover following the latest after a new publish, pinning an older version, and unpinning.

**For Steve before building:** a published document is what gets reviewed and attested to. If its flowchart follows the latest version, the published document's diagram changes without the document being published again. Options:
- (a) The published document shows the flowchart's latest version live.
- (b) The draft follows the latest, and the published document keeps the version that was current when the document was last published. A new flowchart version then shows "updated flowchart, publish to include" on the document.