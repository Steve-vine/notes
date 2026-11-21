---
id: 01M7X8812CSRMA4JKM1EVAGWNC
created: 2026-11-20T19:51:58.284052Z
updated: 2026-11-21T06:56:23.939632Z
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
assignee: steve
label:
- feature
priority: medium
task_status: review
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