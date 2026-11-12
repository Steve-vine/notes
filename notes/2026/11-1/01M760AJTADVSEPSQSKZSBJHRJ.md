---
id: 01M760AJTADVSEPSQSKZSBJHRJ
created: 2026-11-11T19:11:01.450103Z
updated: 2026-11-12T12:33:00.455249Z
type: task
title: 'A pen test report is uploaded once: from a testing entry in the Security Assurance Plan, its report can be sent for review into Vulnerabilities without uploading it again'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1737
sprint: spsp226
comments:
- id: 01M76GD523RMP94G5S6BK5CW1S
  author: Steve Vine
  at: 2026-11-11T23:52:02.883345Z
  text: |-
    Done, merged in PR #1739 (no migration).

    What you'll see:
    - On a testing entry's Evidence panel: each PDF has "Review findings in Vulnerabilities" for people who can record vulnerabilities. A short window asks for the tester, dates, scope and "This is a retest of…". It then opens the usual pen test review on the entry's own copy. Nothing is uploaded again.
    - Uploading evidence to a testing entry: the tick-box "Is this a pen test report? Review its findings in Vulnerabilities". It shows only on testing entries and only to people who can record vulnerabilities. Ticked, it opens the review window for that file straight away.
    - Vulnerabilities ▸ Bring in a pen-test report: you choose the plan entry first, then "Upload a new report" or "Use a report already on this entry". Using an existing file adds no copy. Files already sent are listed but can't be chosen.
    - A file already sent shows "Reviewed: 7 findings recorded" or "Being reviewed in Vulnerabilities", with a link. A second review of the same file is refused. A withdrawn review frees the file again.
    - Retests work from either route, including from a follow-on entry.

    Calls made, recorded in an amendment to ADR 0129:
    - Only PDFs get the button. The review shows the report and Polaris reads its text, and both need a PDF.
    - People who can see the plan but not Vulnerabilities see neither the button nor a file's review, which matches the Findings panel today. People who can see vulnerabilities but not record them see the link only.
    - An existing file keeps its classification. One with none becomes Confidential, like an uploaded report.
    - The tick-box is on the Evidence panel only, not in the Mark done window. A report attached when marking done uses its button afterwards.

    Known edge, left for COM-1738: while an entry is still open, its report file can still be removed during a review. The review then says the report is gone.
- id: 01M77BN06H7V3HWJBFWXT674VX
  author: Steve Vine
  at: 2026-11-12T07:48:11.601414Z
  text: |-
    Pre-UAT on staging (7ff9a75d), E2E Test Company, as E2E Admin A: Passed.

    Steps and what I saw:
    1. Added testing entry SAP-70 "E2E pre-UAT sprint 116 pen test". The Evidence panel shows the tick-box "Is this a pen test report? Review its findings in Vulnerabilities".
    2. Ticked it and uploaded a PDF. "Evidence added", and the "Review findings in Vulnerabilities" window opened straight away for that file. The dates came from the entry, and it says nothing is uploaded again.
    3. Review findings opened the pen test review on the entry's own copy. I added the finding "E2E sprint 116 TLS 1.0 enabled" on E2E pre-UAT 102 web-1 and confirmed it: "Confirmed: 1 vulnerability recorded from this report".
    4. Back on the entry: the file now reads "Reviewed: 1 finding recorded", linked to the review, with no button to send it again. The Findings panel lists "Pen test: Pen test, 30 Nov 2026".
    5. The Viewer can't open the plan at all, so no button appears for them.

    Not checked here: choosing an existing report from Vulnerabilities ▸ Bring in a pen-test report. That's covered by the integration tests.

    Seen in passing (not this task):
    - On the review page the PDF shows blank, but only because the headless browser has no PDF viewer.
    - The first save of a finding got a 502 because staging's API had run out of database connections. Someone was moving quickly through assessments in another company at the same moment, and the API restarted. The retry saved at once. I've left this out of this task; see my summary to you.

    Screenshots: ~/compass-uat/spsp226/COM-1737/
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Found by Steve while testing (2026-11-11).

**What happens today:** a pen test finished. Steve uploaded the report to its testing entry in the Security Assurance Plan, as evidence. To get its findings into Vulnerabilities he had to upload the same report a second time, from Vulnerabilities ▸ Pen tests ("Upload and review"). That upload also files the report on the entry's evidence, so the entry probably holds two copies, and a done entry's evidence can't be removed.

The two routes don't know about each other. The Vulnerabilities upload already links the report to the entry (ADR 0129 §7a). The upload on the entry itself is plain evidence, though, and nothing on the entry offers to review a report's findings.

**What it should do:** one report, one upload, whichever end you start from.

1. **From the entry.** On a testing entry, each evidence file has **Review findings in Vulnerabilities** for anyone who can record vulnerabilities. It opens the usual pen test review for that file: Polaris reads it, or the findings are typed by hand, and nothing is recorded until a person confirms. Nothing is uploaded again. The entry's Findings panel already lists the review once it exists.
2. **When uploading to the entry.** Uploading evidence to a testing entry asks "Is this a pen test report? Review its findings in Vulnerabilities". Ticking it does step 1 straight away.
3. **From Vulnerabilities.** Once a testing entry is chosen in the upload window, the window offers that entry's evidence files ("Use a report already on this entry") as well as a new upload. Choosing one doesn't add another copy.
4. **A retest** works the same way: a later report on the entry, or on a follow-on entry, can be reviewed as a retest of the earlier one.
5. A file that has already gone for review says so on the entry ("Reviewed: 7 findings recorded", with a link). It can't be sent twice by mistake.

**Done when:**
- A report uploaded only to a testing entry can be reviewed in Vulnerabilities without uploading it again, and its confirmed findings show as vulnerabilities and on the entry's Findings panel.
- Starting from Vulnerabilities, a report already on the entry can be chosen, and the entry still holds one copy.
- A file already sent for review shows its review rather than offering it again.
- Who can do it is unchanged: reviewing needs the right to record vulnerabilities; people who can only see the entry see the link, not the button.

**Not in scope:** removing the duplicate copy Steve's test left on the entry. Done evidence is permanent by design (ADR 0115 §4).