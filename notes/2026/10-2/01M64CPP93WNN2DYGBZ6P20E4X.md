---
id: 01M64CPP93WNN2DYGBZ6P20E4X
created: 2026-10-29T17:53:10.435355Z
updated: 2026-10-29T20:15:37.373335Z
type: task
title: 'Operators Manual: Admin — email, users and roles, and the other admin screens'
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 20
sprint: sstqjgj
blocked_by:
- 01M64CNWM12FKRY4C9ZPVKB4XW
comments:
- id: 01M64MVGWXFRJJ4GXGRE3WJMYS
  author: Steve Vine
  at: 2026-10-29T20:15:37.373189Z
  text: |-
    Pushed to staging (7fd2b3a): an "Admin" group with nine pages:
    - The Admin page: each tab, the permission behind it, and a first-setup order
    - Build a role
    - Set up email
    - Adjust the rubrics
    - Review cadence
    - API tokens
    - Files in storage
    - Activity log
    - System status

    Users, Companies, Integrations and Attachments link to the existing pages rather than repeating them.

    Also corrected:
    - The Configuration page now lists the incident rubric.
    - The Users page now says Vendor Contact (portal) can be granted on the Users tab, while the other portal roles can't.

    Possible app issues for COM:
    - The Activity page requires a full admin, though its permission (admin.view_activity) was meant for an auditor.
    - Activity shows raw table names and UUIDs for some entities.
    - System status lists "Reading Active Directory" twice.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
The Admin section for whoever looks after Compass: setting up email (Admin ▸ Email), users and roles, single sign-on, evidence storage and the other admin screens. Links to the existing Configuration page rather than repeating it. Checked against the released version.