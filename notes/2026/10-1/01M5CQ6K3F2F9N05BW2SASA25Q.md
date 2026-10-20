---
id: 01M5CQ6K3F2F9N05BW2SASA25Q
created: 2026-10-20T13:14:50.863208Z
updated: 2026-10-20T18:22:33.182695Z
type: task
title: A visitor signs in to the trust centre with their link and a 6-digit code emailed to the invited address — on the portal's own web address, where every bad link gets the same "isn't valid" page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1161
sprint: sq3fav7
blocked_by:
- 01M5CQ65Q4T8B4BM80CGFT08MX
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1160. Steve chose link + emailed code so a forwarded link is useless.

## What people see

1. The visitor opens their link. The page shows the company's logo and title and says "We've sent a 6-digit code to j•••@acme.com".
2. They type the code. It lasts 10 minutes and allows 5 tries; "Send a new code" is there after 30 seconds.
3. They're in. The visit lasts 12 hours on that browser, or until their access ends, whichever comes first. Opening the link again on the same browser within that time skips the code.

The visitor's status moves from Invited to Active on their first sign-in, and "last visit" updates.

**A bad link:** unknown, revoked, or for a company whose portal is switched off, all show the same "This link isn't valid" page. It names no company and no person. (An expired link gets the "ask for a new link" option in its own task; until then it's the same page.)

**Signing out** ends the visit on that browser.

## Notes (technical)

- A new router outside `/api/v1`, e.g. `/api/trust-centre/…`, with no user-guard dependency anywhere in it (ADR 0051 §6 reasoning). Only one route takes the link token; the rest take the visit session.
- Code: 6 digits, store a hash, 10-minute expiry, 5 attempts, resend throttled. Session: a random token in an `HttpOnly; Secure; SameSite=Strict` cookie scoped to the trust centre host, hash stored, ends at min(12h, access_until), ended by revoke/portal off.
- The chart: a third `Ingress` host for the trust centre (off by default), modelled on the vendor portal's. Frontend: a separate entry or route tree that loads none of the internal app (the lesson of "Signing in shows a portal user the app they are not allowed in"). Staging values need the host; production needs it in the Argo CD env Application. Rate limiting annotations on the ingress.
- Integration tests for: wrong code ×5, expired code, revoked mid-session, portal switched off mid-session, the identical rejection bodies.

**Done when:** an invited visitor gets in with link + code on staging's trust centre address, and every failing case shows the same page.