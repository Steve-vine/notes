---
id: 01M7ANA8HBMYR6DANT16H6QN04
created: 2026-11-13T14:34:48.74772Z
updated: 2026-11-13T14:58:19.920223Z
type: task
title: Polaris names a company by its id and asks twice; the Move window's scanner line shows only where it applies
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1797
sprint: spsp226
comments:
- id: 01M7APN8M4KYKBXA310VMK6TBN
  author: Steve Vine
  at: 2026-11-13T14:58:17.859944Z
  text: |-
    Built: PR #1783 (feature/com-1797-polaris-company-id, f264d87d), auto-merge set. No migration, no ADR change: ADR 0129's amendment already says the system's own vulnerability wins.

    **What a person now sees:**
    - **A. Company given by id:** asking Polaris to add a system gives one ask-first card, and it works first time. The card names the company in words.
      - Every change's card names its company in screen words, so an id never shows.
      - All 655 Polaris tools that take a company already share one company lookup. It now also accepts the id, name or slug.
      - A guard test fails any tool that matches companies its own way.
    - **B. Sightings wording:** the Move and Add a system tools, Polaris's Vulnerabilities instructions, and the vulnerability Polaris reads all say the same thing:
      - A moved vulnerability collects the old system's later sightings only where a scanner or feed reported the issue there.
      - That stops once the old system again has its own vulnerability of the issue, which takes them from then on.
      - A hand record collects nothing.
    - **C. The Move window:** "A scanner's later sightings on X still come here" now shows only when a scanner or feed reported the issue on the system it's moving from. It doesn't show for hand records or for Company-wide. The vulnerability's details gain one field so the window can tell, and schema.d.ts is regenerated.

    **Checks:**
    - ruff, mypy, and the unit suite (2213) pass.
    - Integration tests pass: Polaris approvals, vulnerability move, company-wide, Polaris capabilities, pen-test findings, feed and pen-test Polaris, and assistant.
    - New tests:
      - one card by company id that works;
      - a change with no naming of its own still names its company;
      - the Move window line for scanner-reported, hand and company-wide cases;
      - the company-by-id guard.
    - eslint, prettier and tsc pass, and the touched vitest files pass (13). No OpenAPI drift.

    **Still to check on staging:** the three "Done when" items, in the re-check pass.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Fix-forward from the COM-1786 pre-UAT pass on staging (ee0d160c, 2026-11-13), as E2E Admin A in E2E Test Company.

**What happens:**
- **A. Polaris asks twice and shows an id.** "Add system E2E UAT5 1786 web-a to vulnerability VUL-22":
  - The first ask-first card reads "Add … to 'VUL-22'" with "Company: 5e053577-0df9-…".
  - After Allow, the step fails (red ✗). Polaris then shows a second, correctly worded card that has to be allowed again.
  - Cause: Polaris passed the company's id, and the tool's company lookup only matches a name or slug. The card's naming fell back to the raw arguments. This probably affects any Polaris tool that takes a company.
- **B. Polaris explains sightings the wrong way round.** After adding the old system back to an issue, it said the old system's scanner sightings still go to the moved vulnerability. In fact the new vulnerability on the old system takes them from then on.
- **C. The Move window's scanner line shows where it doesn't apply.** The window always says "A scanner's later sightings on X still come here", including for hand records, and from company-wide it reads "… on Company-wide …". The vulnerability page itself is right.

**What it should do:**
- A. A company given to Polaris tools by id, name or slug all work. Every ask-first card names things in screen words, never an id. One card, and it works first time.
- B. Polaris's description of sightings after an add or a move matches what happens.
- C. The Move window says the line only when a scanner or feed reported the issue on the system it's moving from.

**Done when:**
- On staging, in E2E Test Company:
  - Polaris adds a system with one card, which shows no id.
  - The Move window shows the line only for a scanner-reported vulnerability.
  - Polaris's wording after an add is right.
- Tests cover company-by-id for Polaris tools generally, and the Move window line.

Independent; no migration expected.