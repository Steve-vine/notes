---
id: 01M5CQ6K3F2F9N05BW2SASA25Q
created: 2026-10-20T13:14:50.863208Z
updated: 2026-10-21T09:16:47.411532Z
type: task
title: A visitor signs in to the trust centre with their link and a 6-digit code emailed to the invited address — on the portal's own web address, where every bad link gets the same "isn't valid" page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1161
sprint: sq3fav7
blocked_by:
- 01M5CQ65Q4T8B4BM80CGFT08MX
comments:
- id: 01M5DJA6C71W9T85RWSVN3FP16
  author: Steve Vine
  at: 2026-10-20T21:08:40.455805Z
  text: |-
    Done — merged in two parts: #1163 (the web address) and #1167 (sign-in).

    The trust centre's own address
    - Staging's trust centre is at trust.citops.net, with its certificate issued automatically.
    - The bare address shows a plain "This is a trust centre. Use the link you were sent." page.
    - Nothing of the employee app can be reached on that address: no sign-in page, no screens, no employee API, nothing of the vendor portal. The other way round, the trust centre's page isn't served on the employee or vendor-portal addresses, which work exactly as before.
    - The visitor's page is a small separate bundle that loads none of Compass's own screens.

    Signing in
    - Opening the link shows the company's logo and title and "We've sent a 6-digit code to j•••@acme.com". The code comes from the company's own sender, with the code in the body but not the subject line, so it doesn't show on a lock screen.
    - A code works for 10 minutes and allows 5 tries ("That code isn't right. You can try N more times."). A new code can be sent after 30 seconds.
    - A correct code signs them in for 12 hours, or until their access ends if sooner. Opening the link again in the same browser skips the code.
    - On first sign-in the visitor goes from Invited to Active, and "last visit" updates. The invitation email now says a code will follow.
    - Revoking the visitor, switching the portal off, access ending or signing out ends the visit at once. A visit ended by switching the portal off stays ended when it's switched back on.
    - Unknown, revoked, expired or tampered links, or a company whose portal is off, all get the same "This link isn't valid" page, naming nobody.

    My calls:
    - At most 10 codes per visitor per day. Without a cap, someone holding a forwarded link could keep guessing; with it, they get 50 guesses a day out of a million.
    - Resending a link also stops any sign-in half-way through on the old one. A visitor already signed in isn't affected.
    - The chart has no rate limiter of its own (the chart rules don't allow that kind of add-on). The app's limits are the ones that are guaranteed.
    - The trust centre page tells search engines not to index it, because links carry a credential. You may want the public request pages indexed later.

    For the production release: the Argo CD env needs the trust centre's host switched on (with its certificate), its address set, and a DNS name.
assignee: steve
label:
- feature
priority: high
task_status: done
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