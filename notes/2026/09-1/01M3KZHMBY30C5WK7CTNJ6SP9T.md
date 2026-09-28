---
id: 01M3KZHMBY30C5WK7CTNJ6SP9T
created: 2026-09-28T12:23:58.590086Z
updated: 2026-09-28T13:05:52.86729Z
type: task
title: notuvia-core feature-request module and send_feature_request command
project: 01KY6W9951TW0904DT0GGJVGE7
number: 468
sprint: svg0tvg
blocked_by:
- 01M3KZH6MVXRQFRJQ2F2S8QMRJ
comments:
- id: 01M3M1YANSSJVWZ3BK9HK29GVY
  author: Steve Vine
  at: 2026-09-28T13:05:51.796468Z
  text: |-
    Built. PR #473 (brief-468-feature-request-client), in Review.

    What landed:
    - notuvia-core/src/feature_request.rs. send() validates the fields against the Worker's rules, builds the closed ADR 0065 payload and POSTs it with curl, with the body on stdin via --data-binary @-.
    - It returns Sent{id} or a SendError, serialised as {kind,…}: invalid{field}, offline, timeout, rate_limited, rejected{status}, server{status}, failed{message}.
    - Debug builds post to http://127.0.0.1:8787.
    - checkin::install_id reads the id. If it has to mint one, it does so under a blocking checkin.lock, so there's only ever one id per machine.
    - The send_feature_request Tauri command is registered.

    Decided along the way:
    - No --fail. --write-out appends the HTTP status, so 429 and 400 are told apart without guessing from curl's exit code 22.
    - A write error on curl's stdin is ignored. It only happens when curl has already exited, and curl's exit code gives the real reason (e.g. offline) rather than "broken pipe".
    - Details are sent as typed, not trimmed. Only a blank value is dropped.

    Verification: 22 check-in and feature-request tests passed (13 new), and the pre-push hooks all passed. An end-to-end run through real curl with a throwaway example (not committed): with no Worker running it returned offline; against local wrangler dev it returned 5 × ok then rate_limited. The stored rows carried checkin.json's install id, and the unicode multi-line details arrived intact.
assignee: steve
label:
- feature
priority: high
task_status: review
tech:
- rust
---
The client side of ADR 0065: build the payload and POST it, returning a result the UI can act on. **Unlike the check-in, this is not fire-and-forget.** The user is waiting and needs to know whether their request arrived.

## Agreed work

- [ ] A new `notuvia-core/src/feature_request.rs`. A `send(config_dir, email, summary, details) -> Result<Sent, SendError>` builds exactly the ADR 0065 payload and POSTs it to `https://checkin.notuvia.net/v1/requests`.
- [ ] **install_id:** take it from `checkin.json` through a new `checkin::install_id(config_dir)` that reads the id, or mints and saves one under the existing `checkin.lock`. Don't mint a second id.
- [ ] Validate on the client with the same rules as the Worker (email shape, summary 1–120 chars on one line, details ≤ 4000). The UI can then show field errors without a round trip, and a `400` from the server means a client bug.
- [ ] Transport is the system `curl`, the same as `checkin::post`, but **send the body on stdin (`--data-binary @-`), never in argv**. Argv would put the email and message in the process list and hit the Windows command-line limit. Keep `CREATE_NO_WINDOW` on Windows. Timeouts: connect 5s, max 15s.
- [ ] Map outcomes to a typed error the UI can word: offline or can't connect / timed out / rate-limited (`429`) / rejected (`4xx`) / server error (`5xx`). On `201`, return the server's request `id`.
- [ ] **Debug builds** POST to `http://127.0.0.1:8787/v1/requests` (the `wrangler dev` default) rather than the live Worker, so development never files real requests.
- [ ] A Tauri command `send_feature_request(email, summary, details)` in `lib.rs` wrapping it with `app_config_dir()`. Register it in the invoke handler and the capabilities if needed.
- [ ] Unit tests: the payload is exactly the closed field list, validation edges, the install_id is shared with the check-in (one id), and error mapping from curl exit codes and HTTP status.
- [ ] Run `cargo fmt --check` and `clippy -D warnings`.