---
id: 01M7NM988TBDZEGHHRYTKZ2VNA
created: 2026-11-17T20:48:25.882913Z
updated: 2026-11-17T22:43:57.973615Z
type: task
title: 'One set of words for every check: Compliant, Non-compliant or Unchecked, and a built-in check''s gap follows that status as a custom check''s does'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1901
sprint: s7nqsy0
comments:
- id: 01M7NTWS2TWQ5V9RR8XW387WVW
  author: Steve Vine
  at: 2026-11-17T22:43:57.145835Z
  text: |-
    Done — PR #1896, merged 1961c630.
    Every check, built-in or custom, now shows its evidence's status: Compliant, Non-compliant or Unchecked, plus Off and Not run. That covers All checks (list, sort, headline), Evidence Collection ▸ Overview, a control's Evidence tab and Checks card, the check's page, the Dashboard tile, What changed and Polaris.
    The cards over All checks are now three: Non-compliant, Compliant and Unchecked.
    A built-in check's page and its card still show what Compass's own test found, for example "Compass's test: Failing, 3 of 212", with who set the status underneath.
    A built-in check's gap follows its evidence's status: Non-compliant raises it, Compliant closes it, Unchecked leaves it, and switching off closes it.
    So a workflow or a person marking it Non-compliant raises its gap. That gap says who did it, why, and what Compass's own test found. New gaps are titled "— Non-compliant".
    What changed now lists checks that became Non-compliant or came back to Compliant, built-in and custom alike.
    Assumptions: Overview's "Evidence only" now reads Unchecked. The Evidence register's "Compass check" line and an audit pack's time-in-state still describe Compass's own test. What changed can't show when a custom check was switched off, because that isn't kept.
    No gap opens or closes because of the change itself: a gap that's open now closes when its evidence is next Compliant. A run only acts on the gap when its own test agrees with the evidence's status.
    To check on staging: look at All checks for any Passing, Failing or Can't tell (there should be none). On a built-in check in E2E Test Company, set its evidence Non-compliant on the control's Evidence tab while its test passes. You should see a gap appear that names you, and its page should still say "Compass's test: Passing".
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, 2026-11-17: built-in checks show Passing / Failing / Can't tell and custom checks show Compliant / Non-compliant / Unchecked. That's left over from before built-in checks filed evidence (ADR 0158), and it isn't wanted. Use one set of words, and give one rule for gaps.

Builds on COM-1897 (custom checks' Raise a gap). It goes after COM-1899, which changes the same list.

**Why it isn't only wording.** A built-in check's own verdict is one opinion on its evidence. A workflow or a person can make that evidence Non-compliant while the check still says Passing, and today All checks shows Passing.

**What changes**
- **Every check shows its evidence's status**: Compliant, Non-compliant or Unchecked, plus **Off** (switched off) and **Not run** (no evidence yet). A built-in check reading several controls goes by its one piece of evidence; a custom check goes by its worst newest capture, as today. This applies on:
  - All checks: the list, the State filter and sorting
  - the headline over All checks
  - Evidence Collection ▸ Overview
  - a control's Evidence tab
  - the check's page header
  - What changed
  - Polaris
- **The summary cards over All checks drop from six to three**: Non-compliant, Compliant and Unchecked.
- **A built-in check's page still shows what Compass's own test found**, "Compass's test: Failing, 3 accounts", beside the evidence status. That way you can see when a workflow or a person gave a different verdict, and who did.
- **A built-in check's gap follows its evidence's status**, as a custom check's does after COM-1897:
  - **Non-compliant**: raises a gap on each of its controls.
  - **Compliant**: closes it.
  - **Unchecked**: changes nothing.
  - **Switched off**: closes it.

  So a workflow or a person marking a built-in check's evidence Non-compliant now raises its gap. Its own failing run does too, as now. The gap says who made it Non-compliant and what was found.
- **Open gaps carry on.** A built-in check's gap that is open when this ships stays open and closes when its evidence is next Compliant. No gap opens or closes because of the change itself.
- No "Passing", "Failing" or "Can't tell" is left in the screens or Polaris as a check's status. "Can't tell" can still describe a run, as in "the check couldn't tell this time".

**Done when**
- All checks, its cards and filter, Overview, a control's Evidence tab, the check's page, What changed and Polaris all show Compliant / Non-compliant / Unchecked / Off / Not run for both types of check.
- A built-in check whose evidence a workflow or a person makes Non-compliant shows Non-compliant everywhere and raises its gap. Its page still shows what its own test found.
- No gap opens or closes because of the change.