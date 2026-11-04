---
id: 01M6EKVJF3180CZQ44YHK8HK6G
created: 2026-11-02T17:10:34.723705Z
updated: 2026-11-04T07:45:33.908012Z
type: task
title: The Security Feed email digest — each person chooses daily, weekly or off; one email lists the new and changed matches for every company they can see, grouped by company, most urgent first
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1524
sprint: s6xh9g1
blocked_by:
- 01M6EKSK3GGHY1E8J0FQPE60NV
comments:
- id: 01M6F5VHEBK70CDWQGV8WG28RN
  author: Steve Vine
  at: 2026-11-02T22:25:08.043105Z
  text: |-
    Done. Merged to main (PR #1542). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What people see:
    - **Preferences** (in your menu, top right) has a **Security Feed digest** choice for anyone who can see the feed: **Daily, at 07:00**, **Weekly, Mondays at 07:00**, or **Off**. 07:00 is in the person's own time zone. Managers start on Weekly and readers on Off, until they choose.
    - **The email**, "Security Feed: 6 new matches" (or "…, 2 changed"), is one email per person, grouped by company. Each company has these sections, in order:
      1. Known exploited;
      2. Critical;
      3. Other new matches;
      4. Changed since you last heard (rescored, newly exploited, came back after being marked not relevant, saying what changed).

      Each line gives the id, title, severity, the number of systems with the first two named, and the status. Each links straight to the item page.
    - A footer link, **Manage your digest**, opens Compass with Preferences already open.
    - Items already marked not relevant are left out, and so are rejected CVEs. **Nothing new means no email.**
    - Past 50 items for a company, it lists the top 50 and says "And N more", with a link to the feed.
    - A run that's missed catches up at the next hourly check, without sending anything twice.

    Built differently from the task:
    - The setting is in the Preferences dialog. Compass has no separate "My settings ▸ Email" page.
    - The "And N more" link opens the Security Feed. It isn't filtered to that company's matches, and the feed shows the company chosen at the top.

    For UAT with the Mail catcher on: a manager set to Daily gets the digest at the next 07:00 in their time zone. To see one sooner, switch to Daily after 07:00 and wait for the next hourly check.
- id: 01M6GA9KB5GJPQV2NQQQPGWTJ0
  author: Steve Vine
  at: 2026-11-03T09:01:57.477033Z
  text: |-
    Pre-UAT (staging, 2026-11-03): **Passed** for the setting and the sending. **Couldn't check** the email's content in an inbox.

    - As E2E Admin A, the address /security-feed?preferences=open (the digest's footer link) opened My settings, which has a "Security Feed digest" section: "Daily, at 07:00", "Weekly, Mondays at 07:00", "Off". It defaulted to Weekly for a manager. I chose Daily and saved; /auth/me shows daily.
    - No digest had gone out before 09:00: the hourly job had been failing since 31 October on an Actions bug, before it reached the digest. Fixed in COM-1534, and the digest now runs whatever happens to the action emails.
    - The 09:00 run sent 8 digests, one per person due: E2E Admin A on Daily, and the managers on the Weekly default, since this week's Monday digest hadn't gone out. Each has "last sent 09:00:00". Nothing was repeated.

    For you to check: the test accounts are @example.com, so their mail goes nowhere, and I didn't switch on the mail catcher because it would also have caught the first action emails real staff were due after the fix. You were sent a digest at 09:00. Please look at it: grouped by company, with Known exploited / Critical / Other new / Changed sections, links to item pages, and the "Manage your digest" footer. A colleague with admin rights got one too, about E2E Test Company's test matches.
assignee: steve
label:
- feature
priority: medium
---
Sprint 102, Security Feed (ADR 0139 §9, COM-1510).

## What people see

- **My settings ▸ Email ▸ Security Feed digest**: **Daily** (07:00 in the person's time zone), **Weekly** (Monday 07:00) or **Off**. The default is **Off** for readers and **Weekly** for managers.
- **The email** (Compass's house style), "Security Feed: 6 new matches", contains:
  - grouped by **company** (only companies the person can see the feed for);
  - per company, sections in this order:
    1. **Known exploited**;
    2. **Critical**;
    3. **Other new matches**;
    4. **Changed since you last heard** (rescored, newly exploited, came back after not relevant);
  - each item gives its id, title, severity, systems affected (count and the first two names), status, and a link straight to the item page;
  - a footer line, "Manage your digest", links to the setting.
- **Nothing new means no email.**
- The digest covers matches (Affects us), not the whole feed.

## My calls

- One email per person, grouped by company (ADR 0139 calls).
- An item already marked not relevant before the digest goes out is left out.
- Items over 50 per company: the email lists the top 50 by urgency and links to the feed with the matching filter for the rest.

## Notes (technical)

- Per-user setting in the existing email preferences, a Celery Beat task per cadence (with a label), sent through the configured transport (SendGrid on staging, real mail; the Mail catcher switch from COM-1467 for the suite).
- Track `last_digest_sent_at` per user so a missed run catches up without repeating.
- The email is built from plain text from the sources (escaped). No remote images.
- Respect the person's time zone (ADR 0121).

**Chain:** on the chain (migration + API).

**Done when:** on staging, with the Mail catcher on:
- a manager on Daily gets a digest with E2E Test Company's new matches, grouped and ordered as above, each linking to its item page;
- switching to Off stops it;
- a day with no new matches sends nothing.