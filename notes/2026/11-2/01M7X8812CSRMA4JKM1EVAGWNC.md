---
id: 01M7X8812CSRMA4JKM1EVAGWNC
created: 2026-11-20T19:51:58.284052Z
updated: 2026-11-20T19:51:58.284052Z
type: task
title: Incidents, risks and vulnerabilities use the Add evidence window
assignee: steve
priority: medium
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2045
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