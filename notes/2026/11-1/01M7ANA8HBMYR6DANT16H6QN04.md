---
id: 01M7ANA8HBMYR6DANT16H6QN04
created: 2026-11-13T14:34:48.74772Z
updated: 2026-11-13T14:34:50.368374Z
type: task
title: Polaris names a company by its id and asks twice; the Move window's scanner line shows only where it applies
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1797
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: active
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