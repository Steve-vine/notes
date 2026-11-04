---
id: 01M6MABDVKQ8WPN5PAPMT2BN6K
created: 2026-11-04T22:19:55.123402Z
updated: 2026-11-04T22:20:04.237964Z
type: task
title: 'Initiative: a new decision can be added directly, so "Applies to" is optional'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1591
sprint: srkxswe
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Making a **New decision** from an initiative requires **Applies to**: one of the initiative's controls or risks, which the decision is linked to and which brings it into the initiative. But an *existing* decision can be added to an initiative directly, without linking it to anything. Steve (2026-11-04): a new one should work the same way.

The Decisions menu's New decision has no Applies to. That's correct there and stays as it is.

**Wanted behaviour:**
- On an initiative, **Applies to** in the New decision window is optional. It still offers the initiative's controls and risks.
- Left empty: the decision is created and added to the initiative directly, just like adding an existing decision. It shows on the Decisions tab as added directly, and can be removed from the initiative the same way.
- Chosen: as today, the decision is linked to that control or risk and comes in through it.
- The field's help text says both: link it to one of the initiative's controls or risks, or leave it empty to add it to the initiative on its own.

**Done when:** in E2E Test Company, on an initiative with no controls or risks yet, New decision works with Applies to empty, and the decision appears on the initiative's Decisions tab. Removing it from the initiative doesn't delete the decision. With Applies to set, the decision appears and its own page lists that control or risk under Applies to, as now.

**Implementation:** `initiatives/NewDecisionFor.tsx` makes the Select `required` and returns early without a target. Drop `required`, clear the default, and don't block submit. When it's empty, after `useCreateDecision` call `useAddItem(initiative.number)` (`initiatives/items.ts:128`) with kind `decision` and the new decision's id, instead of `useLinkNewDecision` (`work.ts`). Keep the existing error wording, e.g. "The decision was made, but not added to the initiative". The button is currently offered only when the initiative has controls or risks. Check `ItemsTab`/`tabs.tsx` and offer it always. Add Vitest cases for both paths.

**Independent:** frontend only, using existing endpoints.

Found by Steve while testing Initiatives (2026-11-04).