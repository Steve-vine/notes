---
id: 01M055BQBAV9J1Z8DT447VCKKC
created: 2026-08-16T11:29:54.538234Z
updated: 2026-08-16T11:29:54.538234Z
type: task
title: Amazon SES transport — and say when it is still in the sandbox
assignee: steve
priority: medium
label: feature
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 746
tech: null
---
The fourth transport. Natural if the estate's mail already leaves through SES; the AWS credential and boto paths exist (ADR 0058).

Stacks on [ISE-741].

## Scope

`connectors/ses.py` over `sesv2.send_email`, boto client built through `http_bounds.boto_config()` (ADR 0058/0092 — SES *is* HTTP, unlike [ISE-742], so it uses the shared bounds).

- Credential: access key id + secret access key.
- Config: region, from address.

## `health_check` must report sandbox mode explicitly

`get_account()` returns whether production access has been granted. **In the sandbox, SES accepts the API call and then silently refuses every unverified recipient** — the send looks successful and the mail never arrives. That is exactly the class of invisible failure this project keeps re-learning (ISE-495..499: three of four integrations were broken with a green suite), so sandbox is a named health state on the tile, not a footnote.

Verified sender identity is the same shape of problem: a `from` address SES has not verified is rejected at send time. Worth checking in `health_check` too if `get_email_identity` makes it cheap.
