---
id: 01M5Y9FX7NM6S3ZVNC181FWNE7
created: 2026-10-27T09:01:35.861072Z
updated: 2026-10-27T16:56:40.183547Z
type: task
title: The old places go — Admin's Integrations, Email and Attachments tabs and the connection cards on Inventory ▸ Settings are removed, and old links land on the right tile
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1360
sprint: s8fmesf
blocked_by:
- 01M5Y9CK17NMDJM2N3P4GQYC4F
- 01M5Y9CZ2EQ00A6WK97PK2YDHC
- 01M5Y9DB411DAT6GWW6QW3BX9A
- 01M5Y9DKC0399G5ZEX46MZACW8
- 01M5Y9DTC93BDXKB81918WV0H1
- 01M5Y9E3EYNKPHB5APGVZSWYYV
- 01M5Y9EQBS4FTHA52VCVRD3J1H
- 01M5Y9F1VWZH5530KGFRSPRSMN
comments:
- id: 01M5Z4NRD7KMXRPD6FFR3GHXTZ
  author: Steve Vine
  at: 2026-10-27T16:56:39.079784Z
  text: |-
    Done — PR #1376, merged to main. The whole of sprint 90 is on staging (9f3bd999, migration 0713, deployed 16:56 GMT).

    - Admin's tabs are now Users, Roles, Companies, API tokens, Rubrics, Review cadence, Polaris and Files. Integrations, Email and Attachments are gone.
    - Old bookmarks land on the new homes:
      - /admin?tab=integrations goes to the Identity & directory filter;
      - ?tab=email goes to the Email filter;
      - ?tab=attachments goes to the S3-compatible storage tile.
    - Inventory ▸ Settings keeps its own settings, plus one line linking to the Cloud filter of the gallery.
    - Everything that named an old place now names the tile:
      - cloud key and secret errors ("…enter it again under Admin ▸ Integrations ▸ Azure") and the AWS identity hints;
      - the "no sender" reasons, the store's not-configured message and the AD not-set-up sentence;
      - System status's integration links and the Entra group-mappings link;
      - the three "new and not read" Actions, which now open the cloud tile's Configure;
      - Polaris's Inventory tool text;
      - the cloud set-up guides in docs/, the README and the IA brief.
    - The full Vitest run is green (339 files, 3,319 tests, screen-conventions included).

    Also in this PR: dnspython is floored at 2.9.0. CVE-2026-114605 was published today and blocked every PR's dependency scan.

    Deviations / my calls:
    - I didn't add a redirect for /inventory?tab=settings. Inventory ▸ Settings still exists with its own settings, and now points to the Cloud integrations.
    - An old /admin?tab=integrations bookmark redirects only for someone who can see Admin. Inventory admins never had that tab.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Sprint 90, Integrations (ADR in COM-1347). The last task; it lands after every tile task (COM-1350 to COM-1358; COM-1356 was cancelled).

## What people see

- **Admin**, as tabs: Users, Roles, Companies, API tokens, Rubrics, Review cadence, Polaris, Files. Integrations, Email and Attachments are gone. Polaris is unchanged.
- **Inventory ▸ Settings** keeps only Inventory's own settings, such as review intervals and discovery rules. One line names where accounts are now set up and links to the Cloud category of the gallery.
- **Old addresses**, e.g. `/admin?tab=integrations`, `/admin?tab=email` and `/inventory?tab=settings` bookmarks, land on the matching tile or gallery filter.
- **Every message, email and action** that told someone to "go to Admin ▸ Integrations" or "Inventory ▸ Settings" to fix a connection now names and links the tile. This covers health warnings, the Exchange certificate expiry, a failed read, and Polaris's replies.
- **The IA brief and README** describe the new homes.

## Notes (technical)

- Search the backend and frontend for the old paths and tab keys, including action-source link targets (ADR 0055) and assistant tool text.
- Redirects go in the router; the old tab keys stay as aliases for one release.
- Remove the now-unused components and their tests.

**Chain:** on the chain (API, if any action link targets are generated in the backend).

**Done when:**
- no screen, email or action points at an old place;
- the old addresses redirect;
- the full Vitest run (screen-conventions test included) is green.