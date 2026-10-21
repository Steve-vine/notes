---
id: 01M5CQA5YHKW5QWZ6KAMZ9Q9VE
created: 2026-10-20T13:16:48.465435Z
updated: 2026-10-21T01:25:47.671248Z
type: task
title: A company's public trust centre page where anyone can ask for access — they confirm their email with a code, the request waits in the Requests tab and admins' Actions, and an approval sends the usual invite
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1170
sprint: sq3fav7
blocked_by:
- 01M5CQ6K3F2F9N05BW2SASA25Q
comments:
- id: 01M5E10WYG81H8F78FZB16TXTK
  author: Steve Vine
  at: 2026-10-21T01:25:44.522961Z
  text: |-
    Done — merged in two parts: #1174 and #1176.

    - Anyone can open the trust centre's public page (trust centre address / the company's short name). It shows the logo, title and intro, plus a request form, and nothing else. An unknown company, a switched-off trust centre or an archived company all get the same "isn't valid" page.
    - The requester confirms their email with a 6-digit code: it lasts 10 minutes, allows 5 tries and can be resent after 30 seconds. They then see "Thanks — we'll email you if your request is approved." Requests that are never confirmed are thrown away after a day.
    - Confirmed requests appear in the Requests tab, and as an Actions to-do (emailed straight away) for everyone who can manage visitors.
    - Approve: the person becomes a visitor and gets the usual invite. The Approve window lists the company's restricted documents to tick, and the visitor sees those from their first visit.
    - Decline: a polite email that gives no reason. The note you write stays visible to colleagues only.
    - A second request from someone already waiting joins the first. An existing visitor gets an email pointing them to their link. The page never reveals who is already a visitor.

    My calls:
    - This is Compass's first form that anyone on the internet can submit, so it has limits: 10 requests an hour from one network and 5 an hour for one email address. If the store that counts them is down, the form refuses rather than letting everything through.
    - A hidden field catches bots. A bot gets the same answer as a person, so it can't tell it was caught.
    - If the person was invited directly while their request waited, approving it counts against that existing visitor and leaves their documents as they were.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1160 and COM-1161. Steve chose a public request page as well as invitations; nothing is shown until an admin approves.

## What people see

**Settings ▸ Public page** (Manage the trust centre): **Accept requests for access** on/off, and the page's **short name** (e.g. `acme`), giving `https://<trust centre address>/acme`. Short names are unique across companies; changing one breaks the old address. While off (the default), that address shows the generic "isn't valid" page.

**The public page:** the company's logo, title and intro, and a form: name, work email, organisation, and "Why do you need access?". Nothing else: no badges, documents or lists.

1. On submitting, Compass emails a 6-digit code to the address given. The request only goes ahead once they type it in (10 minutes, 5 tries). Unconfirmed attempts are discarded after a day.
2. They see "Thanks — we'll email you if your request is approved."
3. The request appears in the **Requests** tab and as a to-do in the Actions queue of everyone who can manage visitors for that company, with an email.

**Requests tab:** waiting requests (name, email, organisation, reason, when), plus decided ones with who decided.

- **Approve**: choose access until (default 30 days) and any restricted documents, as when inviting. The person becomes a visitor and gets the usual invite email.
- **Decline**: they get a polite email ("we're unable to give you access at this time"), with no reason. An optional note for colleagues is kept on the request.

A second request from the same email while one is waiting joins it rather than creating another. An email that's already a current visitor is told to use their existing link (by email, not on the page, so the page never reveals who is a visitor).

## Notes (technical)

- The first unauthenticated write route outside the link token. Rate limit per IP and per email in the app as well as at the ingress; a honeypot field. An unknown short name and a switched-off one return the same generic page.
- `trust_centre_requests` (company, name, email, organisation, reason, kind `access | new_link`, status, decided_by/at, note, confirmation code hash). Audited.
- Requests as an Actions source (ADR 0055); the email via `tell_now`.
- Add the new public routes to whatever allowlist tests guard unauthenticated routes (cf. the portal write-routes exact-set test).

**Done when:** on staging, a stranger asks for access on a company's public page, confirms the code, an Admin sees it in Requests and Actions, approves it, and the stranger receives a working invite; a declined one gets the decline email.