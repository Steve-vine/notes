---
id: 01M6MABDVKQ8WPN5PAPMT2BN6K
created: 2026-11-04T22:19:55.123402Z
updated: 2026-11-05T00:57:40.933398Z
type: task
title: 'Initiative: New decision has no "Applies to"; the decision is added to the initiative directly'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1591
sprint: srkxswe
comments:
- id: 01M6MEHQGQ9VC533FWT299PQ3C
  author: Steve Vine
  at: 2026-11-04T23:33:15.927806Z
  text: |-
    Done: PR #1605, merged to main as de0180d9.

    What changed: New decision on an initiative no longer has "Applies to". It's the same window as the Decisions menu. Saving creates the decision and adds it to the initiative directly, as adding an existing decision does. Nothing is linked to a control or risk, and removing it from the initiative leaves the decision in the register. If the add step fails after the decision is created, the window says "The decision was made, but not added to the initiative".

    As assumed in the task, New decision now shows only for people who can both record decisions and edit the initiative.

    Tested: InitiativeTabs.test.tsx checks that the decision is created and then added, with no link made, and that the button is hidden for someone who can't edit the initiative.
- id: 01M6MKC9T52PR83CFVS0MFMP1D
  author: Steve Vine
  at: 2026-11-05T00:57:40.933191Z
  text: |-
    Pre-UAT: Passed for the window. Couldn't check saving.

    Steps: on INI-1, opened the Decisions tab, then New decision.

    Seen: the "New decision" window with Title, Status, Decided on and Body (Markdown), and no Applies to.

    Not saved: decisions are shared by every company, so a test one would appear in Moneypenny's register too. Saving and adding directly are covered by the Vitest case. Steve: make a decision from an initiative and check it appears on the Decisions tab, with nothing under Applies to on its own page.

    Screenshot: ~/compass-uat/initiatives-improvements/COM-1591/new-decision.png
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Making a **New decision** from an initiative requires **Applies to**: one of the initiative's controls or risks, which the decision is linked to and which brings it into the initiative. But an *existing* decision can be added to an initiative directly, without linking it to anything.

**Steve (2026-11-04): remove the Applies to field from that window completely.**

**Wanted behaviour:**
- On an initiative, the New decision window is the same as the Decisions menu's: no Applies to.
- Saving creates the decision and adds it to the initiative directly, just like adding an existing decision. It shows on the Decisions tab as added directly, and can be removed from the initiative the same way. Removing it never deletes the decision.
- Linking a decision to a control or risk is still done where it's done today, from that control or risk.
- *Assumption (decided, not asked): New decision is offered only to people who can both record decisions and edit the initiative. Without the field, adding it directly is the only way it joins.*

**Done when:** in E2E Test Company, an initiative's Decisions tab offers New decision, and its window has no Applies to. Saving creates the decision, which appears on the tab as added directly and isn't linked to any control or risk. Removing it from the initiative leaves the decision in the Decisions register. Someone who can record decisions but can't edit the initiative doesn't see New decision.

**Implementation:**
- `initiatives/NewDecisionFor.tsx`: delete the Select and the options and target state, and `useLinkNewDecision` if nothing else uses it (`initiatives/work.ts`).
- After `useCreateDecision`, call `useAddItem(initiative.number)` (`initiatives/items.ts:128`) with kind `decision` and the new decision's id. On failure: "The decision was made, but not added to the initiative".
- `canNewDecision` (`ItemsTab.tsx:102`) also requires `editable`.
- Update the Vitest cases. Check whether Polaris's initiative tools describe making a decision "via a control or risk", and keep the wording in step.

**Independent:** frontend only, using existing endpoints.

Found by Steve while testing Initiatives (2026-11-04).