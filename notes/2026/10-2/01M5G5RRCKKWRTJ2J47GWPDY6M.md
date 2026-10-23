---
id: 01M5G5RRCKKWRTJ2J47GWPDY6M
created: 2026-10-21T21:27:09.459991Z
updated: 2026-10-23T18:06:05.559512Z
type: task
title: The controls library says what a risk assessment must record — fraud, scope, who did it and who approved it, at least yearly and on significant change — and the crosswalk gaps the review found are closed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1233
sprint: s33gwqy
blocked_by:
- 01M5G5RG197YT5C51N9SP1860N
comments:
- id: 01M5JRJBNWGDYDPX9FJQXWCZ70
  author: Steve Vine
  at: 2026-10-22T21:34:11.644069Z
  text: |-
    Done — merged in PR #1241. No migration: existing installs pick up the new wording on their next deploy, when the library import runs. Not yet on staging.

    - New "what good looks like" wording:
      - RIM.2: an assessment records its scope, date, who carried it out and who approved it. It considers threats, vulnerabilities, the assets affected and fraud, and scores risk before and after existing controls. Management approves it. It is repeated at least every 12 months and on significant change, and kept (HIPAA: six years).
      - RIM.6: fraud risk factors (incentive or pressure, opportunity, rationalisation, fraud that IT makes possible) are part of the method.
      - RIM.3: the yearly review covers the whole scope (HIPAA: every system handling ePHI).
      - PDH.12: screening is recorded even when no DPIA follows. UK GDPR Art. 35's note now says the same.
    - ISO 27001 8.2 now lists INA.4 beside RIM.3 and RIM.2. The yearly review alone no longer counts as meeting it, but the three together do, so ISO stays at full cover.
    - PCI 8.6.3 and 11.3.1.1 now list RIM.2.
    - The PCI 12.3.1 note says what a targeted risk analysis contains and that it's reviewed at least every 12 months. The 12.3.2 note says a customised-approach analysis is approved by senior management.

    My calls:
    - To avoid a migration, the deploy-time import now rewords a control only where its text still exactly matches a previous wording. A control someone has edited in Compass keeps their text. A dated amendment to ADR 0059 records this; renumbering, retiring or retitling a control still needs a migration. Please confirm you're happy with that rule.
    - RIM.2's new points are merged into five bullets, because the library caps "what good looks like" at five.
    - RIM.3's title still says "products and services"; the task only asked for the wording.
    - RIM.2 counts as partly meeting PCI 8.6.3 and 11.3.1.1; the existing full mappings stay.

    To check on staging: ISO 8.2 shows as full only if nobody has ever recorded a completeness decision on it. If someone had, it would show partly covered.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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