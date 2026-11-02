---
id: 01M6EKVJF3180CZQ44YHK8HK6G
created: 2026-11-02T17:10:34.723705Z
updated: 2026-11-02T17:11:58.921323Z
type: task
title: The Security Feed email digest — each person chooses daily, weekly or off; one email lists the new and changed matches for every company they can see, grouped by company, most urgent first
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1524
sprint: s6xh9g1
blocked_by:
- 01M6EKSK3GGHY1E8J0FQPE60NV
assignee: steve
label:
- feature
priority: medium
task_status: todo
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