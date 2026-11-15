---
id: 01M7DJJYN3YY8YG82JHGCBSVCR
created: 2026-11-14T17:44:51.107628Z
updated: 2026-11-15T11:22:18.72816Z
type: task
title: Polaris sees the controls ticked on Checks, and a request to design checks can say how ("use Entra ID PIM"), from chat or from Do something with them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1836
sprint: spsp226
comments:
- id: 01M7DVESECA98EQ2K453G7BN3J
  author: Steve Vine
  at: 2026-11-14T20:19:51.884555Z
  text: |-
    Built and merged: PR #1829, main 22572d0b.

    What people see now:
    - **Ticked controls are part of where you are.**
      - With controls ticked on Checks ▸ Overview, the Polaris status bar reads "… · Posture ▸ Checks · ACC.12 ticked" (or "· 3 controls ticked"), and Polaris is told exactly which.
      - "This control", "these" and "the ones I've ticked" mean them. Unticking, Clear and leaving the page update it.
    - **Designing from chat:** "Design a check for this control using Entra ID PIM" makes Polaris confirm ("Design checks for ACC.12 using Entra ID PIM — go ahead?") and then start the design for ACC.12 with that direction. Progress and proposals land on Checks ▸ Review as before.
    - **Do something with them ▸ Design checks** and **Re-create** have an optional box: "Anything Polaris should know?" (up to 500 characters). It applies to every control in that batch.
    - **The direction goes with the request.**
      - Polaris reads the system it names first and proposes from it if it can, or says why it couldn't.
      - Each Review card shows "Asked for: …", with Polaris's note on how it followed it.
      - An approved check keeps its direction, so Re-create asks the same unless a new note is given.
    - **Direction wins over "What we use it for" (COM-1835),** but only for the system it points to; every other connection keeps to its ticks.
      - A check proposed from a system not ticked for its area shows e.g. "Service desk isn't marked for Assets: proposed because you asked for it" on the Review card.
      - Without a direction, such a read is still refused, as before.
    - ADR 0142 has an amendment recording all this.

    Tests:
    - Backend:
      - a batch direction reaches the design prompt, then the proposal, then the approved check;
      - no direction means nothing is said of one;
      - a "manual only" answer keeps it;
      - Re-create uses the new note or the check's own;
      - over 500 characters is refused;
      - Polaris's chat tool starts a design for the ticked control with the direction;
      - with a direction, a read against a connection ticked for other areas is allowed and the mismatch recorded; without one it's refused; an unknown area is refused even with one.
    - Vitest: the Overview publishes what's ticked (tick, untick, Clear, leave); the status bar wording; the note box on Design and Re-create only; "Asked for" and the mismatch line on the Review card.

    Not done (not asked for): the single-control "Ask Polaris" button on a control's Evidence tab doesn't take a direction yet. The live design on staging needs Polaris's AI provider; I'll check what I can in the pre-UAT pass.
- id: 01M7DX8YH43RGQH8BGPQB95XQQ
  author: Steve Vine
  at: 2026-11-14T20:51:37.635902Z
  text: |-
    Pre-UAT (staging 22572d0b, E2E Test Company, Admin A): **Passed** where I could reach it; **Couldn't check** the live design.

    Passed:
    - Status bar:
      - Ticking ACC.12 on Checks ▸ Overview makes it read "E2E Test Company · Posture ▸ Checks · ACC.12 ticked".
      - Ticking ACC.13 too makes it "2 controls ticked".
      - Unticking ACC.13 goes back to "ACC.12 ticked", and Clear removes the suffix.
    - Dialogs:
      - Ask Polaris to design checks and Ask Polaris to re-create both show the optional "Anything Polaris should know?" box.
      - Collect now has no box.
      - Every dialog was cancelled; no batch was started.

    Couldn't check (needs Polaris's AI provider). Steve:
    1. Tick ACC.12 on Checks ▸ Overview and choose Ask Polaris to design checks. Type "use Entra ID PIM" and start it.
    2. The proposal on Review should show "Asked for: use Entra ID PIM", with Polaris's note on how it followed it.
    3. Also, with ACC.12 ticked, ask Polaris in the panel: "design a check for this control using Entra ID PIM". It should confirm for ACC.12 without asking which control.
    4. No proposal on Review carries an "Asked for" line yet, so I couldn't see that line or the "isn't marked for … : proposed because you asked for it" line render. Both are covered by Vitest.

    Test data: nothing left ticked.
    Screenshots: ~/compass-uat/spsp226/COM-1836/
assignee: steve
label:
- improvement
priority: medium
task_status: done
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