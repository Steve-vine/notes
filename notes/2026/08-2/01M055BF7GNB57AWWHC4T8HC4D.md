---
id: 01M055BF7GNB57AWWHC4T8HC4D
created: 2026-08-16T11:29:46.224441Z
updated: 2026-08-16T11:30:54.619051Z
type: task
title: Microsoft 365 / Exchange Online transport — Graph sendMail
project: 01KX671DATY39VW6GWK3M2T3DN
number: 745
sprint: s50x901
assignee: steve
label:
- feature
priority: medium
task_status: backlog
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
