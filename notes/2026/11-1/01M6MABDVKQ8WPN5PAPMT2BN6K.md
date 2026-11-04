---
id: 01M6MABDVKQ8WPN5PAPMT2BN6K
created: 2026-11-04T22:19:55.123402Z
updated: 2026-11-04T22:21:03.211343Z
type: task
title: 'Initiative: New decision has no "Applies to"; the decision is added to the initiative directly'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1591
sprint: srkxswe
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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