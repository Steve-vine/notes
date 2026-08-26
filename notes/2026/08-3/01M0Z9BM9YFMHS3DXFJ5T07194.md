---
id: 01M0Z9BM9YFMHS3DXFJ5T07194
created: 2026-08-26T15:00:00.958783Z
updated: 2026-08-26T15:02:09.186576Z
type: task
title: Every surviving control is renumbered, reworded, and told what good looks like
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 424
sprint: s8cjs5n
assignee: steve
company:
- moneypenny
label:
- feature
priority: urgent
task_status: backlog
---
The 255 controls that survive the consolidation, rewritten in place. The
technical content is good — Device Build, Network, Event Management, Threat
Protection, Vulnerability Management, Backup and Access Control are specific and
testable, which is why Cyber Essentials and CIS score as well as they do. This
is not a rewrite of the substance. It is a pass over the wording, the numbering
and the missing descriptions.

## What changes

**Renumber.** Contiguous within the new domain, per the control identity ADR.
The old ref is kept in `legacy_ref` and stays searchable.

**Retire 14 duplicates.** Merge the survivor's wording to cover both, and record
the retirement so the count is explained rather than mysterious:

- `BYO.2` / `MDM.3` — personal devices enrolled in MDM. Same control.
- `BYO.3` / `MDM.7` — segregated partition, remote wipe. Same control.
- `BYO.1` → folds into `RAT.6` conditional access for compliant devices.
- `REM.1` / `EHD.3` — OS-enforced encryption before writing to removable media.
- `REM.2` / `REM.3` — unauthorised removable media blocked.
- `DBC.9` / `DBC.3` — workstation baselines via the device management platform.
- `CAM.1` / `CAM.2` — capacity monitored, and reviewed with forecasts.
- `INS.14` / `INS.13` / `INA.2` — three overlapping review controls; keep two.
- `ACC.19`, `ACC.21` → fold into `ACC.7` and `ACC.20` (generic and privileged
  account handling).
- `VUM.7` / `VUM.4` — testing programme and the vulnerability process.
- `EHD.1` / `EHD.4` — equipment leaving the organisation.
- `WSS.6` / `WSS.1` — clear desk and orderly workspace.

**De-tenant five controls.** `ACC.28`, `CHM.1`, `MDM.3`, `NES.5` and `RAT.1`
name "Moneypenny Group". Domains and controls are shared, company-agnostic
reference data (ADR 0017) — every company sees them.

**Fix three malformed statements.** `ACU.2`, `INA.4` and `WIC.2` have a stray
policy name appended to the sentence.

**Reword what is clumsy.** Judgement, not a blanket rewrite — leave a clear
statement alone. What needs attention:

- *Self-referential controls.* Roughly 20 say "…as defined in the X Policy",
  which tells an assessor nothing and makes the control unassessable on its own
  terms. State the requirement; let the policy hold the detail.
- *Passive constructions* that hide who does the thing — "a risk assessment is
  carried out" gives no owner.
- *"Where appropriate" / "where possible"* — unfalsifiable. Either scope it or
  drop it.
- *Two controls in one sentence*, e.g. `VUM.1` and `VUM.2`, which each carry
  scanning, classification, analysis and remediation targets in one statement.
- *Typos and slips* carried from the source: "removeable" (`EHD.3`), "kay pair"
  (`CRD.3`), "date" for "data" (`BYO.3`), "has been document" (`PDH.4`),
  "centrally managed" opening lowercase (`THP.10`), "country or origin"
  (`DCS.1`).

**Write a description for each**, in the three-part shape the identity ADR
fixes: what this means · what good looks like (3–5 observable bullets, with the
framework's number where it sets one) · evidence an assessor would ask for.

This is the largest single piece of writing in the sprint — 255 descriptions.
Work domain by domain, and put each domain up as its own PR so review is
possible. A 255-control diff will not get read.

## Implementation

- Depends on the control identity ADR and the domain consolidation.
- The wording pass is content, not code, but it lands as data. Follow whatever
  the identity ADR decided about the importer — if `import_controls` stays keyed
  on `ref`, this task cannot ship as a CSV edit.
- Retirement is a soft delete plus a note naming the survivor, not a hard delete:
  assessments and evidence hang off the retired rows (ADR 0027).
- Where a retired control carried a mapping the survivor does not, move it. The
  crosswalk rebuild will catch what is missed, but do not rely on that.

Tests: no control statement contains a company name; every control has a
description; every retired control names its survivor; refs are contiguous
within each domain.
