---
id: 01M7X86QAR4TB98Y4NTZY0FCFP
created: 2026-11-20T19:51:15.544996Z
updated: 2026-11-20T19:51:15.544996Z
type: task
title: 'The Add evidence window: Add new evidence tab (drop files or a web address, check each one''s details, upload)'
priority: medium
task_status: todo
label: feature
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2041
---
Built to the ADR in COM-2038, after COM-2040. Steve's design (2026-11-20). This task builds the window and its first tab. The second tab is COM-2042, and putting the button in each place is COM-2043 to COM-2045.

**The button and the window**
- One **Add evidence** button, the same everywhere Compass asks for evidence. It opens a large window, nearly the full size of the screen, titled with where the evidence is going ("Add evidence to RIM.9", "Add evidence to SAP-14 Renew cyber insurance").
- Two tabs: **Add new evidence** (opens first) and **Link existing evidence** (COM-2042).
- The window shows the people the evidence is for only what they may add there. Without the right to add, there's no button.

**Add new evidence tab**
- **A drop box:** drag files into it, or click it to open the file chooser (several files at once).
- **A web address box:** paste an address and add it. It joins the list like a file (ADR 0122 web-address evidence).
- **The list on the left:** every file and address added so far, with its name and size (or address). The first one is selected. A file can be taken off the list before uploading. A row that's still missing something required (the evidence type) carries a marker, so it's clear what's left to do.
- **Properties on the right**, for whichever row is selected. Steve clicks through each one; there's no editing several at once.
  - **Name:** the file name, which can be changed. For an address, a title, defaulting to the address.
  - **Evidence type:** from the Evidence types rubric. It's required.
  - **Description:** optional.
  - **Dates:** filled in automatically, all changeable.
    - **Period** (from and to): where there's context, the context's own period. A schedule entry uses its due window; an audit request uses the audit's period. Otherwise it's the day it's added.
    - **Valid until:** worked out from the evidence type's validity, as it is today, and moving if the type or period changes, until someone sets it by hand.
  - **EVD ID:** shown as "Given when uploaded" until it's added.
- **Upload** (showing how many, e.g. "Upload 3") adds them all to the register and links them to the record. It stays disabled while any row is missing its type, with the reason beside it. Each file goes through today's checks (file type by its bytes, size, encrypted or unreadable PDFs). A file that fails stays in the list with the reason, and the rest are added. Once everything is in, the window closes and the record shows the new pieces with their EVD IDs.
- Closing the window with files still in the list asks before discarding them.

**Implementation notes**
- One shared component, given the target record and the context (controls, period) by each place. Follow `brief/information-architecture.md` → Screen conventions; a row of fields with descriptions is a FieldRow (COM-1623).
- One API to add evidence (files and addresses) to any record that takes evidence, applying that area's permission. It replaces the per-area upload routes, which stay until COM-2043 to COM-2045 move each place over.

**Done when**
- The window opens nearly full screen with both tabs, Add new first.
- Files can be dropped or chosen, and web addresses added. Each is listed on the left and its details edited on the right, with dates filled in and changeable.
- Upload adds them all, with failures kept and explained, and the record then shows them with their EVD IDs.

On the chain: API change.