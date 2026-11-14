---
id: 01M7DJJYN3YY8YG82JHGCBSVCR
created: 2026-11-14T17:44:51.107628Z
updated: 2026-11-14T17:44:54.202066Z
type: task
title: Polaris sees the controls ticked on Checks, and a request to design checks can say how ("use Entra ID PIM"), from chat or from Do something with them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1836
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
## What happened

Steve, testing Checks (2026-11-14): he ticked ACC.12 on Checks ▸ Overview and asked Polaris in the app to design a check using the Entra ID PIM process. Polaris answered: "I can't tell which control you have selected. The Checks page doesn't pass it to me. The closest match for Entra ID PIM is probably…", and so it guessed.

There are two gaps:

1. **Polaris can't see what's ticked.** In chat it's told the company, the part of Compass and the page, plus a collected check or a DDQ question when one is open (`polaris/place.ts`, `usePublishPolarisContext`). The Overview's ticked controls (`checks/CoverageTab.tsx` → `BatchBar`) aren't sent, so "this control" means nothing to it.
2. **A design request can't carry direction.** Even if Polaris knew it was ACC.12, a design job takes only the control (`core/collection/polaris_design.py`). Neither the batch action (Do something with them ▸ Design checks) nor Polaris starting a batch from chat can pass on "use Entra ID PIM", so the person's steer is lost and Polaris chooses on its own.

## What people see

- **Ticked controls are part of where you are.** With controls ticked on Checks, the Polaris status bar reads e.g. "Moneypenny · Posture ▸ Checks · ACC.12 ticked" (or "· 3 controls ticked"), and Polaris is told exactly which. "This control", "these" and "the ones I've ticked" mean them. Unticking updates it, and so does Clear.
- **Asking Polaris in chat to design checks for the ticked controls works.** It confirms what it'll do ("Design checks for ACC.12 using Entra ID PIM — go ahead?"), then starts it. The progress and the proposals land on Checks ▸ Review as they do now.
- **The direction goes with the request.** Polaris designs with "use Entra ID PIM" in mind: it reads that system first and proposes from it if it can. If it can't, the proposal says why. The direction is shown on the Review card ("Asked for: use Entra ID PIM"), so the approver knows what was asked.
- **Do something with them ▸ Design checks** (and Re-create) gets an optional box: "Anything Polaris should know?" (e.g. "use Entra ID PIM", "changes are in FreshService"). It applies to every control in that batch and shows on each Review card.
- With COM-1835: a person's direction wins over a connection's "What we use it for" ticks. A check designed from a system not marked for that area is still proposed, and the Review card notes the mismatch.

## Done when

- On E2E Test Company, ticking ACC.12 and asking Polaris "design a check for this control using Entra ID PIM" starts a design for ACC.12 without asking which control. The proposal reads from Microsoft 365 (PIM), and the Review card shows the direction.
- The status bar shows the ticked controls, and changes as they're ticked and unticked.
- A batch Design checks with a note carries the note to each control's design and its Review card.
- Tests: vitest for the context published from the Overview and the batch note box; backend tests that a design job's prompt includes the direction and that it's kept on the proposal.

**On the chain** (the design request and the proposal gain the direction: API, and probably a migration to keep it on the proposal). Related: COM-1835.