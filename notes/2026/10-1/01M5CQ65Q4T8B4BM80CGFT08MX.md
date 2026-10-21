---
id: 01M5CQ65Q4T8B4BM80CGFT08MX
created: 2026-10-20T13:14:37.156694Z
updated: 2026-10-21T09:16:47.402687Z
type: task
title: The Visitors tab — invite someone by email, Compass sends them a link that lasts 30 days by default; resend, extend or revoke it; open up restricted documents for that person
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1160
sprint: sq3fav7
blocked_by:
- 01M5CQ5MSTTS7W7BGQPX163HHK
comments:
- id: 01M5DP5N6ERGVXNDM7JQKCZGM2
  author: Steve Vine
  at: 2026-10-20T22:16:06.094148Z
  text: |-
    Done — merged in two parts: #1165 (the Visitors tab) and #1168 (restricted documents).

    - A new Visitors tab lists everyone the company has let in: name, email, organisation, access until, status (Invited / Active / Expired / Revoked), last visit and who invited them. It can be searched, filtered by status and sorted.
    - Invite a visitor (page header): name, email, organisation, a reason, and access until the company's default (30 days) or a day you choose. You can also tick the restricted documents they may see; everyone-invited documents need no ticking. Compass emails them straight away from the company's sender, with its logo: who invited them, the link, and the day it stops working.
    - Inviting someone who is already a current visitor of this company opens that visitor instead. The same address can be a visitor of two companies.
    - Each visitor has a page:
      - Resend link: a new link, and the old one stops working.
      - Extend: moves the date and emails them the new one; their link keeps working.
      - Revoke: asks first, then ends access at once with no email.
      - Restricted documents: what they've been given, by whom and when, with Change to give or take away any document at any time.
      - History of everything above.
    - Nothing is sent while the trust centre is switched off or its address isn't set up. The Invite window says why.

    My calls:
    - Access runs to the end of the chosen day.
    - Once access has ended, Extend is refused and Resend is the way back in; it sets a new date as well.
    - Re-inviting someone whose earlier access was revoked or has ended creates a new visitor.
    - A grant survives a document being switched to "everyone invited", and counts again if it's made restricted again.
    - The visitor detail is a page rather than a side panel.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1158 and COM-1159.

## What people see

A **Visitors** tab: name, email, organisation, access until, status (Invited / Active / Expired / Revoked), last visit, invited by.

**Invite a visitor** (needs Manage trust centre visitors):

- name, email, organisation, and a reason (e.g. "Prospect — security review for the Acme deal");
- **access until**: the company's default (30 days) or a date of your choosing;
- **restricted documents**: tick any restricted documents this person may see. Everyone-invited documents need no ticking.

Compass emails the person straight away from the company's sender, with the company's logo: who invited them, a link, and when it stops working. The link opens the portal (the sign-in task adds the code step).

On a visitor:

- **Resend** sends a fresh link, and the old one stops working;
- **Extend** moves the access date (and tells them by email);
- **Revoke** ends access immediately, with no email;
- **Restricted documents** can be changed at any time.

The same email address can be a visitor of two companies separately. Inviting an address that's already an active visitor of this company opens that visitor instead.

A visitor's access ending is permanent for that link. To let them back in, extend before expiry, or resend.

## Notes (technical)

- `trust_centre_visitors` (company, name, email, organisation, reason, access_until, status, invited_by, source `invite | request`) and `trust_centre_visitor_documents` for restricted grants. Audited.
- Link tokens per ADR 0051 §1–§3, §5: `secrets.token_urlsafe(32)`, only the SHA-256 stored, one live token per visitor (resend revokes the previous one), expiry = access_until.
- The email through the mail transports with the Settings sender (ADR 0053); the portal URL from the new host value.

**Done when:** an Admin invites a visitor, the email arrives with a working link, and resend/extend/revoke behave as described.