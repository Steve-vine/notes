---
id: 01M7HZ1R77BKHRZ3HN4Q5CB66C
created: 2026-11-16T10:39:36.679977Z
updated: 2026-11-16T15:06:58.454668Z
type: task
title: 'A captured-items condition can say something different from what it does: CHK-24''s says "there must be at least one approval", but an empty capture passes it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1865
sprint: s7nqsy0
comments:
- id: 01M7J8NH7NKT5F95MHATFNBYJS
  author: Steve Vine
  at: 2026-11-16T13:27:42.069179Z
  text: |-
    Done — PR #1858, merged to main (23044462). Not on staging yet.

    - A captured-items condition is now always described in Compass's own words, worked out from its setting: on the canvas, in the step title, the sentences, a run's findings, a test's findings and Polaris's reading. CHK-24's ends "…(if no change approvals are found, it is met)".
    - Polaris's own wording (carried across from the old rules) is kept as a Note, shown in italics beneath, never instead. It's an editable "Note" box in the condition's settings and doesn't change what the workflow does.
    - If a note contradicts what an empty capture means (e.g. "there must be at least one" when an empty capture is met), the workflow's page flags it as a problem. A flagged workflow can't be enabled until it's fixed. An already-enabled one keeps judging, because what it does is clear.
    - Old runs also read in the generated words when opened.

    To check on staging:
    - Open the CHK-24 workflow. It should show the generated wording with the note beneath, flagged as a problem, and stay enabled.
    - Set "If there is nothing to look up" to "It isn't met", or edit or clear the note; the problem should clear.
- id: 01M7JEBA0PCD9JHCPYTJKVG3XE
  author: Steve Vine
  at: 2026-11-16T15:06:58.454452Z
  text: |-
    **Pre-UAT: Passed** (staging 43d03f09, E2E Test Company, E2E Admin A). CHK-24 itself is in Test Company, so I didn't open it.

    Steps and what I saw:
    - New workflow ▸ "Judge a check's evidence" (WF-8), started by CHK-2.
    - Set its captured-items condition to: one item is a "role assignment", every one has visibility is public, and if none are found "It is met". Added the Note "Every repository is public. There must be at least one such role assignment in the period."
    - The generated wording is shown, with the note beneath it:
      - Block, step title and Sentences all read "If every role assignment has visibility is public (if no role assignments are found, it is met)".
      - The note shows beneath it in italics as "Note: …", never instead of it.
    - The contradiction is flagged: "Its note says there must be some role assignments, but if no role assignments are found it is met. Change the note, or what it makes of nothing found". It's listed under "1 thing to put right before it can be enabled", and after saving, Enable stays greyed out.
    - The flag clears when "If no role assignments are found" is set to "It isn't met", and also when the note is edited to drop "there must be". It comes back when the setting returns to "It is met".
    - Test against CHK-2's capture of 6 Nov: the result reads "every role assignment has visibility is public (if no role assignments are found, it is met): All 8 role assignments judged meet it".
    - Polaris's reading (WF-8 through Polaris on staging) gives the generated sentence, then "Note: …", and lists the same problem.
    - WF-2, converted from the old rule, shows the generated wording first and its old text as the Note beneath.

    Steve to look at in Test Company: the CHK-24 workflow should show the generated wording and the note, flagged and still enabled.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1865/ (contradicting-note-new.png, sentences.png, test-result.png, saved-flagged-enable.png, empty-not-met-problem-clears.png, wf2-converted-note-beneath.png)
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found by Steve while testing sprint "Automation - Workflows" on staging (Test Company, CHK-24 on CHM.2).

## What was seen

Steve updated FreshService and re-ran CHK-24 for 8–14 Nov. The capture found no approvals in that week, because CHK-24 collects by updated date and his edits moved them into this week. The workflow "CHK-24 · Change approvals recorded in FreshService…" set the empty capture **Compliant**: "No change approvals found, so it is met".

Yet the workflow reads, on screen and to Polaris: "Every approval on a major or minor change… was approved by a named approver… **There must be at least one such approval in the period.**" Its actual setting is "If there is nothing to look up: It is met".

The wording isn't Compass's reading of the condition. It's the sentence Polaris wrote when it proposed the old pass/fail rule, carried over by the switch-over (COM-1856) and shown in place of the generated wording. The setting itself was carried over faithfully: the old rule also passed an empty capture, so the old rule's description was already wrong.

## Done when

- A captured-items condition is always shown in words generated from what it does: the canvas block, the sentence view, the test result, the evidence's "why", and Polaris's reading. Any wording someone or Polaris wrote can appear as a note beneath, never instead.
- Where a note contradicts the setting on what an empty capture means, the workflow's page flags it as a problem. Example: the note says "at least one" or "there must be", but an empty capture passes.
- The workflows already converted keep their notes, and show the generated wording first.
- Tests cover CHK-24's shape: an empty capture with "it is met" reads as "if no change approvals are found, it is met", whatever the note says.

On the chain if the reading API changes; otherwise independent.