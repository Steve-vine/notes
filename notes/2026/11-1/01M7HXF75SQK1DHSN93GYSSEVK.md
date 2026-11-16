---
id: 01M7HXF75SQK1DHSN93GYSSEVK
created: 2026-11-16T10:12:00.825425Z
updated: 2026-11-16T23:03:23.041476Z
type: task
title: 'A control''s evidence doesn''t update after a check is re-run: the new capture''s status and the gaps a workflow raises or closes only appear after a page refresh'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1862
sprint: s7nqsy0
comments:
- id: 01M7J8NQDYTFN51C324V0R61X1
  author: Steve Vine
  at: 2026-11-16T13:27:48.41388Z
  text: |-
    Done — PR #1862, merged to main (a08c6f0c). Not on staging yet.

    - After Re-run, Custom range or Collect now, the screen keeps watching. It says "Collecting…", then "Captured. The workflows are judging it now…".
    - Meanwhile it refreshes the new capture's status pill and why, the control's evidence and gaps, the Evidence register and All checks.
    - It stops once the workflow runs on the new capture have settled for a few seconds, which leaves time for Gaps from evidence to raise or close its gap.
    - If no workflow judges the capture within 15 seconds, it says it stays Unchecked. It gives up, saying so, after 2 minutes collecting or 1 minute judging, so it never polls for ever. A failed run points to the history.
    - A status set by hand still updates at once.

    To check on staging: on CHM.2's Evidence tab, re-run CHK-26's last period without refreshing. The message should go from Collecting to Judging, the pill should turn Compliant or Non-compliant, G-114 should close (or a gap should appear if you make it fail), and then the message should disappear.
- id: 01M7JEB37H4WH9KERFMWVEA7V2
  author: Steve Vine
  at: 2026-11-16T15:06:51.505581Z
  text: |-
    **Pre-UAT: Couldn't check** (staging 43d03f09, E2E Test Company, E2E Admin A)

    E2E Test Company has no collected check that can capture:
    - CHK-2's Collection integration was deleted.
    - CHK-1 and CHK-3 wait at Review and can't be approved. Approve is refused because they read Microsoft 365 through Access Control's connection.
    - No Collection account can be added to the test company.

    So there is no capture to watch being collected and then judged.

    What I could see:
    - ACC.13 ▸ Evidence ▸ CHK-2 ▸ Collect now: it was refused at once with a red line under the card ("The Collection integration this check reads was deleted, so nothing can be collected…"), and a toast, with no refresh. Because it never starts, the Collecting / Judging messages never appear.
    - Re-run and Custom range are greyed out for a snapshot check, with a tooltip saying why.

    Steve to look at on staging (Test Company, as in the Done comment): on CHM.2's Evidence tab, re-run CHK-26's last period without refreshing. Check that the message goes Collecting → "Captured. The workflows are judging it now…", the pill turns Compliant or Non-compliant, G-114 closes (or a gap appears when it fails), the message clears, and nothing polls for ever.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1862/ (collect-now-running.png, acc13-evidence-before.png)
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Found by Steve while testing sprint "Automation - Workflows" on staging (CHK-26 on CHM.2, Test Company).

## What was seen

On the control's Evidence tab, he re-ran CHK-26 for its last period. The capture is taken in the background, then the workflows run: "Compliant workflow for CHK-26" set the evidence to Compliant, and "Gaps from evidence" closed G-114. None of this showed on screen until he refreshed the page. The same happened when a changed ref made the evidence go Non-compliant and a gap was raised.

## Done when

- After someone starts a capture from the screen (re-run a period, run a custom range, Run now), the screen keeps watching until the capture has finished and the workflows it started have run. Then the following update without a refresh:
  - the new capture on the Evidence tab;
  - its status pill (Compliant / Non-compliant / Unchecked) and the "why" behind it;
  - the control's gaps: a gap raised by a workflow appears, and a gap it closed goes;
  - the check's last capture and status on Evidence Collection, if it's open.
- While it waits, the screen says the capture is running, and then that it's being judged. It stops watching once both have finished, or after a sensible time limit, and says so if it gave up. It doesn't poll for ever.
- A capture that fails shows its error the same way, without a refresh.
- A status a person sets by hand still updates at once, as now.
- Tests cover a re-run whose workflow changes the status and raises a gap, with the screen updating without a reload.

Independent (frontend, unless the run's progress isn't readable yet, in which case it joins the chain).