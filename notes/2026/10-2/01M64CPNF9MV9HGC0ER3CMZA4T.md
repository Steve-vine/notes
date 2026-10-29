---
id: 01M64CPNF9MV9HGC0ER3CMZA4T
created: 2026-10-29T17:53:09.609294Z
updated: 2026-10-29T20:12:35.532405Z
type: task
title: 'Operators Manual: Playbook — the Core library, content and its versions, frameworks'
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 16
sprint: sstqjgj
blocked_by:
- 01M64CNWM12FKRY4C9ZPVKB4XW
comments:
- id: 01M64MNZACV2CSSY3C9YD4YPJ3
  author: Steve Vine
  at: 2026-10-29T20:12:35.532263Z
  text: |-
    Pushed to staging: a "Playbook" group in the docs sidebar with eight pages and 12 screenshots (light and dark), all checked against the v0.16.0 code.

    The pages:
    - Find a control
    - Add and change controls
    - Read a framework (Cover and Posture)
    - Map controls to a framework
    - Write and publish a document
    - Keep documents reviewed
    - Link a document to controls
    - Set how documents look (house styles)

    Missing shots: the document Edit and Links tabs and the Publish dialog would show empty states with the current demo data, so they were left out.

    Possible app issues found while writing, worth a look in COM:
    - For a document written in sections, the Read tab may show unpublished draft edits to every reader.
    - Revert puts the whole document back to Draft.
    - Renaming a domain's identifier doesn't keep old control refs as "previous ref".
    - A named reviewer may lack the permission to record their own review.
    - Nothing sends the "content review due" notification. Due reviews only reach Actions.
    - CIS v8 and v8.1 mappings both show as "CIS Controls 11.5", with no version.
    - The shipped "Closed by the set" declarations read "Declared by a deleted account".
    - One shipped policy is titled "Internal Audit Policy Policy".

    Site facts that 0.16.0 contradicts (being fixed separately): 384 controls, not 383; HITRUST CSF v11.8.0 now ships; mappings have four relationships, not three; the Cover bands have changed; documents link to controls explicitly again.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
How to work in Playbook: browsing the Core library's controls and domains, writing and versioning content (policies, standards, procedures, runbooks) with change notes, and reading a framework's Cover and Posture. Checked against the released version.