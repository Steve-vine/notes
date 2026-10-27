---
id: 01M5Y9BDEE2W7W432G1MVTMQB5
created: 2026-10-27T08:59:08.62295Z
updated: 2026-10-27T10:45:18.550373Z
type: task
title: 'ADR: the Integrations library — every outside platform Compass talks to is one tile under Admin, showing what it does, how it''s set up, which features are on and how it''s doing'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1347
sprint: s8fmesf
comments:
- id: 01M5YFDS1WYB20H13R6FXDENP8
  author: Steve Vine
  at: 2026-10-27T10:45:17.499968Z
  text: |-
    Done — PR #1364, merged to main.

    - ADR 0128 "The Integrations library" (decisions/0128-the-integrations-library.md): one tile per platform (12, table in §2), the four tabs, the three tile states, feature switches with a table of what "off" does for every existing feature (§6), and who sees what (§7), with permissions unchanged and Polaris not an integration.
    - Three switches show a setting that already exists, rather than a second store: Sign in with Microsoft (sign-in's own enabled), Send Compass's email (the one-active transport rule) and Keep Compass's files (the attachment store's backend). Everything else uses one new switch table, where a missing row means on.
    - IA brief: a new "Admin" section saying where Integrations lives (/admin/integrations, between Admin and Activity) and what a tile page holds; the nav table mentions it.

    My calls, written into the ADR's "Calls made in planning" section:
    - health checks keep running while a feature is off, so Status never goes stale;
    - a Status tab lists every company's accounts to someone holding Inventory admin or manage integrations.

    I didn't add "Amended by" lines to the 11 earlier ADRs. The amendments are listed in 0128's own header.
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint 90, Integrations. The first task; every other task in the sprint builds on the decision it records.

This sprint is the first of four toward a **Vulnerabilities** module. Steve's plan (2026-10-27):
- 90: the Integrations library (this sprint);
- 91: the vulnerabilities register;
- 92: scanner sources (Nessus, Aikido, pen-test PDFs);
- 93: cloud sources (AWS Security Hub and Inspector, Microsoft Defender for Cloud, Google Security Command Center), with Inventory's findings folded in.

The library is modelled on Datadog's integrations page.

## What the ADR decides

- **One tile per platform**, not one per connection. A tile holds everything Compass does with that platform. Microsoft is one tile, holding Entra (the directory), Exchange, SharePoint, sign-in and sending email. Azure (the cloud subscriptions) is a separate tile.
- **Every tile page has the same four tabs:**
  - **Overview**: what Compass does with the platform, what it reads, what it changes, and what it needs granted on the platform's side;
  - **Configure**: credentials, settings and, where relevant, each company's accounts;
  - **Features**: each use of the platform, switched on or off on its own;
  - **Status**: health, the last read, and recent errors.
- **A feature switched off stops Compass using the platform for that thing.** Credentials and history are kept, so switching it back on resumes where it left off.
- **Permissions don't change** (Steve, 2026-10-27: "keep today's permissions"):
  - cloud accounts are still set up by whoever holds the Inventory admin right;
  - Microsoft, AD, sign-in, email and storage stay with whoever manages integrations.
  - The gallery shows to anyone who holds either right. A tile they can't configure opens read-only.
- **Polaris is not an integration** (Steve, 2026-10-27). Admin ▸ Polaris keeps its AI provider keys, model, limits and spend exactly as today, and there are no AI tiles.
- **Each company's accounts live on the platform's tile.** Examples are AWS accounts and organisations, Azure subscriptions and tenants, and Google Cloud projects and organisations. They are no longer on Inventory ▸ Settings.
- **Tile states:**
  - **Connected**: set up and healthy;
  - **Needs attention**: something set up is failing, or a certificate or key is expiring;
  - **Not set up**.
- **Categories:**
  - Cloud;
  - Identity & directory;
  - Email;
  - Storage;
  - Security tools;
  - Reference data.
- **What it reverses or amends:** where connections are configured (Inventory ▸ Settings, and the Admin Integrations, Email and Attachments tabs). Record which earlier ADRs this amends: 0034, 0044, 0045, 0074, 0075, 0083, 0099, 0101, 0103, 0104, 0108.

## Notes (technical)

- Next free ADR number after 0127.
- IA brief: replace the Admin ▸ Integrations description, and add Integrations to the Admin nav group.
- Feature switches: one place that records, per integration and feature, whether the feature is on. Schedulers and readers check it before doing work. Spell out what "off" does for each existing feature, in a table in the ADR.

**Chain:** independent (documents only).

**Done when:** the ADR is merged and the IA brief says where Integrations lives.