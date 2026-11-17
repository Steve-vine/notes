---
id: 01M7NQCFPN3J6MAF8T53B8BTZ6
created: 2026-11-17T21:42:37.525915Z
updated: 2026-11-17T21:42:37.525915Z
type: task
title: 'Flowchart steps link to Compass: a control, a document or a role, and a control shows the flows it appears in'
priority: medium
task_status: todo
label: feature
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1906
---
Builds on COM-1905. The governance value of a flowchart: its steps point at the controls they carry out and the documents they follow.

**What the author sees**
- A selected step (any shape except Note) has a **Links** panel. It can link to:
  - **controls** from the control library, by ID or name;
  - **documents**: any piece of Content (a runbook, a procedure, and later a standalone flowchart, COM-1907);
  - **a business role**, kept by name, as a lane is (COM-1905).
- A step can have several links. A **Hand-off** step links to the flow it hands off to, either a document or (once COM-1907 lands) a standalone flowchart.
- A linked step shows a small marker on the canvas and in the published picture, so readers can see it leads somewhere.

**What a reader sees**
- Clicking a linked step shows its links, and each one opens its item. A role opens that company's role of that name, or reads as plain text where there's none, as in COM-1905.
- A link to something since deleted reads "<name> (deleted)" and opens nothing. The author sees it flagged in the editor.
- PDF and Word can't be clicked, so each linked step gets a small number. A **Links** list beneath the flowchart gives each number's controls and documents by ID and name.

**On the control's page**
- The control's existing list of the documents that cover it gains **Flowcharts**: each published flowchart with a step linked to this control, the document it's in, and the step's name. Drafts don't count until they're published.
- Polaris can answer "which flows carry out IMA.4?"

**Done when**
- Steps can link to controls, documents and roles, and readers can follow those links in Compass.
- A deleted target shows as deleted.
- PDF and Word list the links beneath the flowchart.
- A control lists the published flowcharts whose steps link to it, and a draft link doesn't appear until it's published.

On the chain: published links are recorded so a control can list them (a migration), and the control's API gains them.