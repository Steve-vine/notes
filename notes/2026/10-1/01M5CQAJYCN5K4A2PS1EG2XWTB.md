---
id: 01M5CQAJYCN5K4A2PS1EG2XWTB
created: 2026-10-20T13:17:01.772538Z
updated: 2026-10-21T01:42:31.72341Z
type: task
title: A visitor whose link has expired can ask for a new one with one click — the request waits for an admin, and a new link only ever goes to the original email address
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1171
sprint: sq3fav7
blocked_by:
- 01M5CQA5YHKW5QWZ6KAMZ9Q9VE
comments:
- id: 01M5E1ZH594K7RG335PEJXFC78
  author: Steve Vine
  at: 2026-10-21T01:42:28.26545Z
  text: |-
    Done — merged in PR #1177.

    - A visitor who opens a link that expired in the last 12 months sees the company's logo and title, "Your access ended on 19 Nov 2026.", and an **Ask for a new link** button. It's one click with no form. They then see "We've asked Acme Ltd. If it's approved, a new link will be emailed to j•••@acme.com."
    - Every other bad link still gets the one "This link isn't valid" page: revoked, replaced by a resend, unknown, expired more than 12 months ago, trust centre switched off, or company archived.
    - In Requests the ask is marked **New link**. It shows when access ended, who invited them, their last visit and their history, and it raises an Actions to-do like any request.
    - **Approve**: pick a new end date and keep or change the restricted documents. The same visitor comes back with their history kept, and the new link goes to their original address only. The old link stays dead.
    - **Decline**: the usual polite email.
    - Asking again while a request waits does nothing, and asking is rate-limited.

    My calls:
    - The button doesn't reuse the expired link itself. The expired page carries a separate value that is only good for asking, lasts 60 minutes and is checked again when used, so an old link can never be turned back into a way in.
    - 12 months is the cut-off: an older link is treated as unknown.
assignee: steve
label:
- feature
priority: medium
task_status: review
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