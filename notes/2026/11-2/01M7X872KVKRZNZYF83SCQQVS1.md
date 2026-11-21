---
id: 01M7X872KVKRZNZYF83SCQQVS1
created: 2026-11-20T19:51:27.099764Z
updated: 2026-11-21T08:59:59.144781Z
type: task
title: 'The Add evidence window: Link existing evidence tab (the register, sortable and filtered, pick several)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2042
sprint: s9hexqn
blocked_by:
- 01M7X86QAR4TB98Y4NTZY0FCFP
comments:
- id: 01M7Y1R83QG5C1Q8QD7EMF0ZC7
  author: Steve Vine
  at: 2026-11-21T03:17:44.183427Z
  text: |-
    Done and merged to main (PR #2037). No migration.

    What changes:
    - Add evidence ▸ Link existing evidence now works. It shows the evidence register with columns for EVD ID, name, evidence type, classification ("Not classified" when blank), controls, period, valid until (with Out of date or Due soon), added (date and who), and where it came from (Uploaded, Collected, Built-in check or Library). Every column sorts.
    - Search covers the EVD ID, name, description and file name. Filters cover evidence type, classification (Not classified too), status, where it came from, framework, control and date added.
    - Opened from a record with controls, the tab starts filtered to them, shown as a chip ("On RIM.9") that one click clears. A record without controls opens on the whole register.
    - A tick picks a piece, and "Pick everything shown" picks the page. Picks stay while the search and filters change. The footer shows "N picked" and Link N. After linking, the window closes and the record refreshes. A piece that's refused stays picked, with its reason.
    - Pieces already on the record show ticked and can't be picked. Archived pieces aren't offered, and restricted ones show only to people who may see them. Closing the window with picks asks first.
    - A piece already on another control can now be linked to this control, end to end.

    Calls for you to overturn:
    - Someone without View audit can see the register in this tab, but only for a record they may add evidence to (an assessor on a control, for example). Audit ▸ Evidence itself still needs View audit.
    - On a control, "already here" counts any piece that supports the control, including one that reaches it through a linked risk or schedule entry.
    - Kinds a record can't take yet aren't listed. A schedule entry isn't offered web addresses until COM-2043.

    One thing to tidy, in COM-2043: opened from a control's own Evidence tab, the starting "On RIM.9" view shows only what's already there, so it should start on the whole register instead.
- id: 01M7YNAXS8DQ2G086EGB87FRYV
  author: Steve Vine
  at: 2026-11-21T08:59:59.144498Z
  text: |-
    Passed (pre-UAT, staging 7e04d3f5e, E2E Admin A, E2E Test Company).

    Steps and what I saw:
    - From RIM.9's assessment ▸ Add evidence ▸ Link existing evidence: the register showed 53 pieces. The columns are EVD ID, Evidence, Evidence type, Classification, Controls, Covers, Valid until, Added (date and who) and Where it came from, and every one sorts. EVD ID ascending gave EVD-1, 2, 3, 4, 5, 7, 10, 11; the archived EVD-6, 8 and 9 aren't offered. Classification ascending gave Public, Internal, Confidential, then Not classified; descending gave Confidential, Internal, Public, then Not classified.
    - The filters are Evidence type, Classification, Status, Where it came from, Framework, Control and Added from/to. Classification includes Not classified, which showed 34 pieces (EVD-1, 16, 17…).
    - Search: "EVD-66" found only EVD-66. "damaged" found EVD-67 by its name.
    - Picking: I ticked EVD-66 ("1 picked"), searched again and ticked EVD-67, cleared the search, then set and cleared a classification filter. The footer still said "2 picked · Link 2". Link 2 closed the window, and the assessment panel then listed EVD-67 and EVD-66.
    - Already here: pieces already on RIM.9 show ticked and greyed, with "Already on RIM.9", and can't be picked.
    - Opened from a record with controls (Mark done on SAP-85, linked to RIM.9) it starts on a chip "On RIM.9" with 9 pieces. Clicking the chip ("On RIM.9 — clear this filter") showed all 53, and my pick was still kept ("1 picked · Link 1"). From an audit request it opened on "On END.7 and 2 more". From a control's own evidence and from an incident (no controls) it opened on the whole register.
    - Clicking a row (not its tick) previews it beside the register.

    For Steve to look at: Library documents are offered on the Link tab with no EVD ID, at least from an audit request. A Library policy's Controls cell lists every control one per line (END.1 to END.23), which makes that one row as tall as the window. Screenshot: COM-2044/request-link-tab.png

    Screenshots: ~/compass-uat/s9hexqn/COM-2042/
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Built to the ADR in COM-2038, after COM-2041. Steve's design (2026-11-20). It's the second tab of the Add evidence window, and it fixes his RIM.9 case: picking the certificate already on the control instead of uploading it again.

**What people see**
- **The evidence register**, as on Audit ▸ Evidence, inside the window. Columns: **EVD ID**, name, evidence type, **classification** (Not classified when blank), controls, period, valid until (with Out of date shown), added (date and who), and where it came from (uploaded, collected, built-in check). Every column sorts.
- **Search box:** searches the EVD ID, name, description and file name.
- **Filters:** evidence type, classification (including Not classified), control, framework, where it came from, current or out of date, and date added.
- **Opens filtered where there's context** (Steve, 2026-11-20). Opened from a record with controls (a schedule entry linked to RIM.9, a control's own assessment, a gap, an audit request for controls), it opens filtered to evidence on those controls, shown as a filter chip ("On RIM.9") that one click clears. Opened from a record without controls, it opens on the whole register.
- **Multi-select:** a tick on each row and a select-all for what's shown. A footer says how many are picked, and **Link N** links them all to the record. Picks are kept while the search and filters change.
- **Already here:** pieces already on this record show ticked and can't be picked again.
- **Not offered:** archived pieces. A restricted piece shows only to people who may see it.
- After linking, the window closes and the record shows the linked pieces with their EVD IDs. Linking to a control starts the piece Unchecked there and runs that control's workflows (COM-2040). Linking doesn't change a piece's classification.

**Implementation notes**
- Reuse the register's list API with the new filters and an "on these controls" filter. Use SortableTh for the columns (screen-conventions test) and URL-free state inside the window.
- A link API for any record that takes evidence (COM-2040), applying that area's permission.

**Done when**
- The Link tab shows the register with sortable columns (classification among them), search and filters.
- From a record with controls it opens filtered to those controls, and the filter can be cleared.
- Several pieces can be picked and linked at once. Ones already on the record show ticked, and archived ones aren't offered.

On the chain: API change.