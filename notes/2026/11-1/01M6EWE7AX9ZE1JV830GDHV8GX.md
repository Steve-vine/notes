---
id: 01M6EWE7AX9ZE1JV830GDHV8GX
created: 2026-11-02T19:40:34.525286Z
updated: 2026-11-04T19:50:53.396976Z
type: task
title: A heading in a client's contract starts its own section — "BACKGROUND" no longer ends up stuck to the end of the parties clause
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1529
sprint: sm2a4gc
comments:
- id: 01M6KYBQCWX1MJXN0MVCX1ENYP
  author: Steve Vine
  at: 2026-11-04T18:50:21.980837Z
  text: |-
    Done — PR #1599, merged to main (f1574401).

    What actually happened: the contract reader wasn't at fault. Read in again, the PEGO NDA gives BACKGROUND as its own heading. On 2 Nov at 17:47 UTC, "Merge with next clause" was used on the parties clause (2), and that joined the BACKGROUND heading onto its end. The activity log on staging shows it. Merging appends the next clause's heading and text, so BACKGROUND became the clause's last word. (A) and (B) kept their BACKGROUND section, which is why it looked like the heading was read twice.

    What changes:
    - A heading starts its own section, so it can no longer be merged into the clause before it. "Merge with next clause" is greyed out when the next clause is a heading, and its tooltip says why. The server refuses it too: "BACKGROUND is a heading: it starts its own section, so it can't be merged into the clause before it".
    - The Word reader got stricter at the same time. A short capitals line with no full stop now counts as a heading even when it's in the same style as the clause before, and so does a line that is bold only through its style. Before, only Heading/Title styles or bold applied directly counted. PDFs already worked this way.
    - The PEGO NDA reads as the same 92 clauses before and after.

    Existing data: CR-3's clause (2) still has BACKGROUND on the end, from the earlier merge. I haven't edited staging data. Uploading the file again as a new version reads it cleanly.

    Tests: a heading straight after clause text starts its own section, whether it's a Heading style, plain capitals in the same style, or bold by style. A short sentence-case line stays in its clause. Merging a clause into a heading is refused, and the screen doesn't offer it. Unit suite and contract integration tests green.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Contract Review - Updates. Found by Steve testing Contract Review (ADR 0134) on staging, 2026-11-02, on CR-3 PEGO NDA (Test Company). **Independent**: no migration, no API change.

## What happened

The parties clause of the client's NDA was read in as:

> ("Insert client name") incorporated and registered in with company number whose registered office is at ("Party 2"); each a "party" and together the "parties". **BACKGROUND**

The next section's heading, BACKGROUND, was joined onto the end of the clause's text. The Background clauses (A) and (B) did land in a BACKGROUND section, so the heading was read twice: once as a heading and once as clause text. The stray word shows on the clause, goes to Polaris as part of the clause, and would go into any suggested replacement wording or the Word document sent back.

## What people should see

- A heading line in the client's contract (BACKGROUND, AGREED TERMS, a numbered clause heading) starts its section and never appears inside the text of the clause before it.

## Approach (for the PR)

- Look at how the contract reader decides a line is a heading when it follows a clause's last sentence with no blank paragraph or style change, e.g. a short all-caps line, or a line matching a known section name. Reproduce with the PEGO NDA from CR-3.
- Check the same case in our standard contract reader (it shares the splitter).

## Done when

- Re-reading CR-3's document gives a parties clause ending at "together the "parties"." and BACKGROUND only as the section heading for (A) and (B).
- Test: a document whose heading paragraph directly follows clause text, in the same style, splits into the clause and a new section.