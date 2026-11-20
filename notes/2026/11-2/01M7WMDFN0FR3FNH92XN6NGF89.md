---
id: 01M7WMDFN0FR3FNH92XN6NGF89
created: 2026-11-20T14:05:25.536206Z
updated: 2026-11-20T14:07:29.18205Z
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