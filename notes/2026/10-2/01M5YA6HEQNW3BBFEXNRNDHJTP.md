---
id: 01M5YA6HEQNW3BBFEXNRNDHJTP
created: 2026-10-27T09:13:57.463575Z
updated: 2026-10-27T20:20:49.437241Z
type: task
title: A vulnerability's page — what it is, where it is, every source that has seen it, its owner and fix-by date, a comments timeline and its history
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1366
sprint: s6wypy5
blocked_by:
- 01M5YA66B7RSGM68HZG6DXEPDC
comments:
- id: 01M5ZGBK3ETTRA4CMAHMC3BKCW
  author: Steve Vine
  at: 2026-10-27T20:20:48.878754Z
  text: |-
    Built and merged: PR #1381.

    **What's there**
    - **A vulnerability's page**: the VUL reference, title, severity pill with its score, and state. The trail reads Vulnerabilities › VUL-12.
    - **Details**: kind, description, CVEs (each linking to NVD), CVSS score and vector, and recommendation. Editable while it's open, by people who work vulnerabilities.
    - **Where**: the system (a link to its technology asset), and every host, resource or image anyone reported it on.
    - **Sources**: one row per source, with first and last seen ("No longer seen since …" once gone), the source's own severity, and its reference linked back into the source.
    - **Timeline**: comments, oldest first. **History**: every change and who made it.
    - **Fix card**: state, owner (changeable), fix-by with days left or overdue, and severity. Changing severity asks for a reason, moves the fix-by date and adds a timeline entry.

    **My calls**
    - What a source said is shown as the source said it and can't be edited. Only Compass's own fields are.
    - Changing severity moves the fix-by date from the first-seen date, never from today, so a downgrade can't be used to buy time.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). Builds on COM-1365.

## What people see

- **Header:** VUL reference, title, the severity pill and the state.
- **Main column:**
  - **Details:**
    - kind;
    - description;
    - CVEs, each linking to its NVD page;
    - CVSS score and vector;
    - recommendation;
    - attachments.
    - Editable by anyone who can work vulnerabilities while it's open. Text that came from a source is shown as that source's words and isn't editable.
  - **Where:** the system (a link to its technology asset), and the hosts, resources, repositories or images each source reported it on.
  - **Sources:** one row per sighting, with:
    - the source;
    - first seen and last seen;
    - the source's own severity and reference;
    - a link back into the source where it has one.
    - Rows the source has stopped reporting are marked "no longer seen since …".
  - **Timeline:** comments, newest last.
  - **History:** every change and who made it.
- **Side column, "Fix":**
  - state;
  - owner (changeable);
  - fix-by date and how many days are left or overdue;
  - severity, changeable with a reason;
  - the actions for its state (the lifecycle task).
- **The trail** is Vulnerabilities ▸ VUL-12, or the way you came, e.g. from an asset.

## Who can do what

- View vulnerabilities to read.
- Work vulnerabilities to edit, comment, change owner and change severity.

## Notes (technical)

- Changing severity recalculates the fix-by date from the first-seen date, and the history records the old and new values with the reason.
- Text from sources is untrusted (the ADR 0099 `from_the_cloud` line). It is rendered as plain text, and the assistant reports it as data.

**Chain:** on the chain (API).

**Done when:**
- every card shows true data for a hand-recorded vulnerability;
- a severity change moves the fix-by date and is in History.