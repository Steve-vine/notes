---
id: 01M0685HKXPGB5S5RTDQ5GC7KR
created: 2026-08-16T21:38:12.22143Z
updated: 2026-09-01T13:55:50.448966Z
type: task
title: SMTP transport — with its own explicit deadlines
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 231
sprint: ssydm1m
blocked_by:
- 01M068503XXKPYFGD6AF6YCS8C
comments:
- id: 01M07TAWS6TAAEX88Y3W09YE7A
  author: Steve Vine
  at: 2026-08-17T12:14:56.294248Z
  text: 'Done and merged to main (PR #231, squash a69e35e). The whole connection (host, port, security, username, password) lives in one encrypted blob and rotates together. Both ISE-744 deadline findings are in and pinned by tests that fail with either flipped off: explicit ~5s connect bound, ~60s command bound set on the socket once connected, and set AGAIN on the new socket object STARTTLS swaps in. Both judgement calls carried over: security=none health is degraded (message says everything crosses in clear — a private smarthost stays legitimate), and an unknown security value raises at the API (422) and at connect, never normalises. health_check connects, negotiates, authenticates and QUITs. build_mime_message is the single MIME shape (COM-233''s SES Raw path reuses it). ADR 0044 §5 executed: the import Job''s new seed-email-transport step creates one enabled, active SMTP row from the SMTP_* env values when the table is empty (idempotent; any existing row means an admin has taken over), so staging keeps Mailpit visibly as a row on Admin ▸ Email. Only backend-test flaked once on the zot registry (502 on image pre-pull — infra, re-run green).'
assignee: steve
label:
- feature
priority: medium
task_status: done
---
The second transport, and the one with the widest reach: a generic relay covers Mailpit (today's staging catcher — `scripts/infra/mailpit.yaml`), an internal smarthost, Google Workspace SMTP, Mailgun or SES-over-SMTP — anything that speaks the protocol. It is also the transport that **retires the env-driven sender**: the `smtplib` code in `core/email.py:32-37` is the seed, minus its silent no-op (consumers cut over in the consumers task).

Stacks on [COM-230].

## Scope

Credential fields: host, port, security (`none` / STARTTLS / implicit TLS), username, password — **all in the encrypted credential blob, not split between secret and config**: they are the shape of one connection, and splitting means two forms for one relay with rotate able to move only half of it (ISE-744's call). `health_check` connects, negotiates the chosen security, authenticates and quits — a wrong port or a refused login shows on the tile rather than at first send.

## The gotcha this task exists to get right

`smtplib`'s default timeout is the global socket default — *wait forever* — and an unbounded send from a Celery worker is a blocked queue. Worse, its constructor takes **one** `timeout` covering the connect AND every command after it: two different questions collapsed into one number. So (the ISE-744 findings, both asserted there by flipping each off):

- Set explicit deadlines: short connect (~5s — a TCP connection not made in 5s will not be made), generous command (~60s), re-set on the socket once connected.
- **And again after STARTTLS** — the upgraded connection is a *new socket object* that does not inherit the first deadline. Miss it and every post-handshake command sits on the connect bound, which is a slow relay reported as a broken one. This is the half a reviewer misses; it is not obvious from the stdlib docs.
- Assert both, on both sockets — the bound is invisible in behaviour until the day a relay stops answering.
- No library-level retry; the caller's retry policy is the retry.

## Two judgement calls to carry over (proven in ISE-744)

1. **`security=none` is `degraded`, not `error`.** Reachable and usable, and worth saying once that credentials and messages cross the network in clear — but a private-network smarthost is a legitimate deployment, and refusing it is Compass deciding an operator's network topology.
2. **An unknown `security` value raises rather than normalising.** A silent fall-back to STARTTLS is how a relay negotiates something the operator did not choose while the screen still shows the word they typed.

## Dev story

Mailpit becomes just an SMTP transport (its in-cluster host, security `none`) configured through Admin ▸ Email — plus whatever env-fallback/seed decision the ADR ([COM-230]) took for `smtp_*` in `core/config.py:84-89` / `chart/templates/configmap.yaml:54-61`, so local dev and staging are not left mailless.