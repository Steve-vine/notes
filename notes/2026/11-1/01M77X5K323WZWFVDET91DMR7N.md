---
id: 01M77X5K323WZWFVDET91DMR7N
created: 2026-11-12T12:54:21.026192Z
updated: 2026-11-12T14:31:58.854915Z
type: task
title: The Technology, Data and Software asset forms are wider, so End of support no longer overlaps Review interval
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1753
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Steve, testing on staging (2026-11-12).

**Today:** the Add/Edit technology asset form is too narrow for what it holds. Under Support and review, the End of support field now carries two switches, Unknown and N/A (N/A added by COM-1736). The switches run across the date and into the Review interval (months) field beside it. The Data asset and Software asset forms are the same width (Mantine `lg`, 620 px), and Steve wants all three widened together.

**What it should do:**
- All three asset forms, Technology, Data and Software, open wider (Mantine `xl`, about 780 px), for both Add and Edit, and in the User Portal where an asset owner edits their asset.
- End of support shows the date in full with Unknown and N/A beside it, nothing overlapping. Review interval sits clear of it on the same row.
- Every other row of fields in the three forms still lines up (FieldRow, COM-1623).
- On a narrow screen the forms still fill the width, and the fields stack as they do today.

**Done when:**
- Add and Edit for each of the three asset types open at the new width;
- the End of support row shows a date with both switches visible and nothing overlapping, both with a date and with Unknown or N/A on;
- light and dark mode, the User Portal edit, and a phone-width window are checked;
- there are no errors in the browser console.

Frontend only: `inventory/ContainerModal.tsx`, `inventory/DataAssetModal.tsx`, `inventory/SoftwareAssetModal.tsx` (each `size="lg"`). Independent of the chain.