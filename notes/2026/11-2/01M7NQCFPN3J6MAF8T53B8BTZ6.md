---
id: 01M7NQCFPN3J6MAF8T53B8BTZ6
created: 2026-11-17T21:42:37.525915Z
updated: 2026-11-18T08:14:02.008269Z
type: task
title: 'Flowchart steps link to Compass: a control, a document or a role, and a control shows the flows it appears in'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1906
sprint: s6y6p7g
blocked_by:
- 01M7NQC2KVK2HH9J55CGGSJ26F
comments:
- id: 01M7PEKS7M9VNZARPXR9VQGEVK
  author: Steve Vine
  at: 2026-11-18T04:28:33.908313Z
  text: |-
    Done — PR #1904, merged e01cb172.
    A selected step on the canvas has a Links panel: link controls (search by ID or name), documents (a Hand-off asks "Hands off to"), and business roles (picked from the selected company's, or typed). A step can have several.
    A linked step shows a small number on the canvas and in the picture. Readers click it to see its links; each opens its item. A role opens the company's role of that name, or reads as plain text with the note, as lanes do.
    A link to a control or document since deleted reads "<name> (deleted)" and opens nothing; in the editor the step's number turns red and the link is flagged.
    PDF and Word list the links beneath the flowchart, by each step's number.
    On a control's page, Linked content (and the Evidence tab's document list) now shows Flowcharts: each published flowchart with a step linked to the control, the document it's in, and the steps. A draft's links appear only once it's published. Polaris reads these, so it can answer "which flows carry out IMA.4?".
    Assumptions: linked steps are numbered in the order they were drawn; nothing needed filling in for existing documents, as flowcharts arrive in this release.
    To check on staging: link a step to a control and publish, then open that control's page; delete (or link to) a test document to see "(deleted)". COM-1907 (lane D) adds recording a standalone flowchart's own links when it merges.
- id: 01M7PVGM8RZ07N5XF1068NZKPQ
  author: Steve Vine
  at: 2026-11-18T08:14:02.008034Z
  text: |-
    Pre-UAT on staging faf46f33 — Failed (the Viewer role defect from COM-1905; everything else passed)
    Same document as COM-1904, as E2E Admin A, plus a throwaway "E2E pre-UAT COM-1906 linked document (to delete)", now deleted.
    - Steps link to controls, documents and roles, and readers can follow them: Passed as Admin A, Failed for role links as a Viewer.
      - Links I made: "Do the work" → IMA.4 and the role E2E Starter. "Write up the change" → the throwaway document and IMA.5. "Receive the request" → a typed role, "Service Desk". The Hand-off → "Joiners, movers and leavers procedure" through "Hands off to".
      - Linked steps show numbers 1–4 on the canvas and in the picture. In the Read tab, clicking a number lists its links. IMA.4 opened /controls/IMA.4, E2E Starter opened the role page, and the documents open.
      - "Service Desk" reads as plain text with the hover note "No business role called Service Desk in E2E Test Company" (05-step1-role-note.png).
      - As E2E Viewer, the "E2E Starter" link is plain text with that same false note, because the Viewer's request for business roles gets 403 (see the COM-1905 defect).
    - A deleted target shows as deleted: Passed. After I deleted the throwaway document, step 3's popover reads "E2E pre-UAT COM-1906 linked document (to delete) (deleted)" and isn't a link (07-deleted-link.png). In the editor the step's number is marked broken, and the panel shows "(deleted)" (08-editor-flags-deleted.png).
    - PDF and Word list the links beneath the flowchart: Passed. Both have a "Links" list after the caption: "1. Receive the request — Role Service Desk", "2. Do the work — Control IMA.4 …; Role E2E Starter", "3. Write up the change — Document …; Control IMA.5 …", "4. Hand off … — Document Joiners, movers and leavers procedure". The plain text has a "Links:" line under each step (COM-1905/v2.*).
    - A control lists published flowcharts, not draft links: Passed. While the links were only in the draft, IMA.4 ▸ Evidence ▸ Managed Content showed no flowcharts (03-control-before-publish.png). After I published, it showed "FLOWCHARTS — E2E pre-UAT request flow — E2E pre-UAT COM-1904 flowchart document / Step: Do the work", linking to the document (04-control-after-publish.png). The control's Overview tab has no "Linked content" section, so I found the list only on the Evidence tab.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1906/
assignee: steve
label:
- feature
priority: medium
task_status: review
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