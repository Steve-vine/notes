---
id: 01M0686DE3CNWPZR15YQ4Z4AVE
created: 2026-08-16T21:38:40.707689Z
updated: 2026-08-17T12:58:43.262669Z
type: task
title: Amazon SES transport — and say when it is still in the sandbox
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 233
sprint: ssydm1m
blocked_by:
- 01M068503XXKPYFGD6AF6YCS8C
comments:
- id: 01M07WV1J70QJD4HRDWADR15D9
  author: Steve Vine
  at: 2026-08-17T12:58:42.63164Z
  text: 'Done and merged to main (PR #233, squash 5dd0caa). sesv2.send_email via boto3 (no new dependency) with explicit connect/read timeouts on the boto Config and no client-side retries. Health reports the sandbox as a named DEGRADED state — the message names the region, says exactly what SES will do ("accept every send and silently deliver only to verified addresses") and what to ask AWS for; degraded not error because every SES account starts there and it genuinely delivers to verified recipients. Both ISE-746 verified-sender traps pinned by tests: the domain fallback runs before concluding anything (an address on a verified domain has no identity of its own and 404s), and any error other than not-found is passed over — a missing courtesy permission never reads as broken. The sender finding is its own health message, never folded into the sandbox one. Attachments go via Raw reusing COM-231''s build_mime_message, with a test asserting the Simple and Raw payloads agree on the envelope. Region ships as the first required non-secret config (REQUIRED_CONFIG joined the transport contract; API 422s without it, the form requires it). One more zot/DockerHub pre-pull flake on CI (ryuk manifest 502 while zot''s on-demand sync waited on Docker Hub) — diagnosed against the zot pod, self-healed once the sync landed, re-run green.'
assignee: steve
label:
- feature
priority: medium
task_status: review
---
The fourth transport. `boto3>=1.34` is already a dependency (the S3 storage backend), so no new package. `sesv2.send_email`, with **explicit connect/read timeouts on the boto `Config`** — Compass has no shared HTTP-bounds layer and boto's defaults are generous.

Stacks on [COM-230].

## Scope

Credential: access key id + secret access key. Config: region; the from address is the shared transport identity ([COM-230]).

## `health_check` must report sandbox mode explicitly

`GetAccount` answers `ProductionAccessEnabled` directly. **In the sandbox, SES accepts the API call and then silently refuses every unverified recipient** — the send looks successful and the mail never arrives, the exact class of invisible failure this design keeps closing. Sandbox is a named health state: **degraded, not error** — a sandboxed account is a real working transport for verified recipients, and it is the state every SES account *starts* in; an operator mid-setup should see what is left to do, not a red tile. The message names the region, what SES will actually do ("accept every send and silently deliver only to verified addresses"), and what to ask AWS for.

## Verified sender — best effort, with the domain fallback

Check the from identity too, but two traps a naive `get_email_identity(from_address)` gets wrong (ISE-746 hit both, tests pinned them):

1. **SES verifies domains as well as addresses.** An address on a verified domain has no identity of its own and 404s — fall back to the domain before concluding anything, or every correctly-configured domain-verified deployment reads as broken.
2. **Best effort only.** An account granted just `ses:SendEmail` + `ses:GetAccount` must not read as broken over a missing courtesy permission — any error other than not-found is passed over; the send remains the authority.

Report it as its **own** health message, not folded into the sandbox one — the two are fixed on different AWS console pages, and one message covering both sends an admin to the wrong one.

## Attachments

SES `Simple` content cannot carry an attachment; those go via `Raw` — composed MIME. **Reuse the SMTP transport's MIME builder ([COM-231]) rather than writing a second one**: one place decides how Compass's mail is shaped, and a fix to the alternative ordering or attachment headers lands in both transports at once. A test asserts both payload builders agree on the envelope, so an attachment can never silently change who a message appears to be from.