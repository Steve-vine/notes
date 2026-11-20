---
id: 01M7X872KVKRZNZYF83SCQQVS1
created: 2026-11-20T19:51:27.099764Z
updated: 2026-11-20T19:52:41.511646Z
type: task
title: 'The Add evidence window: Link existing evidence tab (the register, sortable and filtered, pick several)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2042
sprint: s9hexqn
blocked_by:
- 01M7X86QAR4TB98Y4NTZY0FCFP
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Built to the ADR in COM-2038, after COM-2041. Steve's design (2026-11-20). It's the second tab of the Add evidence window, and it fixes his RIM.9 case: picking the certificate already on the control instead of uploading it again.

**What people see**
- **The evidence register**, as on Audit ▸ Evidence, inside the window. Columns: **EVD ID**, name, evidence type, controls, period, valid until (with Out of date shown), added (date and who), and where it came from (uploaded, collected, built-in check). Every column sorts.
- **Search box:** searches the EVD ID, name, description and file name.
- **Filters:** evidence type, control, framework, where it came from, current or out of date, and date added.
- **Opens filtered where there's context** (Steve, 2026-11-20). Opened from a record with controls (a schedule entry linked to RIM.9, a control's own assessment, a gap, an audit request for controls), it opens filtered to evidence on those controls, shown as a filter chip ("On RIM.9") that one click clears. Opened from a record without controls, it opens on the whole register.
- **Multi-select:** a tick on each row and a select-all for what's shown. A footer says how many are picked, and **Link N** links them all to the record. Picks are kept while the search and filters change.
- **Already here:** pieces already on this record show ticked and can't be picked again.
- **Not offered:** archived pieces. A restricted piece shows only to people who may see it.
- After linking, the window closes and the record shows the linked pieces with their EVD IDs. Linking to a control starts the piece Unchecked there and runs that control's workflows (COM-2040).

**Implementation notes**
- Reuse the register's list API with the new filters and an "on these controls" filter. Use SortableTh for the columns (screen-conventions test) and URL-free state inside the window.
- A link API for any record that takes evidence (COM-2040), applying that area's permission.

**Done when**
- The Link tab shows the register with sortable columns, search and filters.
- From a record with controls it opens filtered to those controls, and the filter can be cleared.
- Several pieces can be picked and linked at once. Ones already on the record show ticked, and archived ones aren't offered.

On the chain: API change.