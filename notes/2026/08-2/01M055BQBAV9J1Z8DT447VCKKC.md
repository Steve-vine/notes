---
id: 01M055BQBAV9J1Z8DT447VCKKC
created: 2026-08-16T11:29:54.538234Z
updated: 2026-08-17T11:00:14.184504Z
type: task
title: Amazon SES transport — and say when it is still in the sandbox
project: 01KX671DATY39VW6GWK3M2T3DN
number: 746
sprint: s50x901
comments:
- id: 01M05M4Q6RC0BDDMCYMS50V5K6
  author: Steve Vine
  at: 2026-08-16T15:48:13.656645Z
  text: |-
    Built and pushed as PR #695 — move to Review.

    The sandbox is a named health state, as the task required. `GetAccount` answers `ProductionAccessEnabled` directly, and a sandboxed transport reports **degraded** naming the region, what SES will actually do ("accept every send and silently deliver only to verified addresses") and what to ask AWS for.

    Degraded rather than error, deliberately: a sandboxed account is a real working transport for verified recipients, and it is the state every SES account *starts* in. An operator mid-setup should see what is left to do, not a red tile with no explanation.

    The verified-sender check the task called optional is in, and it turned out to have two traps that a naive version gets wrong — both now tested:

    1. **SES verifies DOMAINS as well as addresses.** An address on a verified domain has no identity of its own, so `get_email_identity(address)` 404s. Checking only the address would report every correctly-configured domain-verified estate as broken. It falls back to the domain before concluding anything.
    2. **It has to be best effort.** An estate that granted only `ses:SendEmail` and `ses:GetAccount` must not read as broken over a missing courtesy permission. Any error other than "not found" is passed over; the send remains the authority.

    And it is reported as its **own** message rather than folded into the sandbox one — the two are fixed on different AWS console pages, and one message covering both sends an admin to the wrong one.

    Two other things worth recording:

    - **Attachments reuse the SMTP connector's MIME builder.** SES's `Simple` content cannot carry an attachment, so those go via `Raw` — which means composing MIME. Rather than a second implementation, `build_raw_payload` calls `smtp.build_mime`. One place decides how ISE's mail is shaped, and a fix to the alternative ordering or the attachment headers lands in both transports at once. A test asserts both payload builders agree on the envelope, so an attachment can never silently change who a message appears to be from.
    - **SES *is* HTTP**, so it takes the shared `http_bounds.boto_config()` bounds. Stated in the module docstring because the SMTP connector next door does the opposite, and the reason is the protocol — not "outbound mail is special".

    All four transports now exist and are interchangeable: the same `mail.send` call reaches any of them, and switching is one row.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
The fourth transport. Natural if the estate's mail already leaves through SES; the AWS credential and boto paths exist (ADR 0058).

Stacks on [ISE-743].

## Scope

`connectors/ses.py` over `sesv2.send_email`, boto client built through `http_bounds.boto_config()` (ADR 0058/0092 — SES *is* HTTP, unlike [ISE-744], so it uses the shared bounds).

- Credential: access key id + secret access key.
- Config: region, from address.

## `health_check` must report sandbox mode explicitly

`get_account()` returns whether production access has been granted. **In the sandbox, SES accepts the API call and then silently refuses every unverified recipient** — the send looks successful and the mail never arrives. That is exactly the class of invisible failure this project keeps re-learning (ISE-495..499: three of four integrations were broken with a green suite), so sandbox is a named health state on the tile, not a footnote.

Verified sender identity is the same shape of problem: a `from` address SES has not verified is rejected at send time. Worth checking in `health_check` too if `get_email_identity` makes it cheap.
