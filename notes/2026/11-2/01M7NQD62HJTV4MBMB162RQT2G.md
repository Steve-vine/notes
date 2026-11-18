---
id: 01M7NQD62HJTV4MBMB162RQT2G
created: 2026-11-17T21:43:00.433424Z
updated: 2026-11-18T06:01:42.372163Z
type: task
title: 'Show a standalone flowchart in a document: the document keeps its version until the owner accepts a newer one'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1908
sprint: s6y6p7g
blocked_by:
- 01M7NQCT738Q1HPD8NWYF4GP3K
comments:
- id: 01M7PKY9Y6JNR0YZSE0V0HSW5M
  author: Steve Vine
  at: 2026-11-18T06:01:41.574205Z
  text: |-
    Done — PR #1910, merged 731a7d17.
    In a document's editor, Insert ▸ An existing flowchart… picks a published standalone flowchart. The document shows that version, "<title>, version N", with a link to its page. It can't be edited from the document.
    Publishing a new version changes no document. Instead the document's owners get an action, "<flowchart> has a newer version (N) than <document> shows (M)". It opens both versions side by side with what changed: Take version N puts it into the document's draft (published or marked as reviewed as usual), and Keep version M quietens the action until the next version.
    Compare versions of the document says "Flowchart <title>: version M → N" and what changed in it. The flowchart's page lists where it's Shown in, at which version, and whether that's the latest.
    Delete is refused while a published document shows the flowchart, naming those documents. Drafts that show a deleted flowchart read "Flowchart deleted".
    On a document's own flowchart, Make it a standalone flowchart creates a draft standalone flowchart. The document keeps its own copy, with a note, until that is published, and then shows it.
    The standalone flowchart also gets Import from… on Create ▸ Flowchart, Download PNG/SVG, and Page: Portrait / Landscape for its PDF and Word.
    Assumptions: a document's owners are its reviewers. The action follows the document's draft, so it goes as soon as a version is taken.
    To check on staging: publish a standalone flowchart, show it in a document, publish both, then republish the flowchart. The document's owner should get the action. Try Take, Keep and Delete there.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Builds on COM-1907. Steve, 2026-11-17: a document shows the version of a flowchart it was published with, until its owner accepts the newer one (ADR 0160, COM-1903).

**Placing one**
- In a document's editor, **Insert ▸ Flowchart ▸ An existing flowchart** picks a published standalone flowchart. The document shows its **latest published version**, labelled "<title>, version N" with a link to the flowchart's page. It can't be edited from inside the document. **Open the flowchart** goes to its page.
- A draft flowchart that has never been published can't be placed.

**When the flowchart moves on**
- Publishing a new version of a flowchart doesn't change any document. Each document still shows the version it had.
- The owner of each document showing an older version gets an **action**: "<flowchart> has a newer version (N) than <document> shows (M)". The action opens a side-by-side Compare versions of the flowchart.
- **Take version N** puts the newer version into the document's draft. That's an ordinary change: the owner publishes it, or uses Mark as reviewed (ADR 0149). **Keep version M** dismisses the action until the next new version.
- A reviewer's Compare versions of the document shows "Flowchart <title>: version M → N" and the flowchart's own differences.

**The flowchart's page**
- **Shown in** lists every document showing it, which version each shows, and whether that's the latest.

**Turning a document's own flowchart into a standalone one**
- On a document's own flowchart (COM-1904), **Make it a standalone flowchart** creates a new standalone flowchart from it, as a draft owned by the person doing it. The document then shows that flowchart once it's published. Until then the document keeps its own copy, and the action says so.

**Deleting**
- A flowchart that any published document shows **can't be deleted**. Delete is refused, with the list of those documents. A flowchart shown only in drafts warns before deleting, and those drafts get a "flowchart deleted" placeholder in its place.

**Done when**
- A document can show a standalone flowchart and keeps that version after the flowchart is republished.
- The document's owner gets the action, Take puts the new version in the draft, and Keep dismisses it.
- Shown in lists the documents and the version each shows.
- A document's own flowchart can be made standalone.
- Deleting a flowchart a published document shows is refused, with the reason.

On the chain: a document records which flowchart version it shows (a migration), a new action source, and API changes.