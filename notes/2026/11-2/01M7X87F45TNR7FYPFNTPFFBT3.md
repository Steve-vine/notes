---
id: 01M7X87F45TNR7FYPFNTPFFBT3
created: 2026-11-20T19:51:39.909224Z
updated: 2026-11-21T09:00:37.812029Z
type: task
title: Controls, Audit ▸ Evidence and schedule entries use the Add evidence window; a schedule entry's evidence is its controls' evidence too
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2043
sprint: s9hexqn
blocked_by:
- 01M7X8P43C8G90G1AXM5NVR3Z2
comments:
- id: 01M7YA4QBA75HQ7M3S0K6A4VRM
  author: Steve Vine
  at: 2026-11-21T05:44:21.610365Z
  text: |-
    Done and merged to main (PR #2040). No migration.

    Your RIM.9 case works:
    1. Upload the certificate on RIM.9's assessment.
    2. On the recurring insurance entry, choose Mark done ▸ Add evidence. Link existing starts on the evidence on RIM.9.
    3. Tick the certificate and link it. The entry is done with no second upload and no "No evidence".
    A test walks exactly this.

    What changes:
    - One Add evidence window on a control's assessment panel, in Audit ▸ Evidence, and on a schedule entry (its evidence card and Mark done). The old uploads, the panel's "Paste a link" box and the old Audit ▸ Evidence form are gone. In Audit ▸ Evidence the window asks which controls the evidence supports, and has no Link tab.
    - A schedule entry's evidence is its controls' evidence too. Anything added to an entry, new or linked, is linked to each of its controls, where it runs through their workflows. "Take off this entry" removes it from the entry only; it stays on the controls. Archive still archives everywhere.
    - Schedule entries take web addresses. Mark done counts linked evidence and web addresses like uploaded files, and so does Polaris (its wording comes in COM-2046). Evidence of operation and the plan's export list them with their EVD IDs.
    - The entry's owner on the User Portal adds evidence through the window, with Add new only. On a testing entry, the pen-test "Review findings" tick is on Add new.
    - Opened from a control's own evidence, Link existing now starts on the whole register.

    Calls for you to overturn:
    1. The portal owner gets Add new only. They can't see the register, so they can't link existing evidence or take pieces off.
    2. A control that's never been assessed files new evidence in the register, linked to the control, rather than starting an assessment. It's listed on the panel once the assessment is saved.
    3. Vendor certificates can't be linked to a schedule entry. It takes files and web addresses only.

    Left for later: a control linked to an entry after evidence is already on it doesn't pick up that existing evidence; only new adds and links go both ways.
- id: 01M7YNC3HMT9E6KCB10TGWJR26
  author: Steve Vine
  at: 2026-11-21T09:00:37.811825Z
  text: |-
    Passed (pre-UAT, staging 7e04d3f5e, E2E Admin A, E2E Test Company). Steve's RIM.9 case works end to end. There are two small defects on the assessment panel.

    Steve's case:
    1. RIM.9 wasn't assessed. On its assessment (Assessments ▸ RIM.9) I chose Implemented, then Add evidence ▸ Add new. I uploaded "E2E 20261121 cyber insurance certificate.pdf" (Certificate or audit report, Confidential), which became EVD-68, and saved the assessment (v1).
    2. From the panel's "Add to the plan" I made SAP-85 "E2E 20261121 Assess and renew cyber insurance": Review, yearly, 14–21 Nov 2026, linked to RIM.9.
    3. On SAP-85 I chose Mark done ▸ Add evidence. The window "Add evidence to SAP-85 …" opened, and Link existing started on the chip "On RIM.9" with 9 pieces, EVD-68 among them. Clicking it previewed the certificate. I ticked it and pressed Link 1. The dialog then said "1 piece of evidence on the entry", and the "No evidence" tick had gone. Mark done went through. SAP-85 is Done and lists EVD-68, and EVD-68's "Used in" lists RIM.9 and SAP-85 (Finished). The register still has one piece; no second upload.

    A schedule entry's evidence is its controls' evidence:
    - On SAP-85 I added a web address (EVD-69) and a .txt file (EVD-70) through Add evidence. The window's dates started on the entry's window (14–21 Nov 2026). Both then showed on RIM.9's Evidence tab, under the Security Assurance Plan entry and as rows in Manual Collection ("Plan · E2E 20261121 Assess and renew cyber insurance", Unchecked). RIM.9's History says "Linked from elsewhere: …" for each.

    Old uploads gone:
    - The control's assessment panel, Manual Collection, Audit ▸ Evidence and the schedule entry (card and Mark done) all have only "Add evidence". There's no "Paste a link" box and no old upload form.
    - Audit ▸ Evidence's window is "Add evidence to the evidence register", with Add new only and a "Supports" control picker. I added two Word files to RIM.8 there.
    - Link existing opened from a control's own evidence starts on the whole register, with no chip.

    Defects (minor):
    1. The certificate uploaded before the first save isn't listed on the panel. After saving the assessment, and after a reload, RIM.9's assessment panel still says "No files attached." for EVD-68, though it shows on the control's Evidence tab and the section count went up. Pieces linked after the assessment existed (EVD-66, EVD-67) do list there. The PR said such evidence "is listed on the panel once the assessment is saved". Screenshot: COM-2043/rim9-assessed-after-reload.png
    2. Overlapping text on the panel's evidence rows. A long name runs under the size ("470 B") and the action icons, e.g. "EVD-67 E2E 20261121 damaged Word file.docx". Screenshot: COM-2043/assessment-panel-evidence-rows.png

    For Steve to look at: pieces added on a schedule entry read "a record — doesn't go out of date", while the same evidence types added on a control get a valid-until a year on.

    Screenshots: ~/compass-uat/s9hexqn/COM-2043/
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Built to the ADR in COM-2038, after COM-2048, so the preview (COM-2047, COM-2048) comes with the window. This is the first place the window goes, and it's Steve's RIM.9 case end to end (2026-11-20).

**Steve's case, as it should go**
1. On RIM.9's assessment, Add evidence ▸ Add new: upload the cyber insurance certificate (EVD-n).
2. In the schedule (Security Assurance Plan), the recurring "Assess and renew cyber insurance" entry linked to RIM.9 is due, and he chooses **Mark done**.
3. The dialog's evidence section has **Add evidence**. Its Link tab opens filtered to evidence on RIM.9, the certificate is there (previewed when he clicks it), and he ticks it and links it. Mark done goes through with no upload and no No evidence tick.

**What changes**
- **A control's evidence** (the assessment panel on a company's control, and a framework's control view) adds evidence with the window instead of its own upload.
- **Audit ▸ Evidence** ("add evidence straight into the register") uses the window. With no record behind it, Add new asks which controls the evidence supports, as today, and the Link tab doesn't apply there.
- **A schedule entry** (its evidence card, and Mark done's evidence section) uses the window, for the entry's owner and for people who manage the plan, as today.
- **Both ways (Steve, 2026-11-20):**
  - Evidence added to a schedule entry, new or linked, is also linked to each of the entry's controls, where it shows with its status (starting Unchecked and run through workflows).
  - Evidence already on those controls is offered first on the Link tab (COM-2042).
  - Taking a piece off the entry doesn't take it off the controls. Each is removed where it is.
- **Mark done** counts linked evidence like uploaded evidence. No evidence (with a reason) stays for when there truly is none. "Done by an approved risk assessment" (COM-1230) and the pen-test "Review findings in Vulnerabilities" tick (COM-1737) keep working, with the latter on Add new for a testing entry.
- **Archiving** on an entry archives the piece everywhere (COM-2040). The note that "its last file asks why there is now no evidence" still applies to a finished entry.
- **Evidence of operation** and the SAP export list the entry's evidence, linked or uploaded, with EVD IDs.

**Done when**
- Steve's case above works: the certificate uploaded on RIM.9 is linked to the schedule entry when marking it done, with no second upload.
- A file added on a schedule entry shows as evidence on its controls.
- The control's evidence, Audit ▸ Evidence and schedule entries all use the window, and their old upload buttons are gone.

On the chain: API change.