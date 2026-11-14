---
id: 01M7B5TAN8K53RG778WB7CEXQ2
created: 2026-11-13T19:23:12.424313Z
updated: 2026-11-14T01:43:22.977699Z
type: task
title: 'Fine-tune a check under review before approving it: edit its query by hand in its own box, or ask Polaris to change it, and see a fresh sample'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1806
sprint: spsp226
blocked_by:
- 01M7B5T19CJCDJWV1WJ0GVQNGF
- 01M7AKAHNNRFAAG07ZH7278E0K
comments:
- id: 01M7BRS2ZQX800TP0MFYGEKPVR
  author: Steve Vine
  at: 2026-11-14T00:54:34.743252Z
  text: |-
    Done — PR #1805, stacked on COM-1805's. No migration; the ADR 0142 amendment is appended.
    - The proposal card has Edit query. It's the live check's reads editor, now shared, and it checks as you type. Try it takes a fresh sample without saving. Save keeps the edit with a fresh sample (and any changed field ticks). Reset to Polaris's original puts back what Polaris proposed. A note ("Edited by Polaris for …") links to every edit and to Polaris's original.
    - Polaris (in Compass and over MCP) has a tool to change a proposal or a live check by its CHK ID: its reads, the fields it keeps ("add the approver's name"), its name or what it shows. It can try before it saves. There is no approve tool, and a test checks that. The Posture MCP area is at 66 tools, under the 128 limit.
    - Edits are checked the way Polaris's design is: only the company's own accounts, only reads. A read that can't run is refused with the reason, and the last good version is kept. An edit can't change the control. Each edit records who made it and whether it came through Polaris.
    - On a live check, a Polaris change becomes "A change to CHK-14, waiting for review" under the same ID while the check keeps running as it is. Approving it changes the check in place, keeping the same ID, history and rule. A second change edits the one already waiting.
    - Tests include narrowing the CHM.3 emergency-changes proposal both by hand and through Polaris.
    Point for Steve: reads edited by hand on a live check still save straight away after a fresh sample, as they did before this. Only Polaris's changes to a live check go to Review. Should hand edits go to Review too?
    Not checked against a real service: Try it and Save sample on the worker, which the tests replace with a fake. Steve should try it on the real service desk.
    Unit suite, integration, the whole vitest suite, lint, tsc and drift checks pass.
- id: 01M7BVJEK164S5GHXYDE7G2KX6
  author: Steve Vine
  at: 2026-11-14T01:43:22.977353Z
  text: |-
    Pre-UAT: Passed, except one small display fault (staging 694d62c1, E2E Test Company, E2E Admin A, proposal CHK-1). Screenshots: ~/compass-uat/spsp226/COM-1806/

    A correction to what was expected: CHK-1 reads Microsoft 365 through Compass's own directory link, not a Collection integration account. So in E2E, Try it and Save really do take fresh samples. I tested them for real and then reset.

    By hand
    1. Edit query on the card opens the reads as text (service, path, $filter, $top). A broken edit shows "That isn't valid JSON." as you type, and Try it and Save turn off. Reset doesn't show until there has been an edit. (01, 02)
    2. Refusals are plain and save nothing:
       - A made-up service: "That read can't be used: Compass can't read from 'nosuch'"
       - A made-up account: "That read can't be used: That Collection integration doesn't exist"
       I got these on both Try it and Save, and the proposal stayed as it was. (04–06)
    3. Narrowed the filter to completed PIM activations, the CHM.3 kind of case. Try it showed a fresh sample of 15 items against 89 before, with "A fresh sample of the query as typed. Save keeps it." (07)
    4. Save kept it. The card showed "Edited by E2E Admin A". "Show the edits and Polaris's original" listed "14 Nov 2026, 01:34 · E2E Admin A · changed reads" and Polaris's original query. After a reload the edit and its 15-item sample were still there. (08–10)
    5. "Reset to Polaris's original" put back the original query and 89-item sample, with the badge "Reset by E2E Admin A". (11)

    Through Polaris in Compass
    6. With the CHK-1 card open, I asked Polaris to narrow "this one" to completed PIM activations, keep only four fields, try it first, then save, and leave the decision to me. It tried, then saved. It explained the change: 15 events against 89, fields cut from 31 to 4, the trial and saved sample matched. It said approval was mine, and offered to reword the description, which now claims more than it collects. The card refreshed to "Edited by Polaris for E2E Admin A", 4 of 28 ticked, 15-item sample. The edit list reads "Polaris for E2E Admin A · changed reads, fields: Narrowed the read…". I then reset by hand. (12, 13, 15, 16)
    7. No approve tool: the Compass-staging tools available to me include nothing that approves a check or proposal. In the code, Polaris's collection tools have none, and there is a test for it. I didn't ask Polaris to approve.

    Defect (low)
    - After a refused Save, the red refusal stays on screen beside a later successful Try it. Repro: Edit query → make a read that can't run → Save (refused) → correct it → Try it. A good fresh sample shows under the old "That read can't be used…" message.

    Polish (trivial)
    - After a reset, the edit list says "back to Polaris's original: Back to Polaris's original".

    Couldn't check
    - A Polaris change to a live check becoming "A change to CHK-n, waiting for review". E2E's only live check reads a deleted integration, and asking Polaris to re-create it is a different path. Steve: on Moneypenny, ask Polaris "add the approver's name" on a live CHM check and see it wait on Review under the same ID.
    - Over MCP: the change tool wasn't listed in my session's Compass-staging connector, probably because its tool list was cached from before the deploy. So I tested Polaris's change in the app instead.
    - A real service desk: Steve, on Moneypenny, narrow the CHM.3 emergency-changes proposal by hand and through Polaris ("only emergency changes").

    Question for Steve (from the Done comment): reads edited by hand on a live check still save straight away, while Polaris's changes go to Review. Should hand edits go to Review too?
assignee: steve
label:
- feature
priority: high
task_status: review
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