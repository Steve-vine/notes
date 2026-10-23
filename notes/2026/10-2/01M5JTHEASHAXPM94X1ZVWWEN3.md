---
id: 01M5JTHEASHAXPM94X1ZVWWEN3
created: 2026-10-22T22:08:38.745622Z
updated: 2026-10-23T18:06:19.68866Z
type: task
title: A DDQ knows whether an NDA is in place — ticked with the signing date and a copy of the signed NDA, or recognised from the requester having accepted the trust centre's current NDA
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1254
sprint: s5uw2fz
blocked_by:
- 01M5JTH9419EV25QEASPVJP5T7
comments:
- id: 01M5M6G6JK2GQWC20NRS93P83N
  author: Steve Vine
  at: 2026-10-23T10:56:55.379Z
  text: |-
    Done — merged in #1270 (eac5b5d8, migration 0625_ddq_nda).

    - The DDQ page has an **NDA** card under Details: **Not in place**, **In place, signed** or **In place, via the trust centre**.
    - **Via the trust centre** appears with nobody ticking anything when a trust centre visitor at the contact's email domain has accepted the company's current NDA: "Jane Smith (acme.com) accepted NDA v3 on 4 Oct 2026". A new NDA wording turns it back to Not in place, and the card says why ("…but the trust centre's NDA is now v4").
    - **Change** (Manage DDQs) records a signed NDA: the date signed, an optional expiry, and the signed copy — kept on the DDQ, marked Confidential, shown on the card rather than among the files.
    - Past its expiry an NDA counts as not in place ("The signed NDA expired on …"). Setting it back to Not in place archives the copy; nothing is destroyed. With no contact email the card says to add one.
    - Every change is in History; a sent, withdrawn or declined DDQ's NDA can't be changed.

    My calls:
    - A current signed NDA wins over the trust centre when both apply.
    - **Personal mail addresses** (gmail.com, outlook.com…) match only the contact's exact address, never the whole domain — otherwise any Gmail visitor would count as the client.
    - **A visitor whose trust centre access was revoked or expired still counts** — their acceptance was an agreement for their organisation. Say if you'd rather it lapsed with their access.
    - Exact domain only: subdomains don't match.
    - The signed date can't be after today; the expiry must be after it.
assignee: steve
label:
- feature
priority: high
task_status: done
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