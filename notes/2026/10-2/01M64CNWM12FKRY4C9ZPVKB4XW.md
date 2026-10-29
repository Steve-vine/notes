---
id: 01M64CNWM12FKRY4C9ZPVKB4XW
created: 2026-10-29T17:52:44.161274Z
updated: 2026-10-29T20:05:22.525604Z
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
- id: 01M64H121BR4WT451DGTZJC609
  author: Steve Vine
  at: 2026-10-29T19:08:44.459235Z
  text: |-
    Demo on staging is now filled.

    Shared records:
    - 8 fictional users at example.com. The website account displays as "Alex Morgan".

    Posture:
    - 341 assessments: 66% compliant, ISO 27001 61%, Cyber Essentials 90%.
    - 13 gaps and 10 risks with treatments, 6 decisions, and a runbook and a procedure with version history.
    - ISO 27001 and Cyber Essentials adopted.

    Modules:
    - 12 vendors, including one questionnaire sent through the Vendor Portal.
    - 17 technology, 7 software and 8 data assets.
    - The 2026 SAP plan, approved: 13 done, 4 on track, 2 overdue, 1 cancelled.
    - 6 incidents and 5 data subject requests at different stages.
    - Links between vendors, assets, risks, gaps and controls.

    Not filled:
    - Access Control and Attestations. Staging's directory is the real Moneypenny Entra mirror, so those screens show real staff. Never screenshot them on staging.

    Limits:
    - Most timestamps are today, because the API can't backdate them.
    - The compliance timeline gets its first point from tonight's snapshot.
    - Staging's Access Control puts 254 unrequested-change actions under every company.
    - SAP-40 (Jan 2027) is stuck as done, so avoid the 2027 SAP view.
    - Granting extra roles to the demo users was refused, so incident and data subject request owners can only be Priya Shah or Alex Morgan.

    Seed scripts are in the session scratchpad (temporary).

    Open question: staging runs far ahead of v0.16.0. Its menu has Exceptions, Continuity, Checks, Vulnerabilities and Risk Assessments, and its Admin tabs differ. Its screens don't match the release, so no screenshots have been taken for the docs yet.
- id: 01M64M8REXWZ65VMZCTJP1YZCP
  author: Steve Vine
  at: 2026-10-29T20:05:22.525384Z
  text: |-
    Done. The screenshots now come from a demo install of the released 0.16.0 on g5, not from staging.

    The demo install:
    - Helm release compass-demo in namespace compass-demo, evaluation size, with its own bundled Postgres and Valkey.
    - Installed exactly as the site's install guide says.
    - Its Vendor Portal address is http://127.0.0.1:18080, the same tunnel under a second hostname.
    - It's reached from g5 with: kubectl port-forward -n compass-demo svc/compass-demo-frontend 18080:80.
    - Admin is alex.morgan@example.com. The password is in the compass-demo-secrets Secret.
    - One company, "Demo". Everyone in it is fictional, at example.com.

    What's in it, replayed from the staging run:
    - Posture: 340 assessments (66% compliant, 88% coverage, ISO 27001 61%, Cyber Essentials 90%), 13 gaps, 10 risks with treatments, 9 decisions, and the runbook and procedure with versions.
    - Modules: 12 vendors, with Helpdeskly's questionnaire sent through the Vendor Portal; 17 technology, 7 software and 8 data assets; the approved 2026 SAP plan; 6 incidents; 5 data subject requests; plus links between them.
    - Shared data types and data entities.

    Still empty: Access Control and Attestations, which need a directory. The compliance timeline gets its first point tonight. The install has no email transport, so nothing is ever sent.

    Staging's Demo company keeps its copy of the data, which is harmless. The seed scripts live in the session scratchpad, which is temporary.

    To remove the demo install later: helm uninstall compass-demo -n compass-demo, then kubectl delete ns compass-demo.
assignee: steve
label:
- chore
priority: medium
task_status: review
---
The Operators Manual needs screenshots from the real UI, and they go on a public site, so they come from the **Demo** company on the staging instance (compass.citops.net), signed in as the `website@` local account. Made-up data only: no real companies, vendors or people.

Enough data that every screen the manual shows looks lived-in, not empty:

- Assessments across a spread of controls: Implemented, partly done, not started, out of scope
- A handful of gaps with owners, due dates and statuses
- Risks with scores, treatments and mitigating controls
- Some decisions, vendors, access and inventory records, and timeline activity

Staging runs ahead of the release, so check each screen against the released version before it is used in the docs.