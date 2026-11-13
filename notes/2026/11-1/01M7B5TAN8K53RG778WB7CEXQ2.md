---
id: 01M7B5TAN8K53RG778WB7CEXQ2
created: 2026-11-13T19:23:12.424313Z
updated: 2026-11-13T19:23:23.839644Z
type: task
title: 'Fine-tune a check under review before approving it: edit its query by hand in its own box, or ask Polaris to change it, and see a fresh sample'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1806
sprint: spsp226
blocked_by:
- 01M7B5T19CJCDJWV1WJ0GVQNGF
- 01M7AKAHNNRFAAG07ZH7278E0K
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Steve, 2026-11-13. Today a proposal is approved or discarded as Polaris made it. For example, the CHM.3 "emergency changes" proposal actually returned every change, and the only fix was to discard it or redesign from scratch.

## What people see

- **Edit the query**: the card has an **Edit query** box with the check's reads as text (service, path, parameters, paging items, follow-on reads, limits, period). It's checked as you type. **Try it** takes a new sample with the edited reads and shows it in the table, so you can compare before you save. **Save** keeps the edit on the proposal. **Reset** goes back to Polaris's original. Live checks already have this; it's the same editor.
- **Ask Polaris**: with the card open (Polaris knows which check it is, from the check-ID task), you can say things like "only emergency changes", "limit this to changes created in the review period" or "add the approver's name". Polaris changes the proposal's reads, fields, name or what it shows, takes a new sample, and explains what changed. The card refreshes with the new sample and an "Edited by Polaris" note. Polaris can try reads before it saves.
- Every edit, by hand or by Polaris, is recorded on the proposal with who made it. The original stays viewable.
- **Approving stays with the person.** Polaris edits, never approves (ADR 0142).
- The same edit, by hand or through Polaris, works on a live check: it becomes a change waiting on Review, as today.

## Decisions (made, say if wrong)

- Every edit is validated as Polaris's design is (read-only paths, the services connected, no service-specific code). A read that can't run is refused with the reason, and the last good version is kept.
- An edit can't move a check to another control. Discard it and design it under the right control instead.

## Done when

- A proposal's reads can be edited and saved, with Try it showing a fresh sample and Reset restoring the original.
- Polaris (in Compass and over MCP) has a tool to change a proposal or a live check by its ID, with a new sample, and has no approve tool.
- Edits are recorded with who made them.
- The CHM.3 emergency-changes proposal can be narrowed to emergency changes either way.
- There are tests.

**On the chain** (API). After the check-ID task and COM-1795.