---
id: 01M5Y9E3EYNKPHB5APGVZSWYYV
created: 2026-10-27T09:00:36.702216Z
updated: 2026-10-27T09:02:27.94424Z
type: task
title: Email sending moves into Integrations — SMTP, SendGrid and Amazon SES each a tile, Microsoft 365 a feature of the Microsoft tile, and any of them can be made the one Compass sends with
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1355
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
- 01M5Y9CK17NMDJM2N3P4GQYC4F
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 90, Integrations (ADR in COM-1347). Builds on COM-1349 and COM-1350.

## What people see

- **Tiles in the Email category:** **SMTP**, **SendGrid** and **Amazon SES**.
- **Microsoft 365 sending** appears as a feature on the Microsoft tile (COM-1350).
- **Each tile's Configure** holds that way of sending's settings, moved from Admin ▸ Email: server, port, credentials or API key, region, from address. It also has a **Send a test email** action.
- **Features** has one row, **Send Compass's email**. It is on for exactly one way of sending across all four. Switching it on for one moves sending there, after a confirmation naming the one it replaces. It can't be switched off while it's the only way set up. That would stop every notification, and the window says so.
- **Status:** health from the existing 5-minute check. The tile currently sending carries a "Sending" mark in the gallery.

## Who can do what

Manage integrations, as today.

## Notes (technical)

- Move `admin/EmailSection.tsx` into the four tiles.
- "One active" stays the `email_transports` rule it is today. The feature switch is how it's shown and changed, not a second store.

**Chain:** on the chain (API).

**Done when:**
- each way of sending is set up and tested from its tile;
- moving sending between two is one switch;
- Admin ▸ Email is gone.