---
id: 01M3APJGPMB8TJKGR8RNT3J4P8
created: 2026-09-24T21:54:00.532367Z
updated: 2026-09-24T21:54:20.99296Z
type: task
title: A document's links get their own tab — decisions move there, and controls can be linked
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 747
sprint: s71mee4
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
A document can be linked to decisions today, but the decision picker sits on the **Read** tab, so reading a document means scrolling past an editing widget. Documents can't be linked to controls in the UI at all, even though the app already records the link. This task gives links their own tab and adds controls to it.

Part 1 of 2. COM-748 then shows the links on the Read tab.

## What changes

A document gets a new **Links** tab, placed after Read (Read · Links · Edit · History).

- **Decisions:** the existing decisions card moves off the Read tab and into Links unchanged: the same card, the same rules about which decisions can be offered (proposed or accepted only, COM-700), and the same people allowed to link them.
- **Controls:** a new card, in the same shared style as the decisions card and the risk page's cards (COM-583: choose, then **Link**; unlink with the standard control). You find a control by its ref or title. It offers only live controls, not disabled or retired ones. Each linked control shows its ref and title and opens the control's page.
- **Who sees the tab:** anyone who can link either decisions or controls. Each card is editable only by those allowed to link its kind; for anyone else it's read-only. People who can link neither don't get the tab, because the Read tab (COM-748) shows them everything.
- After this task, the Read tab carries **no editing widgets**. It's reading only.
- A linked control already shows the document under *Content* on its own page (`LinkedContentCard`), so the link is visible from both ends as soon as it's made.

## Done when

- The Read tab has no pickers.
- The Links tab links and unlinks decisions exactly as the Read tab did.
- The Links tab links and unlinks controls, and the document then appears on that control's page.
- A viewer without link rights sees no Links tab.
- The screen follows *Screen conventions* (`brief/information-architecture.md`).

## Notes

- The data and API already exist and have never been used by the UI: the `content_control_links` table (ADR 0013/0015, the policy-governs-control / procedure-implements-control edge), `POST`/`DELETE /api/v1/content/{slug}/controls/{control_id}` (playbook author), and `control_ids` on the content detail. Expect this to be frontend-only, with no migration and no API change.
- Build the controls card on `LinkedRecordsCard`, the way `LinkedDecisions` does, so the two can't drift.
- The permission is `playbook.author` for controls and `playbook.record_decisions` for decisions. Hide the tab when the user has neither.

Raised in sprint 61 (Content upgrade) planning, 2026-09-24.