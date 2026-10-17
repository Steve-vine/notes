---
id: 01M54K6ZG540NVTQ88VSDASYAF
created: 2026-10-17T09:31:13.797172Z
updated: 2026-10-17T13:45:42.206923Z
type: task
title: An SAP entry links to the controls it proves — found by control or by framework requirement ("A.6.3"), once per series, counting for every framework those controls map to
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1050
sprint: sxflvhs
blocked_by:
- 01M54K5437P988KP93SHQ78073
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 75, SAP - Schedule (ADR in COM-1041; Steve, E). Built on COM-1046, because links belong to the series.

## What people see

- A **Controls** section on an entry's page. Each linked control shows its ref and title (for example "SEA.1 Security awareness programme"), the framework requirements it maps to as small pills (ISO 27001 A.6.3, SOC 2 CC2.2…), and this company's assessment status for it. Click a control to open it.
- **Link controls** (for `sap.manage_plan`) opens a picker with one search box:
  - type a control ref or words ("SEA.1", "awareness") to find controls;
  - type a requirement ref ("A.6.3", "CC2.2", "9.2") to see the requirement and **the controls mapped to it**, each with how strongly it maps, and pick from those.
  - You can pick several at once.
- **Unlink** removes one.
- Linking applies to the **series**: every occurrence, past and future, carries the same links. On a one-off entry it's that entry. A done entry's links can't change, since links are part of its frozen record; the series' later occurrences can.
- A control that's **not applicable** for this company can still be linked, but it shows "Not applicable for this company" so it's noticed.

## Rules

- **Link to controls, not requirements** (Steve, E). Framework coverage follows from the existing mappings, so one link counts for every framework.
- Linking and unlinking are in Activity.
- The control's own page shows these links in COM-1051, and coverage uses them in COM-1052.

## Notes (technical)

- A `sap_series_controls` / `sap_entry_controls` join (or one table keyed on series-or-entry; builder's call), mirroring `risk_control_link` / `content_control_link`: soft-deleted, unique pair.
- The requirement search reuses `control_mapping` (`relationship`, `strength`) and the framework requirement refs. Frameworks the company has adopted rank first; the rest can still be searched.
- Done-entry freeze: reject link changes on a done/cancelled one-off entry (COM-1045's guard).

**Done when:** entries and series can be linked to controls found by control or by requirement, the links show with their mapped requirements and the company's assessment status, and done entries refuse changes.