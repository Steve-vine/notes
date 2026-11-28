---
id: 01M8FRM6KSJP1E524RDMPQ466J
created: 2026-11-28T00:24:34.169406Z
updated: 2026-11-28T00:24:36.40865Z
type: task
title: 'Scripting polish from pre-UAT: outputs without "@", the workflow test''s values by their labels, Run now''s confirmation in Compass''s own dialog, no stale clash message, a quiet SQL driver'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2220
sprint: snt3b17
assignee: steve
label:
- bug
priority: medium
task_status: active
---
**Independent** (no migration; the workflow test's answer gains each value's label). Found in the Scripting sprint's pre-UAT on staging 20261127-2345 (28 Nov 2026).

## What people see
- **A script's outputs** are listed as "CRM user ID · CrmUserId · Text". Today they show "@CrmUserId", as if they were inputs. Outputs are column names, not @ values.
- **Testing an access workflow against a past person** lists what the trigger hands on by its labels ("Sign-in name: …"), as the input picker does, not by internal keys ("sign_in_name: …").
- **Run now's confirmation** ("This runs version N against … for real. There's no undo. Run it?") is Compass's own dialog with Run it and Cancel, not the browser's pop-up.
- **The joiner form** never shows a clash message for a name that's no longer in the box. While the check for the new name is under way, the old message goes; Submit stays unavailable until the check comes back.
- **The worker's log** no longer records every step of each SQL Server sign-in and query (the driver's INFO lines). Compass's own lines about a run stay.

**Done when:** on staging, those five read as above.