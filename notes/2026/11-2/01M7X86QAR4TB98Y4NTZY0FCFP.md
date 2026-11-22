---
id: 01M7X86QAR4TB98Y4NTZY0FCFP
created: 2026-11-20T19:51:15.544996Z
updated: 2026-11-22T08:13:22.126999Z
type: task
title: 'The Add evidence window: Add new evidence tab (drop files or a web address, check each one''s details, upload)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2041
sprint: s9hexqn
blocked_by:
- 01M7X85X1XMNTFB7R7X32RT98X
comments:
- id: 01M7XZF9VAZEDT37N7JSAC88SB
  author: Steve Vine
  at: 2026-11-21T02:37:53.898044Z
  text: |-
    Done and merged to main (PR #2036). No migration.

    What changes:
    - One Add evidence window, nearly full screen, titled "Add evidence to <record>". "Add new evidence" opens first. "Link existing evidence" shows greyed out ("Coming next") until COM-2042.
    - Drop files, click to choose several, or paste a web address. Each one appears in the list on the left with its size or address, and a cross takes it off. A row still missing its evidence type or classification carries a marker.
    - The selected row's details are on the right: name or title, evidence type, classification, description, period, valid until, and "EVD ID: Given when uploaded". Classification starts on "Choose a level…", with no Not classified option.
    - The period comes from the record's own period, otherwise today. Valid until is worked out from the evidence type and follows it until someone sets it by hand; "work it out again" undoes that.
    - "Upload N" stays disabled and says why ("2 files still need a classification"). A file that fails a check stays in the list with its reason, and the rest go in. When everything's in, the window closes and the record shows the new pieces with their EVD IDs.
    - Closing the window with files still listed asks first.
    - Once classified, a piece can't go back to Not classified. Compass refuses it, and the piece's page no longer offers it.
    - Where it's live now: a control's Evidence tab ▸ Manual Collection ▸ Add evidence. Every other place keeps its own upload until COM-2043 to COM-2045.

    Calls for you to overturn:
    - Password-protected or damaged PDFs are refused through the new window. Until now only the Trust Centre refused them.
    - A renamed file keeps its extension, so it still opens once downloaded.
    - The Link existing tab shows greyed out rather than hidden until it's built.

    Checked at desktop and phone width: on a phone the window goes full screen with the list and details stacked.
- id: 01M7YNAJTSQT07P8A8ENNRXY9P
  author: Steve Vine
  at: 2026-11-21T08:59:47.929187Z
  text: |-
    Passed (pre-UAT, staging 7e04d3f5e, E2E Admin A, E2E Test Company).

    Steps (RIM.9 ▸ Evidence ▸ Manual Collection ▸ Add evidence):
    - The window is titled "Add evidence to RIM.9" and fills 1392×852 of a 1440×900 screen. It has two tabs, and Add new evidence opens first.
    - With click to choose I added several files at once: a Word file (.docx I made), a PDF, a PNG, a 1,500-row CSV and a fake PDF (text renamed .pdf). I dropped a .txt into the drop box. I added https://www.example.com/e2e-uat-insurer-portal in the Web address box. All seven were listed on the left with their sizes (the address marked "Web address"), each with a marker until it was complete. I took duplicates off the list with "Take … off the list".
    - Details on the right: Name (Title for the address, "Shown in place of the address"), Evidence type, Classification, Description, Covers from and to (today), Valid until, and "EVD ID: Given when uploaded". Classification starts on "Choose a level…" and offers only Public, Internal, Sensitive, Confidential and Restricted; there's no Not classified. Valid until filled in once a type was chosen (21/11/2027, "Worked out from its evidence type").
    - Upload 7 stayed disabled with "7 pieces of evidence still need an evidence type · 7 pieces of evidence still need a classification". It counted down as I filled rows ("6 … still need an evidence type · 7 … still need a classification" after one type), and was enabled once all were done.
    - Closing the window with rows still listed asked "Unsaved changes … Keep editing / Discard changes".
    - Upload 7: "6 added. 1 couldn't be added — each one says why." The fake PDF stayed in the list with "e2e-uat-bad.pdf isn't really a PDF — its contents don't match its type, so it can't be added". The record then listed EVD-60 to EVD-65 with their IDs, classifications and "Unchecked". Renamed files kept their extension (e.g. "E2E 20261121 screenshot.png").
    - Server: an add with no classification (missing or null), sent straight to the server, was refused with 422 "Every piece needs a classification".
    - At phone width (390 px) the window is full screen and nothing scrolls sideways.

    Screenshots: ~/compass-uat/s9hexqn/COM-2041/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Built to the ADR in COM-2038, after COM-2040. Steve's design (2026-11-20). This task builds the window and its first tab. The second tab is COM-2042, and putting the button in each place is COM-2043 to COM-2045.

**The button and the window**
- One **Add evidence** button, the same everywhere Compass asks for evidence. It opens a large window, nearly the full size of the screen, titled with where the evidence is going ("Add evidence to RIM.9", "Add evidence to SAP-14 Renew cyber insurance").
- Two tabs: **Add new evidence** (opens first) and **Link existing evidence** (COM-2042).
- Only people who may add evidence to the record see the button.

**Add new evidence tab**
- **A drop box:** drag files into it, or click it to open the file chooser (several files at once).
- **A web address box:** paste an address and add it. It joins the list like a file (ADR 0122 web-address evidence).
- **The list on the left:** every file and address added so far, with its name and size (or address). The first one is selected. A file can be taken off the list before uploading. A row that's still missing something required (its evidence type or classification) carries a marker, so it's clear what's left to do.
- **Properties on the right**, for whichever row is selected. Steve clicks through each one; there's no editing several at once.
  - **Name:** the file name, which can be changed. For an address, a title, defaulting to the address.
  - **Evidence type:** from the Evidence types rubric. It's required.
  - **Classification: required** (Steve, 2026-11-20). A level on the data sensitivity scale, the same scale as Classify… in the register (ADR 0124 §5, COM-1248). It starts empty ("Choose a level…"), with no level picked for you and no Not classified option. The level is recorded in the piece's history.
  - **Description:** optional.
  - **Dates:** filled in automatically, all changeable.
    - **Period** (from and to): where there's context, the context's own period. A schedule entry uses its due window; an audit request uses the audit's period. Otherwise it's the day it's added.
    - **Valid until:** worked out from the evidence type's validity, as it is today, and moving if the type or period changes, until someone sets it by hand.
  - **EVD ID:** shown as "Given when uploaded" until it's added.
- **Upload** (showing how many, e.g. "Upload 3") adds them all to the register and links them to the record. It stays disabled while any row is missing its type or classification, with the reason beside it ("2 files still need a classification"). Each file goes through today's checks (file type by its bytes, size, encrypted or unreadable PDFs). A file that fails stays in the list with the reason, and the rest are added. Once everything is in, the window closes and the record shows the new pieces with their EVD IDs.
- Closing the window with files still in the list asks before discarding them.

**Classification beyond this window (my calls, for Steve to overturn)**
- **The server refuses** a new piece a person adds without a classification. Each area's old upload goes when it moves to the window (COM-2043 to COM-2045), so once COM-2045 is done there's no way round it.
- **Evidence nobody hands in** (filed by Evidence Collection or a built-in check run, or from the User Portal's Report an incident form) can't ask, so it arrives Not classified, as today. The register's Not classified filter (COM-2042) finds it for classifying.
- **Existing evidence** isn't forced. Anything Not classified stays so until someone classifies it.
- **Once classified**, a piece's level can be changed (in its details, or Classify… in the register) but not cleared back to Not classified.

**Implementation notes**
- One shared component, given the target record and the context (controls, period) by each place. Follow `brief/information-architecture.md` → Screen conventions; a row of fields with descriptions is a FieldRow (COM-1623).
- One API to add evidence (files and addresses) to any record that takes evidence, applying that area's permission and requiring a classification. It replaces the per-area upload routes, which stay as they are until COM-2043 to COM-2045 move each place over and retire them.

**Done when**
- The window opens nearly full screen with both tabs, Add new first.
- Files can be dropped or chosen, and web addresses added. Each is listed on the left and its details edited on the right, with dates filled in and changeable.
- Every file must be given a classification before Upload is allowed, and the server refuses one without.
- Upload adds them all, with failures kept and explained, and the record then shows them with their EVD IDs.

On the chain: API change.