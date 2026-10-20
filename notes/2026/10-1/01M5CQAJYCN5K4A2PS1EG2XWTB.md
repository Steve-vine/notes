---
id: 01M5CQAJYCN5K4A2PS1EG2XWTB
created: 2026-10-20T13:17:01.772538Z
updated: 2026-10-20T13:17:43.983412Z
type: task
title: A visitor whose link has expired can ask for a new one with one click — the request waits for an admin, and a new link only ever goes to the original email address
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1171
sprint: sq3fav7
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1170 (the Requests tab and approval).

## What people see

**On the portal:** opening an **expired** link shows the company's logo and "Your access ended on 19 Nov 2026" with **Ask for a new link**. One click; no form. They see "We've asked <company>. If it's approved, a new link will be emailed to j•••@acme.com."

A revoked or unknown link still gets the generic "isn't valid" page. Only an expiry offers this.

Asking twice while a request is waiting does nothing more.

**In the module:** the request appears in **Requests** marked "New link", with the visitor's history (when invited, by whom, last visit, what they downloaded), and as a to-do in Actions like any request.

- **Approve**: choose a new access-until date (default 30 days) and keep or change their restricted documents. A new link is emailed to the visitor's original address; the old link stays dead.
- **Decline**: the polite decline email.

## Notes (technical)

- Reuses COM-1170's `trust_centre_requests` with kind `new_link` and a visitor id; approval re-activates the existing visitor (keeping their history and NDA acceptances) and issues a new token.
- The expired-link page must distinguish expired from revoked using the stored token record; it must not reveal anything for an unknown token. A link expired more than 12 months ago gets the generic page.

**Done when:** on staging an expired visitor asks for a new link, an Admin approves it, and the new link arrives at the original address while the old one stays invalid.