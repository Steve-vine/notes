---
id: 01M64CNWM12FKRY4C9ZPVKB4XW
created: 2026-10-29T17:52:44.161274Z
updated: 2026-10-29T17:53:09.092103Z
type: task
title: Fill the Demo company on staging with realistic sample data for the Operators Manual screenshots
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 14
sprint: sstqjgj
assignee: steve
label:
- chore
priority: medium
task_status: active
---
The Operators Manual needs screenshots from the real UI, and they go on a public site, so they come from the **Demo** company on the staging instance (compass.citops.net), signed in as the `website@` local account. Made-up data only: no real companies, vendors or people.

Enough data that every screen the manual shows looks lived-in, not empty:

- Assessments across a spread of controls: Implemented, partly done, not started, out of scope
- A handful of gaps with owners, due dates and statuses
- Risks with scores, treatments and mitigating controls
- Some decisions, vendors, access and inventory records, and timeline activity

Staging runs ahead of the release, so check each screen against the released version before it is used in the docs.