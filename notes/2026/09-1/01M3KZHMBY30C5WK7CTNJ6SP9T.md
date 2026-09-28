---
id: 01M3KZHMBY30C5WK7CTNJ6SP9T
created: 2026-09-28T12:23:58.590086Z
updated: 2026-09-28T12:24:39.661278Z
type: task
title: notuvia-core feature-request module and send_feature_request command
project: 01KY6W9951TW0904DT0GGJVGE7
number: 468
sprint: svg0tvg
blocked_by:
- 01M3KZH6MVXRQFRJQ2F2S8QMRJ
assignee: steve
label:
- feature
priority: high
task_status: todo
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