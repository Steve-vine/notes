---
id: 01M7F9CFBMAHBVDXBY1013JAR7
created: 2026-11-15T09:42:30.516516Z
updated: 2026-11-17T19:50:07.545356Z
type: task
title: Integrations screens group connections into "Can change things" and "Read only", each saying what Compass uses it to do
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1841
sprint: spsp226
blocked_by:
- 01M7F9BCSDAHHXAF5SW66GZK72
comments:
- id: 01M7F9Q1AGZS35AJK5P7K838K7
  author: Steve Vine
  at: 2026-11-15T09:48:16.592173Z
  text: Since logging this, COM-1843 puts Collection and Core on separate tabs, with Collection first. Build the "Can change things" / "Read only" grouping inside the Core tab. The Collection tab is all read only, so the "link to Collection integrations with a count" under Read only isn't needed. Each Collection tile still shows the Read only pill. Build after COM-1843, or rebase onto it if it lands first.
- id: 01M7FHN9D9S9W8ZTJDDMGSPCRG
  author: Steve Vine
  at: 2026-11-15T12:07:07.944797Z
  text: |-
    Built and merged — PR #1840 (bfe680d9). Screens only. Built inside COM-1843's Core tab, as your comment asked.

    - **The Core tab is grouped** under "Can change things" (Microsoft 365, Active Directory, SMTP, SendGrid, Amazon SES, S3) and "Read only" (AWS, Azure, Google Cloud, endoflife.date). Each heading has a one-line hint, and an empty heading is hidden.
    - **Each Core tile has a pill** where the old "Core" badge was: orange outline for Can change things, teal for Read only. It also has a "Compass uses it to: …" line, e.g. "manage people, groups and mailboxes", "send mail", "store uploaded files", "discover resources for Inventory, Vulnerabilities and Secrets", "know when software goes out of support".
    - **Every Collection tile shows "Read only"** where the "Collection" badge was, with "Compass uses it to: read evidence and feeds".
    - Both kinds of detail page show the pill in their header.
    - There's no "link to Collection with a count", since Collection has its own tab now.
    - AD sits under Can change things. It doesn't show its two accounts yet (the read-only one arrived with COM-1839), which can be a small follow-up if you want it on the tile.
    - Tests: Vitest for the grouping and pills. screen-conventions passes.
- id: 01M7FST41DH7CCG0Y2S2G0MBYH
  author: Steve Vine
  at: 2026-11-15T14:29:34.893442Z
  text: |-
    **Passed** — pre-UAT, staging build 20261115-1354 (36d3de6c), E2E Test Company, as E2E Admin A.

    - **Core tab (All 10) is grouped under two headings, each with its hint:**
      - **Can change things:** Microsoft 365 (manage people, groups and mailboxes, publish to SharePoint and sign people in), Active Directory (manage accounts and groups in your domain), SMTP, SendGrid and Amazon SES (send mail), and S3-compatible storage (store uploaded files).
      - **Read only:** AWS, Azure and Google Cloud (discover resources for Inventory, Vulnerabilities and Secrets), and endoflife.date (know when software goes out of support).
      - Every tile has its pill (orange "Can change things" or teal "Read only") and a "Compass uses it to: …" line.
      - With Installed (6) chosen, the not-set-up tiles drop out and both headings stay, because each still has tiles.
    - **Collection tab:** all 7 tiles say **READ ONLY** with "Compass uses it to: read evidence and feeds".
    - **Detail pages show the pill in their header:** Microsoft 365 (CAN CHANGE THINGS), Azure (READ ONLY), GitHub Collection (READ ONLY).
    - **Narrow width (390×844):** both tabs reflow, with no sideways scroll (page scrollWidth = 390) and nothing past the edge. Pills, status badges and the "Compass uses it to" line wrap cleanly.
    - As noted on the task, AD doesn't show its two accounts on the tile yet.

    Screenshots: ~/compass-uat/spsp226/COM-1841/
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
## What happened

This follows from the ADR on read-only evidence. Steve wanted the read-only/read-write split to be visible. Today Admin ▸ Integrations lists Compass's own connections (Microsoft 365, Active Directory, AWS, Azure, Google Cloud, mail, storage, Endoflife…), and Collection integrations sit on their own screen. Nothing says which connections can change things or what Compass uses each one for.

## What people see

- **Admin ▸ Integrations is grouped under two headings:**
  - **Can change things:** Microsoft 365 and Active Directory (Access Control), SMTP, SendGrid and Amazon SES (sending mail), and S3 (storing files).
  - **Read only:** AWS, Azure, Google Cloud, Endoflife, and a link to Collection integrations with a count.
- **Each connection carries a pill and a line.** The pill says "Can change things" or "Read only". The line says "Compass uses it to: …", for example "manage people, groups and mailboxes", "send mail", "store uploaded files", "discover resources for Inventory", "read evidence and feeds" or "know when software goes out of support".
- **Collection integrations show "Read only"** on their list and on each integration.
- **The AD card shows two accounts**: Access Control's (can change things) and the read-only one for evidence, once that task lands.
- This is different from COM-1835's "What we use it for", which is the business's own statement of which evidence lives where. The words "Compass uses it to" keep the two apart.

## Done when

- On staging, Admin ▸ Integrations shows the two groups, with every connection in the right one and its pill and line. Collection integrations show "Read only". Narrow widths still work.
- Vitest covers the grouping and pills. `screen-conventions.test.ts` still passes.

**Independent** (screens only). The AD two-account part waits on the read-only AD account task; until then the AD card sits under "Can change things".