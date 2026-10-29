---
id: 01M64CNWM12FKRY4C9ZPVKB4XW
created: 2026-10-29T17:52:44.161274Z
updated: 2026-10-29T17:55:05.499994Z
type: task
title: Fill the Demo company on staging with realistic sample data for the Operators Manual screenshots
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 14
sprint: sstqjgj
comments:
- id: 01M64CT6MV39753KK16EQJ4G94
  author: Steve Vine
  at: 2026-10-29T17:55:05.499827Z
  text: |-
    Findings before any data was created:
    - The website@ account signs in to staging (API, local account) and has admin rights. It can see three companies: Demo, Moneypenny, Test Company. Demo is the only one written to.
    - Staging runs a build from 2026-10-29. The latest release is v0.16.0 (2026-10-20), published under ghcr.io/rootcause-it/compass. The website still installs from ghcr.io/steve-vine/compass, where the newest version is 0.7.0.
    - The v0.16.0 menu: Overview (Dashboard, Actions, Reports); Playbook (Frameworks, Domains, Controls, Content); Posture (Assessments, Gaps, Risks, Compliance, Decisions); Modules (Vendor Management, Access Control, Inventory, SAP, Incidents, Attestations, Data Subject Requests); Portals (User Portal); Admin (Admin, Activity, System status).
    - Content, decisions, frameworks and users are shared across all companies on the instance, so any demo content or decisions would also show in the Moneypenny company. Per-company records (assessments, gaps, risks, vendors, inventory, incidents and so on) stay in Demo.
    - Screenshots can be taken from g5 with headless Chromium. A test capture of the sign-in page worked.
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