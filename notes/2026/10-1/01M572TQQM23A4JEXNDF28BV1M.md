---
id: 01M572TQQM23A4JEXNDF28BV1M
created: 2026-10-18T08:42:38.708493Z
updated: 2026-10-20T12:18:14.733734Z
type: task
title: A handler can mark an incident restricted — only the people named on it see what's inside; everyone else sees a row with its reference, category, severity and dates, and nothing else, anywhere
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1076
sprint: serbigk
blocked_by:
- 01M572Q0FYNV11AEM6VZXWZ99Q
comments:
- id: 01M57X5V756XFF3884ZY3A8QRK
  author: Steve Vine
  at: 2026-10-18T16:23:05.701092Z
  text: |-
    Done: merged in PR #1075.

    - New permission **Restrict incidents**, on the built-in Admin role only. It adds a **Restrict** button on an incident, which asks why and who may see it. Only people who can see the register can be named, and the person restricting is always named.
    - People named see the incident as normal, with a banner: "Restricted: visible to N people", their names and the reason. Restrict-holders also get **Change who can see it** and **Lift restriction**.
    - Everyone else sees a register row only: reference, categories, severity, status, dates and a **Restricted** pill, titled "Restricted incident". The row doesn't open, and going to its address directly shows a plain "restricted" page.
    - Elsewhere:
      - Asset, vendor, risk and gap pages show "1 restricted incident" instead of a row.
      - Related-incident, duplicate and decision links read "INC-12 · Restricted incident".
      - Activity shows only "INC-12 · Restricted incident", with no field changes.
      - Admin ▸ Files hides the incident's name.
      - Its files can't be downloaded by anyone outside the named list.
    - Restricting, changing who is named and lifting the restriction go on the timeline and in Activity. They also work on closed and triaged-out incidents.
    - The tasks still to come (Actions, Overview, exports, search, the assistant) each use the same single visibility rule.

    Choice made: someone named who later loses register access stays on the list until they're removed from it.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 76, Incidents - Register (ADR in COM-1063; Steve's decision on visibility). Builds on COM-1066.

## What people see

**Restrict** on an incident, for people with `incidents.manage_restricted`. It asks for:
- a **reason** ("insider investigation; HR involved");
- **who may see it**: named people, who must already have `incidents.view`.

The person restricting it is always included. Anyone with `incidents.manage_restricted` can still open it, which keeps a route in if everyone named leaves.

**For people not named**, the incident shows in the register as a row with:
- the reference, categories, severity and status;
- when it occurred and closed;
- a **Restricted** pill.

The title shows as "Restricted incident". The row can't be opened, and nothing inside it shows in any of these places:
- search;
- linked assets', vendors', risks' or controls' pages (counted as "1 restricted incident");
- Actions;
- the Overview's drill-downs (counts still include it);
- exports, where the row is redacted;
- the assistant.

The register stays complete for an auditor's population while the case stays private.

**For people named**, it works as normal, with a banner: "Restricted: visible to 4 people".

## Rules

- Restricting and unrestricting, and every change to the named list, go on the timeline and in Activity.
- An Activity entry for a restricted incident shows only its reference to people not named.
- Reporters still see their own report's status in the portal, as for any report.

## Notes (technical)

- One visibility check used by every read path: register, detail, search, link panels, actions source, exports, evidence of operation, MCP tools. Test each one against an unnamed viewer.

**Done when:** a restricted incident is fully readable only by those named (plus restricted managers); every other surface shows the redacted row or a count.