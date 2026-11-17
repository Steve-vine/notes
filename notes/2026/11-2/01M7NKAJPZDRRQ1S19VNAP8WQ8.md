---
id: 01M7NKAJPZDRRQ1S19VNAP8WQ8
created: 2026-11-17T20:31:40.767972Z
updated: 2026-11-17T22:08:23.989258Z
type: task
title: 'Every check can raise its own gap: custom checks get "Raise a gap", as built-in checks have'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1897
sprint: s7nqsy0
comments:
- id: 01M7NRVK9SEPJEZ05N8PPTC0AX
  author: Steve Vine
  at: 2026-11-17T22:08:21.30542Z
  text: |-
    Done — PR #1892, merged 3202914e.
    Every custom check (CHC-n) now has Raise a gap, on for existing and new checks. While its evidence is Non-compliant (its worst newest capture), it holds one gap on each assessed control it's on: "Raised by Compass check CHC-7: <name>", then who made it Non-compliant and what they found, due by the company's gap target. Compliant closes it, Unchecked leaves it, and switching the check off closes it.
    Two checks failing on one control hold one gap each. One passing closes only its own.
    A custom check's Edit has a Raise a gap switch, for whoever can change a check's settings. Switching it off asks first in Compass's own dialog, naming the gap it closes, and adds a line to the check's Changes. Switching it on acts at the evidence's next change of status. Its Details show Raise a gap and its open gap.
    Built-in checks' "Raises its own gap" reads "Raise a gap" in the gap thread, in Activity, on the check's card on a control's Evidence tab and in Polaris. The built-in check's own page and Edit get the rename in COM-1899. Polaris explains gaps the same way for both kinds. ADR 0159 is written, with dated notes in ADR 0155 and ADR 0158.
    Assumptions: a custom check's controls are its own, plus any its captures' pages are linked to. Deleting a custom check closes its open gap, as switching it off does. Moving a check closes its gap on the old control and raises one on the new control while its evidence is Non-compliant.
    To check on staging: "Gaps from evidence" still runs until COM-1900 deploys with it, so until then a failing custom check can show two gaps (its own and the workflow's). Deploy the two together.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Steve, 2026-11-17: every check of both types gets a "Raise a gap" setting. This replaces the default workflow "Gaps from evidence" (retired in the next task), so a failing check never gets two gaps.

**What changes**
- A custom check (CHC-n) gets **Raise a gap**, on by default, for existing checks and new ones. The check still never judges itself: a workflow or a person sets its evidence's status, and the check acts on that status:
  - **Non-compliant**: a gap on each of its controls, the same way a built-in check raises one. A control that isn't assessed, is out of scope or is excepted is left alone. A gap the check raised that was closed as Complete reopens, and a Cancelled one is believed, as today.
  - **Compliant**: the check closes its open gap.
  - **Unchecked**: nothing changes.
  - **Switched off**: its open gap closes.
  - If the check reads several accounts, it goes by its worst newest capture, as All checks shows it.
- The gap reads "Raised by Compass check CHC-7: <name>", then what made it Non-compliant: the workflow or the person, and what was found. Its target date comes from the company's gap target, as a built-in check's does.
- Built-in checks' "Raises its own gap" is renamed **Raise a gap** everywhere: screens, the check's Activity lines and Polaris. It works as before.
- **Switching Raise a gap off** for either type asks first, closes the gap the check raised, and adds a line to the check's Activity. Switching it on acts at the check's next change of status.
- A workflow's own "Raise a gap on the control" action stays, for gaps with their own title or a gap from a document's list. If a check also raises a gap, that's the company's choice; switching the check's Raise a gap off avoids it.
- Polaris explains gaps the same way for both types of check.

**Done when**
- A custom check whose evidence goes Non-compliant raises one gap on each of its assessed controls. Compliant closes it, Unchecked leaves it, and switching the check off closes it.
- Two failing checks on one control have one gap each. One passing closes only its own.
- Raise a gap can be switched on and off for a custom check by whoever can change a check's settings. Off asks first and closes its gap.
- "Raises its own gap" reads "Raise a gap" everywhere.
- A decision record (ADR 0159) says every check raises its own gap, amending ADR 0155 §5 and 0158 §4.

On the chain: it changes the API and adds a migration.