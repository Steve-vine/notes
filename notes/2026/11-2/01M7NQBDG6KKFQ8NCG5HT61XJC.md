---
id: 01M7NQBDG6KKFQ8NCG5HT61XJC
created: 2026-11-17T21:42:02.502876Z
updated: 2026-11-18T02:30:59.930703Z
type: task
title: 'Decision record: flowcharts in Content (ADR 0160)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1903
sprint: s6y6p7g
assignee: steve
label:
- brief
priority: medium
task_status: active
---
Steve, 2026-11-17: Content gets flowcharts. This task writes the decision down so the rest of the sprint builds to it. Number 0160 is the next free one after 0159 (COM-1897); take the next free number if it has gone.

**What the record says**
- **Two places a flowchart lives.** A document can have its own flowchart, published and reviewed with it. A flowchart can also be a piece of Content in its own right, with its own page, and documents can show it. A document's own flowchart can be turned into a standalone one.
- **Built on a canvas.** People drag standard shapes and connect them, and Compass keeps the layout tidy. There's no text syntax to learn. Today's freehand drawings and text diagrams stay as they are, beside flowcharts.
- **A standalone flowchart behaves like any document.** It has an owner, a review cycle, drafts and publishing, versions, linked controls, attestations and search. It belongs to the shared playbook, like all Content.
- **A document keeps the flowchart version it was published with.** When a newer version is published, the document's owner gets an action. Taking the newer version is an ordinary change to the document (publish, or Mark as reviewed under ADR 0149), so a reviewed document never changes behind its reviewer's back.
- **Swimlanes** can be any name (e.g. "Customer"), or a business role. A role is kept per company, so a lane naming a role opens that company's role of that name, and reads as plain text where the company has none.
- **Steps can link** to a control, a document, another flowchart or a role. A control shows the published flowcharts it appears in. Drafts don't count.
- **Polaris** can draft a flowchart, change one and explain one, working on drafts under the same rules as other Content.
- **Pictures and imports.** Flowcharts download as PNG/SVG and appear in PDF and Word exports. They can be imported from draw.io, Lucidchart (its CSV export) and today's text diagrams. An import says what it couldn't carry over.
- **Deleting.** A flowchart that a published document shows can't be deleted. Compass says which documents show it.
- A flowchart's plain-text form is its steps in order, with who does each and where each branch goes. Search, Polaris and the plain-text export all use it.

**Done when**
- The record is accepted and listed in CLAUDE.md's key ADRs.
- It cites ADR 0110 (Compass writes its own documents) and ADR 0149 (a review is of a published version) where it builds on them.

Independent: no migration, no API change.