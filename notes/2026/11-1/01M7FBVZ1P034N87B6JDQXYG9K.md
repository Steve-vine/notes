---
id: 01M7FBVZ1P034N87B6JDQXYG9K
created: 2026-11-15T10:25:55.254378Z
updated: 2026-11-17T19:50:07.610224Z
type: task
title: 'A live check''s rule has "If no … are found: fails / passes" in plain words, not only in the raw rule'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1846
sprint: spsp226
comments:
- id: 01M7FQHYYPXDGD3WMXR744AHPF
  author: Steve Vine
  at: 2026-11-15T13:50:10.3898Z
  text: |-
    Built and merged — PR #1839 (36d3de6c). It changes the API, so Polaris can propose the switch. No migration.

    What you'll see:
    - **A live check's rule panel says what finding nothing means**, under the rule, e.g. "If no changes are found: the check passes". A check with no rule shows nothing.
    - **People who can edit the rule switch it there**, with the same two choices as on Review. Before saving, it shows what the newest capture would then be. **Saving re-judges the check at once:** turning it failing raises a gap, turning it passing closes it.
    - **The check's Changes record it**, e.g. "If no changes are found: now passes (was fails)".
    - **Edit rule shows the same choice** above the advanced box, and they stay in step both ways.
    - **Polaris in chat can propose the switch, with why.** It arrives on Checks ▸ Review as a rule proposal and applies only when a person approves it. Asked again while one is waiting, Polaris changes the waiting one rather than making a second.
    - While Edit rule is open, the panel's own switch steps aside so there's only one choice on screen.

    Tests: real-Postgres tests that a switch with an empty newest capture flips the check, raises or closes its gap and adds the Changes entry once; that a Polaris proposal waits on Review with its reason and applies only on approval. Vitest for the line, the switch with preview, Edit rule staying in step and Polaris's reason.
- id: 01M7FSTTQ45JWJBFN7XZK05GQS
  author: Steve Vine
  at: 2026-11-15T14:29:58.116392Z
  text: |-
    **Passed**, except that a gap being raised or closed **Couldn't check**. Pre-UAT, staging build 20261115-1354 (36d3de6c), E2E Test Company, as E2E Admin A. CHK-2 is the only live collected check in E2E, on ACC.13.

    - **Live rule panel:** under the rule it says "If no role assignments are found: the check fails", with The check fails / The check passes.
    - **Switching on the panel:**
      - Picked "The check passes". It showed "The newest capture found no role assignments. With this rule the check passes." with Save: the check passes / Cancel, and the note that saving re-judges and raises or closes a gap. Saved.
      - The panel now says "…: the check passes".
      - CHK-2's Changes has **"If no role assignments are found: now passes (was fails) · 15 Nov 2026"**.
      - The check re-ran (last ran 14:18).
    - **Edit rule:**
      - Shows the same choice above "The rule, as Compass keeps it", and they stay in step both ways: choosing Fails turned the box's "when_empty" into "fail", and editing the box back to "pass" moved the choice to Passes.
      - While Edit rule is open, the panel's own switch is hidden, so only one choice is on screen.
    - **Polaris (works on staging):**
      - Asked it in chat to switch CHK-2 back to fail, with why. It answered that it had proposed it, couldn't approve it itself, and gave its reason.
      - The proposal arrived on Checks ▸ Review ▸ **Rules (1)** with the reason as its note.
      - Before approval the live rule still said "passes". After Approve the rule it says "fails", and Changes has "now fails (was passes)".

    **Couldn't check: the check flipping, and its gap being raised or closed.** CHK-2's Collection integration was deleted, so every re-run ends "Can't tell". Its gap G-71 is already Complete. No collected check in E2E can currently read, so Steve should try this on a check that reads and has an empty newest capture.

    **Observation (not a defect):** on a check that can't read, the preview still says "With this rule the check passes" (or "fails"). After saving, the check stays Can't tell. The preview could say it will still be Can't tell while the read is broken.

    Also: after a switch, "approved by E2E Admin A on …" changes to today's date.

    **Test data:** CHK-2's "if none found" went fails → passes (my switch) → fails (approving the Polaris proposal I asked for). It ends as it started, on fails, with two Changes entries added.

    Screenshots: ~/compass-uat/spsp226/COM-1846/
assignee: steve
label:
- improvement
priority: low
task_status: done
---
## What happened

Steve, testing Checks (2026-11-15), asked what happens when a check finds nothing (e.g. no changes in a period). The rule's "If no … are found" choice (COM-1628) is offered only while the rule waits on Review (`RuleProposal` in `collection/RulePanel.tsx`). After approval, the only way to change it is Edit rule's advanced "The rule, as Compass keeps it" box, by editing `when_empty` in the raw JSON. That isn't something a person should have to do.

## What people see

- **The rule panel on a live check shows the setting in words** under the rule, e.g. "If no changes are found: the check passes".
- **People who can edit the rule can switch it** with the same two choices as on Review: "The check fails" / "The check passes". Before saving, it shows what the newest capture would then be, as the rule preview does now.
- **Saving re-judges the check at once.** A switch that turns it failing raises a gap, and one that turns it passing closes the gap, exactly as any rule change does. The check's Changes list records it, e.g. "If no changes are found: now passes (was fails)".
- **Edit rule shows the same choice** above the advanced box, kept in step with it.
- **Polaris in chat can propose the switch** and explain why. As with any rule, a person approves it on Review; Polaris doesn't change it directly.
- On a check that has no rule, there's nothing to show.

## Done when

- On staging (E2E Test Company), a live check with a rule shows the setting under its rule. Switching it with an empty newest capture flips the check's state, raises or closes its gap, and adds a Changes entry.
- Edit rule's choice and the advanced box agree after either is changed.
- A Polaris-proposed switch arrives on Review and applies only when approved.
- Backend tests cover the switch, the re-judge and the gap. Vitest covers the panel and Edit rule.

**Independent** if the existing rule save takes the setting (it's part of the rule), otherwise **on the chain**. Check first.