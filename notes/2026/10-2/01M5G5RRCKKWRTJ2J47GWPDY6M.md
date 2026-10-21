---
id: 01M5G5RRCKKWRTJ2J47GWPDY6M
created: 2026-10-21T21:27:09.459991Z
updated: 2026-10-21T21:27:09.459991Z
type: task
title: The controls library says what a risk assessment must record — fraud, scope, who did it and who approved it, at least yearly and on significant change — and the crosswalk gaps the review found are closed
assignee: steve
task_status: todo
priority: medium
label: improvement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1233
---
Sprint 83, Risk Assessments (ADR in COM-1219). From the 2026-10-21 review of the frameworks against the controls.

**Chain:** on the chain — migration (existing installs get the wording)

## What changes

**Wording ("what good looks like"):**
- **RIM.2** (risk assessment process): a recorded assessment names its scope, date, assessors and approver; considers threats, vulnerabilities, the assets they affect and **fraud** (SOC 2 CC3.3); scores before and after existing controls; is approved by management; is repeated **at least every 12 months and on significant change**; is kept (HIPAA: 6 years).
- **RIM.6** (method): fraud risk factors (incentive/pressure, opportunity, rationalisation; IT-enabled fraud) are part of the method.
- **RIM.3** (annual review): covers the whole scope, not only products and services; HIPAA: all ePHI.
- **PDH.12** (DPIA): screening recorded even when no DPIA follows.

**Crosswalk:**
- **INA.4** maps to **ISO 27001 8.2** (assessment on change) — today only RIM.3 carries it, overstating its coverage.
- **RIM.2** maps to **PCI 8.6.3** and **11.3.1.1** — the targeted risk analysis part of each is unmapped today.
- Mapping notes for PCI 12.3.1/12.3.2 say what a TRA must contain and that it's reviewed every 12 months, and that a customised-approach TRA needs senior management approval.

## Notes (technical)

- The seed importer is insert-missing-only for controls: rewording existing controls needs a migration (or importer repair per the seed practice). Look up by `CoreControl.key`.
- Run `pytest -q` (no -m) — test_crosswalk.py is a unit test; count-pinning tests per the framework checklist.

**Done when:** RIM.2 shows the new wording on staging; ISO 8.2 lists INA.4; PCI 8.6.3 and 11.3.1.1 list RIM.2.