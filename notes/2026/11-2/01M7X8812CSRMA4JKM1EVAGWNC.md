---
id: 01M7X8812CSRMA4JKM1EVAGWNC
created: 2026-11-20T19:51:58.284052Z
updated: 2026-11-22T08:13:22.169823Z
type: task
title: Incidents, risks and vulnerabilities use the Add evidence window
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2045
sprint: s9hexqn
blocked_by:
- 01M7X87QSS7B1YJ51ZZ0V3Y0G7
comments:
- id: 01M7YE8FA892E9YSSAVFBB5WEK
  author: Steve Vine
  at: 2026-11-21T06:56:18.760071Z
  text: |-
    Done and merged to main (PR #2042). No migration.

    What changes:
    - Incidents: the Evidence card's Add evidence opens the window, and a closed incident asks why first. Take off removes a file from the incident only, while it's open. Archive stays. "Evidence kept elsewhere" and handing evidence over are unchanged.
    - Timeline entries and notifications: an entry's files and a notification's copy of what was sent come from the window, opened from the form. What you choose is listed on the form and can be taken off again. It's uploaded and linked only when the entry or notification is saved, all or nothing. Nothing reaches the server before save, so cancelling leaves nothing behind.
    - Risks: the evidence card uses the window. Link existing opens on the risk's linked controls. Risks now take web addresses, with Take off and Archive on each piece.
    - Vulnerabilities: the Files card uses the window and takes web addresses. Record a vulnerability holds its files the same way. When it records several at once (one per system), each file is uploaded once and that same piece is linked to the rest, rather than copied. A pen-test report reviewed in Vulnerabilities is still one report, one upload.
    - The User Portal's Report an incident form keeps its simple file picker, per ADR 0164.

    Calls for you to overturn:
    - Risks and vulnerabilities take web addresses. Incidents stay files only, because "Evidence kept elsewhere" already covers what isn't held in Compass.
    - A timeline entry or notification keeps the files it was written with. Nothing can be added afterwards.
    - One bad file refuses the whole timeline entry or notification, and the message names the file and why.
    - A file taken off an incident leaves its card, and the timeline records that. It doesn't appear under archived files.

    Other uploads that still don't use the window (checked across Compass): those the ADR excludes (DDQ, contracts, Trust Centre documents, data subject request files, vendor certificates, house styles, icons, Library files), imports, "Upload a new version", and the portal's Report an incident. The User Portal's audit uploads are fixed in COM-2049.

    For you to decide: a DPIA's ICO prior consultation (what was sent, and the reply) is still uploaded on the risk assessment and shows in the register. Risk assessments aren't among the records ADR 0164 names, so I left it.
- id: 01M7YNCG4BEXX42ZEYMTGW2BTV
  author: Steve Vine
  at: 2026-11-21T09:00:50.699212Z
  text: |-
    Failed (minor) (pre-UAT, staging 7e04d3f5e, E2E Admin A, E2E Test Company). Everything is added through the window, but timeline-entry files and a notification's copy don't show their EVD IDs.

    Steps and what I saw:
    - Incident: I recorded INC-125 "E2E 20261121 incident evidence check" (P4). The Evidence card has "Add evidence" and "Record evidence held elsewhere". The window "Add evidence to INC-125" has Add new (files only, no web address box) and Link existing (whole register, 20 file pieces). I linked EVD-65 and uploaded a PNG (EVD-74, Confidential). Both are listed as "EVD-65 …" and "EVD-74 …" with Take off and Archive. Take off on EVD-65 removed it at once, with no confirmation. The incident's History says "unlinked … from INC-125", and the timeline says "Evidence removed … Unlinked from this incident — it stays in the evidence register".
    - Timeline entry: Add entry ▸ Files ▸ Add evidence opens "Add evidence to INC-125 timeline entry". I added a new PDF ("New · 593 B"), then used "Change evidence" ▸ Link existing for EVD-60 ("Linked"). Nothing was sent to the server until I pressed Add entry; the only request was the timeline save itself. The entry then shows both files.
    - Notification: Record as sent (Law enforcement) ▸ "A copy of what was sent" ▸ Add evidence opens "Add evidence to INC-125 notification: Law enforcement". I added a .txt (Confidential), which was held until Record as sent. The notification shows "Sent … reference E2E-20261121-REF" with the file.
    - Risk RSK-125: the Evidence card's Add evidence opens "Add evidence to RSK-125 …". I linked EVD-64 (a web address) and added a new web address (EVD-77). Both are listed with their IDs and addresses. This risk has no linked controls, so the Link tab opened on the whole register (58 pieces); I didn't check the chip for a risk with controls.
    - Vulnerability VUL-3: the Files card's Add evidence opens "Add evidence to VUL-3". I linked EVD-62 and added a web address (EVD-78). Both are listed with their IDs. The History says "linked E2E 20261121 screenshot.png to VUL-3".

    Defect (minor): timeline-entry files and a notification's copy show no EVD ID. The pieces have IDs in the register: the timeline PDF is EVD-75 and the notification copy EVD-76, both "Incident INC-125". On the incident they're listed only by name and size ("E2E 20261121 access review (Word).docx 956 B", "E2E 20261121 timeline PDF.pdf 593 B", "E2E 20261121 notification copy.txt 565 B"). Expected per the Done-when: with EVD IDs, as on the incident's Evidence card. Screenshot: COM-2045/timeline-entry-files-no-evd.png, COM-2045/notification-recorded.png

    Partly checked: "no place that holds the company's evidence has its own upload left". Every place I opened (control, assessment panel, Audit ▸ Evidence, schedule entry and Mark done, audit request, incident, timeline entry, notification, risk, vulnerability, portal request and corrective action) has only Add evidence. I didn't sweep every screen.

    Screenshots: ~/compass-uat/s9hexqn/COM-2045/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Built to the ADR in COM-2038, after COM-2044. This is the last of the places that hold the company's evidence.

**What changes**
- **Incidents:**
  - The incident's **Evidence** card uses the window. "Evidence kept elsewhere" and handing evidence over stay as they are.
  - A **timeline entry**'s files and a **notification**'s copy of what was sent use the window too. They're added as the entry or notification is written, so the window opens from that form and its pieces are linked when it's saved.
  - The User Portal's **Report an incident** form keeps its simple file picker (a colleague reporting isn't working the register), and those files become the incident's evidence as today.
- **Risks:** a risk's files (the risk page) use the window. The Link tab opens filtered to the risk's linked controls.
- **Vulnerabilities:** a vulnerability's files (screenshots, report extracts) use the window. A pen-test report reviewed in Vulnerabilities (COM-1737) is still one report, one upload.
- Each keeps its own rules on who may add and remove, and a closed incident keeps what it was closed with (COM-2040).
- Afterwards, check nothing else that holds the company's evidence still has its own upload. The exclusions are listed in the ADR (COM-2038): DDQ, contracts, Trust Centre documents, DSR files, vendor certificates, imports, house styles and icons.

**Done when**
- Incident evidence, timeline-entry files, notification copies, risk files and vulnerability files are all added through the window, new or linked, with EVD IDs.
- No place that holds the company's evidence has its own upload left.

On the chain: API change.