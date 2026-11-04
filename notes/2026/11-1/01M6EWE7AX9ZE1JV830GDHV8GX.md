---
id: 01M6EWE7AX9ZE1JV830GDHV8GX
created: 2026-11-02T19:40:34.525286Z
updated: 2026-11-04T18:21:54.878771Z
type: task
title: A heading in a client's contract starts its own section — "BACKGROUND" no longer ends up stuck to the end of the parties clause
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1529
sprint: sm2a4gc
assignee: steve
label:
- bug
priority: medium
task_status: active
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