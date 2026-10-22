---
id: 01M5JTHEASHAXPM94X1ZVWWEN3
created: 2026-10-22T22:08:38.745622Z
updated: 2026-10-22T22:08:38.745622Z
type: task
title: A DDQ knows whether an NDA is in place — ticked with the signing date and a copy of the signed NDA, or recognised from the requester having accepted the trust centre's current NDA
label: feature
priority: high
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1254
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — migration + API

## What people see

The DDQ's details card has **NDA**:
- **Not in place** (default).
- **In place, signed** — the date signed and the signed copy (uploaded; classified Confidential automatically), optionally an expiry date.
- **In place, via the trust centre** — shown automatically when a trust centre visitor at the contact's email domain has accepted the company's **current** NDA wording: "Jane Smith (acme.com) accepted NDA v3 on 4 Oct 2026". Nobody has to tick anything.

An NDA that has expired, or a trust centre acceptance of an old wording, counts as **not in place**, and the card says why.

Changing the NDA position re-runs the sharing check on every answer and file (later tasks show the result).

**Done when:** a DDQ for a domain whose visitor accepted the current wording shows "in place via the trust centre"; a new NDA wording turns it back to not in place.