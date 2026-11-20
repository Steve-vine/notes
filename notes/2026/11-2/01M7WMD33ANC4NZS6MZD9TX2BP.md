---
id: 01M7WMD33ANC4NZS6MZD9TX2BP
created: 2026-11-20T14:05:12.682021Z
updated: 2026-11-20T14:05:30.082776Z
type: task
title: Linking a business role to a flowchart shape needs no Add button, like controls and documents
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2025
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Steve (testing round 3): in the flowchart editor, with a shape selected, linking a business role means picking it and then clicking Add. Linking a control or a document doesn't need the extra click. Unless there's a specific reason for the Add button, remove it.

**Done when**
- Picking a business role links it to the shape straight away, exactly as picking a control or a document does. The Add button is gone.
- Picking a role that's already linked does nothing and doesn't link it twice.
- Linking a role is one Undo step.
- Tests cover linking a business role in one step.

(If there turns out to be a real reason for the button, for example a role field that needs more than one value, say so on this task rather than removing it.)