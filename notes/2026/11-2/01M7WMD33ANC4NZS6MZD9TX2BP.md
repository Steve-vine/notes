---
id: 01M7WMD33ANC4NZS6MZD9TX2BP
created: 2026-11-20T14:05:12.682021Z
updated: 2026-11-20T16:40:57.499549Z
type: task
title: Linking a business role to a flowchart shape needs no Add button, like controls and documents
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2025
sprint: s6y6p7g
comments:
- id: 01M7WNR3D80DJMBP8MKTKEHQV8
  author: Steve Vine
  at: 2026-11-20T14:28:42.024749Z
  text: |-
    Done — PR #2016, merged 815c2cdd.
    - In the flowchart editor, with a step selected, picking a business role under Links now links it straight away, the same as a control or a document. The Add button is gone.
    - Roles are still linked by name. To link a role the company doesn't have, or any role when no company is selected, type its name and pick "Link “<name>”" at the bottom of the list. Enter does the same.
    - Enter links the highlighted role. The company's role that matches what you typed comes first.
    - A role that's already linked isn't offered, and it's never linked twice.
    - Each link is one Undo step.
    Assumption: role names match regardless of case, so "service desk" is the same role as "Service Desk".
    To check on staging: select a step, pick a role under "Link a business role", and confirm it appears in Links at once. Then type a name the company doesn't have and press Enter.
- id: 01M7WXA8WV5670RA5JXBW2P0ZW
  author: Steve Vine
  at: 2026-11-20T16:40:57.49935Z
  text: |-
    Pre-UAT on staging b65d7ed8 — Passed
    All checks were done as E2E Admin A in E2E Test Company, in the document "E2E pre-UAT COM-2026 Document B, COM-2021 and COM-2025".
    - Linked as soon as it's picked, with no Add button: Passed. I selected Start and opened "Link a business role", which offered E2E Starter. Clicking it put E2E Starter under Links at once, and Undo became available. There is no Add button anywhere in the panel. (r4-01, r4-02)
    - Picking a role that's already linked does nothing: Passed. With E2E Starter linked, the list was empty. Typing "E2E Starter", or "e2e starter" in lower case, offered nothing, and Enter linked nothing. Links still showed it once. (r4-03)
    - A role the company doesn't have: Passed. Typing "E2E pre-UAT COM-2025 Ghost Role" offered «Link "…" (not one of E2E Test Company's roles)», and Enter linked it. Typing the same name in lower case afterwards offered nothing. On a second step I typed "E2E Sta": E2E Starter came first and was highlighted, and Enter linked E2E Starter, not "E2E Sta". (r4-04, r4-05, r4-06)
    - One Undo per link: Passed. I linked E2E Starter, then the Ghost Role. The first Undo removed only the Ghost Role, and the second removed only E2E Starter, after which Undo was greyed out. Redo brought both back.
    - Kept after Done: Passed. After pressing Done, the saved flowchart has Start linked to E2E Starter and the Ghost Role, once each, and the second step linked to E2E Starter.
    - Tests: Passed. PR #2016 adds roleLinks.test.tsx.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2025/
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve (testing round 3): in the flowchart editor, with a shape selected, linking a business role means picking it and then clicking Add. Linking a control or a document doesn't need the extra click. Unless there's a specific reason for the Add button, remove it.

**Done when**
- Picking a business role links it to the shape straight away, exactly as picking a control or a document does. The Add button is gone.
- Picking a role that's already linked does nothing and doesn't link it twice.
- Linking a role is one Undo step.
- Tests cover linking a business role in one step.

(If there turns out to be a real reason for the button, for example a role field that needs more than one value, say so on this task rather than removing it.)