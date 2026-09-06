---
id: 01M1TTVR6M7VWX8JMEV4GYEJ0K
created: 2026-09-06T07:45:24.692436Z
updated: 2026-09-06T08:53:05.68442Z
type: task
title: the carry-over fix missed the control's own page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 571
sprint: s2fcksg
comments:
- id: 01M1TYQNC7QKD1SGSH457ZSGMH
  author: Steve Vine
  at: 2026-09-06T08:53:05.031784Z
  text: |-
    Done — PR #577, merged to main.

    The panel now keys itself on the control it is given, rather than the second call site getting the key COM-564 gave the first. That is the shape the task asked for: the editor is an inner component, `AssessmentPanel` wraps it with the key, and no call site can be the one that forgets. The queue's own key is now redundant and has gone, with the reasoning moved to the panel.

    One correction to the ticket, found while writing the test. The fault does not reproduce by walking forwards, and not for the reason the ticket gives. A control the page has not loaded before is fetched, and the page renders `Loading` while that is in flight — which unmounts the panel and resets it anyway. So the deliberate path that reaches it is narrower than "a control link from a framework page": it needs a control the page has **already loaded**, i.e. the browser's back and forward, or following the same link twice. Still real, still a false judgement written into the record, but worth knowing since it explains why nothing showed up on staging.

    The test takes that path — loads both controls, assesses the second, navigates back to the first — and was checked to fail with the key removed (`expected <textarea> to have property "value" with value ''`) and pass with it. The COM-564 test at the queue passes either way, as the ticket predicted.

    Frontend suite green: 988 tests.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Follow-up to COM-564 (merged, b7d862f). Noticed 2026-09-06 while reading the same file for COM-570 — **not** reproduced on staging.

COM-564 fixed the assessment editor carrying one control's answers onto the next by keying the panel on the control, so moving between controls remounts it. That was done at **one** of the two places the panel renders:

- the assessments queue — fixed;
- **a control's own page** (`/controls/<ref>`) — not.

The control's page reads its ref from the URL and fetches, so going from one control to another changes the parameter without remounting the page. The editor keeps its instance, exactly as the queue's did, and the original fault is still there: move between two controls that have **never been assessed** and the second arrives holding the first one's answers, ready to be saved over it.

Reaching it takes a deliberate path — following a control link from a framework or requirement page, or the browser's back and forward — rather than the queue's Next button, which is why it did not show up in testing. The consequence if you do reach it is identical: a false judgement written into the governance record with nothing to warn you.

## What changes

- Key the panel on the control at that call site too, so both entry points behave the same way.
- Then look for a way to stop this recurring rather than fixing it a third time. The panel is rendered in two places today and either can be added to; if the panel keyed itself on the control it is given, no call site could get it wrong. That is the better shape, and it is a small change.
- Cover it with a test at the second entry point, since the one COM-564 added passes while this is broken.

## Related

- COM-564 — the fix this completes.
