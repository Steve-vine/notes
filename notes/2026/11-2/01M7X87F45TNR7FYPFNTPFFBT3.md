---
id: 01M7X87F45TNR7FYPFNTPFFBT3
created: 2026-11-20T19:51:39.909224Z
updated: 2026-11-20T19:52:44.415808Z
type: task
title: Controls, Audit ▸ Evidence and schedule entries use the Add evidence window; a schedule entry's evidence is its controls' evidence too
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2043
sprint: s9hexqn
blocked_by:
- 01M7X872KVKRZNZYF83SCQQVS1
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Built to the ADR in COM-2038, after COM-2042. This is the first place the window goes, and it's Steve's RIM.9 case end to end (2026-11-20).

**Steve's case, as it should go**
1. On RIM.9's assessment, Add evidence ▸ Add new: upload the cyber insurance certificate (EVD-n).
2. In the schedule (Security Assurance Plan), the recurring "Assess and renew cyber insurance" entry linked to RIM.9 is due, and he chooses **Mark done**.
3. The dialog's evidence section has **Add evidence**. Its Link tab opens filtered to evidence on RIM.9, the certificate is there, and he ticks it and links it. Mark done goes through with no upload and no No evidence tick.

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