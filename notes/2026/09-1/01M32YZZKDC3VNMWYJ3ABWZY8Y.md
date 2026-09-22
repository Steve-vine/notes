---
id: 01M32YZZKDC3VNMWYJ3ABWZY8Y
created: 2026-09-21T21:47:14.925767Z
updated: 2026-09-22T21:09:42.293393Z
type: task
title: Write the docs overview page
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 4
comments:
- id: 01M35F7YRNSYDXV0MCWYQ99J9Q
  author: Steve Vine
  at: 2026-09-22T21:09:42.293226Z
  text: |-
    Pushed to staging. git pull only.

    What to look at: /docs/ - now titled "What Compass models". Sections: the shape of it - the Core library (383 controls in 24 domains, the three tiers and "the tier orders work, it does not decide scope") - frameworks (the shipped list with versions and requirement counts, mappings, scope and out-of-scope, the SoA) - Cover and Posture (the app's own explanation quoted, the bands and the rules, the Dashboard's different "Coverage") - assessing a company (the fields, the maturity rubric table, what counts as compliant) - gaps - risks - actions (every source in the queue) - the Timeline - content and decisions - shared vs per-company table - roles - the three modules - next steps.

    Every statement was checked against the models, seed data and screens at v0.7.0, and the on-screen words are used throughout.

    Three things the check turned up that you may want to know or fix in the app:
    1. A code comment (core_control.py) and ADR 0069 still say 269 controls / 23 domains; the CSV has 383 / 24. The page uses 383 / 24.
    2. The rubrics brief says a shortfall "raises a Gap"; in the app a person raises it with the Raise gap button. The page says so.
    3. "Applicability justification" is described as required (ADR 0011, brief) but the API does not enforce it. The page does not call it required.
    Also: the "Not applicable" assessment status has no effect anywhere - only the Applicable switch does. Possibly worth removing the option in the app.

    Technical: src/content/docs/docs/index.md. The checked facts are added to the list in CLAUDE.md.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
The home page ends with "Read what Compass models and how it is assessed" and sends people to /docs/, which is a placeholder.

The page should explain, for someone deciding whether Compass fits: the Core library of controls and their tiers, domains, frameworks and how a requirement maps to controls, the difference between Cover and Posture, how a control is assessed per company (applicability, status, maturity), and how gaps, risks and actions follow from that. Then point to the install guide.

Done when: the page uses the app's own words throughout and each statement has been checked against the app.

Technical: src/content/docs/docs/index.md. The "Checked facts" section of CLAUDE.md is the starting point; the app's brief/ folder and rubrics give the reasoning.