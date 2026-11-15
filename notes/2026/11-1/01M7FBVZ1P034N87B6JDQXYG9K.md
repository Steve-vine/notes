---
id: 01M7FBVZ1P034N87B6JDQXYG9K
created: 2026-11-15T10:25:55.254378Z
updated: 2026-11-15T10:25:58.264402Z
type: task
title: 'A live check''s rule has "If no … are found: fails / passes" in plain words, not only in the raw rule'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1846
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: todo
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