---
id: 01M7NKAJPZDRRQ1S19VNAP8WQ8
created: 2026-11-17T20:31:40.767972Z
updated: 2026-11-18T07:53:18.951579Z
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
- id: 01M7P43K6BMW0W5FD49YMQ18NK
  author: Steve Vine
  at: 2026-11-18T01:24:57.675774Z
  text: |-
    Pre-UAT on staging 3171ce79 — Couldn't check
    - A custom check's evidence going Non-compliant raises a gap on each assessed control; Compliant closes it, Unchecked leaves it, switching the check off closes it: Couldn't check. E2E Test Company has one custom check, CHC-2 on ACC.13 (ACC.13 is assessed). Its Collection integration was deleted, so it reads no account now and Compass counts none of its captures as its newest. Its page says "Evidence: Not collected yet". As E2E Admin A, I set its newest capture (6 Nov, 12:21) to Non-compliant, then Compliant, then Non-compliant again, then back to Unchecked, from the status pill in its History. Each change was saved and shown in Activity, but no gap was raised. That fits a check with no current captures, so I don't count it as a defect. Needs a working custom check, which means a real connection. Steve: in Test Company, set CHC-25's newest capture (CHM.2, which holds GAP-122) to Compliant and watch GAP-122 close. Then set it Non-compliant and watch a gap open that reads "Raised by Compass check CHC-25: …", followed by who made it Non-compliant. Then switch Raise a gap off and watch that gap close.
    - Two failing checks on one control get one gap each, and one passing closes only its own: Couldn't check, for the same reason (no custom check that collects). Steve: a custom check failing on a control where a built-in check already holds a gap.
    - Raise a gap can be switched on and off by whoever can change a check's settings, and off asks first and closes its gap: Passed for the switch and the ask. Couldn't check the closing, because CHC-2 holds no gap. As Admin A, CHC-2 ▸ Edit ▸ Gaps has a "Raise a gap" switch: "While its evidence is Non-compliant, it raises a gap on its control; Compliant closes it." Switching it off opened Compass's own dialog: "Switch Raise a gap off for CHC-2? It raises no gap of its own until Raise a gap is switched on again." with Keep it on / Switch off. Confirming changed Details to "Raise a gap: Off" and added "Raise a gap switched off · by E2E Admin A" to Changes. Switching it on asked nothing and added "Raise a gap switched on". The Assessor gets Edit and the same switch and ask; the Assessor can record assessments, which is the permission check settings need. The Viewer and the Analyst get no Edit button, and the API refuses them (403).
    - "Raises its own gap" reads "Raise a gap" everywhere: Passed for every place I could see. CHB-6's page and CHC-2's Details show "Raise a gap: On". Activity says "switched Raise a gap off/on for CHB-4". Polaris's check answers give raise_a_gap for both kinds of check. The old wording isn't left anywhere in the app's code on main. The built-in check's own Edit is COM-1899's.
    - ADR 0159: Passed. decisions/0159-every-check-raises-its-own-gap.md is Accepted and amends 0155 §5 and 0158 §4. 0155 and 0158 carry dated notes pointing to it.
    CHC-2 was put back: its capture is Unchecked and Raise a gap is On.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1897/
assignee: steve
label:
- feature
priority: medium
task_status: done
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