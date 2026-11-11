---
id: 01M760AJTADVSEPSQSKZSBJHRJ
created: 2026-11-11T19:11:01.450103Z
updated: 2026-11-11T22:58:29.230382Z
type: task
title: 'A pen test report is uploaded once: from a testing entry in the Security Assurance Plan, its report can be sent for review into Vulnerabilities without uploading it again'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1737
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: active
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