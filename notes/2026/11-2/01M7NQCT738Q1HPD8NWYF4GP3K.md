---
id: 01M7NQCT738Q1HPD8NWYF4GP3K
created: 2026-11-17T21:42:48.291201Z
updated: 2026-11-17T21:44:41.266773Z
type: task
title: 'A flowchart on its own: a new kind of Content with its own page, versions and reviews'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1907
sprint: s6y6p7g
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Builds on COM-1906. Steve, 2026-11-17: a flowchart can be a piece of Content in its own right, as well as part of a document (ADR 0160, COM-1903).

**What people see**
- **Create ▸ Flowchart** in Content, next to the existing kinds of document. A flowchart has a title, a content type (e.g. Process or Procedure, whatever types the organisation uses), an owner, a domain and a review cycle, as any document does.
- **Its page** shows the flowchart large, with zoom, pan and full screen, using the same canvas for editing (COM-1904/1905/1906: shapes, lanes, links). Under it, a short description and the plain-text steps.
- **Same lifecycle as any document:** draft, Publish, versions with Compare versions, Revert, review cycle and Mark as reviewed (ADR 0149: a review is always of a published version), linked controls, attestations (people can be asked to read and accept it), the activity log, and the Content lists and filters. A flowchart reads "Flowchart" wherever a document's kind is shown.
- **Search** finds a flowchart by its title, step labels, lane names and descriptions.
- **Export:** PDF and Word give the flowchart on its own, with the house style's title page and its Links list (COM-1906). Plain text gives its steps.
- **Links into it:** a step's Links (COM-1906) and a Hand-off can now point at a standalone flowchart.
- **Deleting:** a flowchart that's never been published can be deleted as any draft can. Rules for a flowchart that a document shows arrive with COM-1908.

**Done when**
- An author can create, edit, publish, revert and review a standalone flowchart, and compare its versions in words (steps added, removed, reworded, moved lane, links changed).
- It shows in the Content lists, search, attestations and the activity log like any document, and its PDF, Word and plain-text exports work.
- A step in another flowchart can link to it.

On the chain: a new kind of Content (a migration) and API changes.