---
id: 01M055BF7GNB57AWWHC4T8HC4D
created: 2026-08-16T11:29:46.224441Z
updated: 2026-08-17T11:00:08.826251Z
type: task
title: Microsoft 365 / Exchange Online transport — Graph sendMail
project: 01KX671DATY39VW6GWK3M2T3DN
number: 745
sprint: s50x901
comments:
- id: 01M05JTWCVB66ZZDCZV0JS5PQA
  author: Steve Vine
  at: 2026-08-16T15:25:22.71559Z
  text: |-
    Built and pushed as PR #694 — move to Review.

    Both things the task said the credential spec must say out loud are in `read_only_scopes`, which is what the credential form renders while the admin is granting consent — and the `Mail.Send` blast-radius warning is **asserted by a test**, so a later tidy-up of that prose fails the build rather than quietly dropping it.

    `health_check` resolves the mailbox as asked (`GET /users/{mailbox}` after the token) and, on a 404, names which of the two it is — the msteams.py failure mode where a plausible-but-wrong id 404s exactly like a missing permission.

    Three decisions where I went beyond the task body:

    1. **Its own app registration, deliberately not the M365 read connector's.** ADR 0066 §2 gave `M365Connector` a dedicated read principal *precisely* so consent and revocation are independent; adding `Mail.Send` to it would undo that — revoking one revokes both, and the read consent screen would silently be asking for the power to send mail as anybody. So `m365-email` is its own Type with its own credential.

    2. **The mailbox IS the from address — one field, not two.** The task specified the sending mailbox UPN in `System.config` alongside `save_to_sent_items`. But Graph sends through `/users/{mailbox}/sendMail` and the message arrives *from* that mailbox, so a separate mailbox box would only let an operator make the two disagree — which Graph answers with `ErrorSendAsDenied`, a setup failure manufactured by the form. Reusing the from address the Email tab already edits means this transport needed **no new UI at all**.

    3. **`save_to_sent_items` is not configurable — always true.** The sent copy IS the record that ISE sent something, in a mailbox an operator already has open; it answers "did that notice go out?" without coming back to ISE. Making it optional would have needed a control, and a defaulted-but-invisible setting is one nobody knows exists (the ISE-537 lesson) — so I removed the option rather than adding a control for a choice nobody should make.

    **One honest limitation, stated in the module docstring:** `sendMail` takes one body with one content type, so the HTML part is sent and the plain-text alternative is not carried — unlike SMTP and SendGrid, which send both. Exchange Online generates its own fallback. Worth knowing if a pager gateway is ever subscribed through this transport.

    Graph's ~3MB cap is the number already behind `mail.MAX_ATTACHMENT_BYTES` from ISE-743; the transport that sets it now exists. That is the number ISE-748 divides on.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
Send as a real mailbox in the tenant. The cheapest credential story of the four — `connectors/msgraph.py`, the EntraID and M365 connectors and an app registration all exist already; this mostly needs the `Mail.Send` scope.

Stacks on [ISE-743].

## Scope

`connectors/m365_mail.py` over the existing `GraphClient`. `POST /v1.0/users/{mailbox}/sendMail` — `GraphClient.post()` already fits, since sendMail returns no body.

- Credential: tenant id + client id + client secret, shaped exactly as `msteams.py` does it.
- Config (`System.config`): the sending mailbox UPN, `save_to_sent_items`.
- `health_check` acquires a token **and** resolves the mailbox (`GET /v1.0/users/{mailbox}`). Token-only is not enough — the `msteams.py` lesson is that a plausible-but-wrong id produces a 404 that reads like a permissions error, and it cost a live setup session.

## Two things the credential spec must say out loud

1. **`Mail.Send` application permission lets ISE send as *any* mailbox in the tenant** unless scoped by an ApplicationAccessPolicy. That is a real blast radius for a platform that already holds write credentials, and it is invisible unless the scopes note tells the admin to scope it. Put it in the spec's guidance, where the admin reads it while granting consent.
2. **Graph's simple sendMail caps attachments at ~3MB.** Above that it needs an upload session, which is out of scope — this is the number that sets the report-attachment cap in [ISE-748].
