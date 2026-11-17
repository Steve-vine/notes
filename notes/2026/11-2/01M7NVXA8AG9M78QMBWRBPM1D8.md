---
id: 01M7NVXA8AG9M78QMBWRBPM1D8
created: 2026-11-17T23:01:43.306579Z
updated: 2026-11-17T23:02:15.601044Z
type: task
title: 'Polaris and the Library: find documents by folder, file them, arrange folders, write summaries and tags'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1923
sprint: s2q1gxe
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Polaris, in Compass and over the Playbook MCP address, can use the Library the way a person can, with exactly that person's rights. Built on COM-1916, COM-1917 and COM-1920.

**Anyone who can see Content can ask**
- "What's in the PCI DSS folder?" — the folder's subfolders and documents, with paths and links to the Library.
- "Find our documents about ransomware" — Library search (COM-1920), same ranking, published versions only.
- "Where does the Access Control Policy appear?" — every folder it's in.
- "What isn't filed yet?" — Not in a folder.

**People who can edit Content can also ask**
- "Make a folder called Cloud under Information security", rename, describe, recolour, move and reorder folders.
- "Put every PCI-tagged document in the PCI DSS folder" — Polaris lists what it will file and asks before filing more than a handful at once.
- "Delete the Old folder" — Polaris says what goes with it (COM-1916 wording) and asks first.
- "Write summaries and tags for the documents that have none" — Polaris drafts them from each published version and saves them when the person agrees, as COM-1917's Suggest with Polaris does on screen.

**Rules**
- Everything Polaris changes is in the activity log as made by the person, via Polaris.
- Nothing Polaris does publishes a document or changes its text.
- Playbook stays under its 128-tool limit for Copilot (ADR 0144): fold the Library into as few tools as possible.

**Done when**
- Each question above works on staging through the Playbook MCP address and in Compass's Ask Polaris, as a reader and as a Content editor.
- A reader's request to change folders is refused with the reason.
- The Playbook area's tool count is under the limit, and Polaris's instructions mention the Library.

On the chain: adds Polaris tools and changes the API they call.