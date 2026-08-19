---
id: 01M0DF407ZH5TGANYH2CNQPVJV
created: 2026-08-19T16:54:22.719982Z
updated: 2026-08-19T16:55:28.194452Z
type: task
title: The notifications that go quiet after one round — dedup, wording and a link that lands
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 296
sprint: sbph5q5
assignee: steve
label:
- bug
priority: high
task_status: todo
---
The email for the info loop is not missing — it is **suppressed after the first round**, which looks the same from a mailbox.

`notify()` dedups on `(user_id, kind, target_id, due_on IS NULL)` and returns early without considering `read_at`. Every requester notification uses `vendor_approval_decided` against the same request id. So the first question notifies; **the second question sends nothing, and neither does the eventual approval or rejection** — the row already exists, so the requester is never told the outcome of a request that was ever queried. The resubmit path already works around this by deleting the stale row before notifying; the decide path has no equivalent. That asymmetry is the bug.

- [ ] **Fix the dedup at the decide path**, matching the resubmit workaround — or better, make `notify()` treat a **read** notification as spent so the workaround is unnecessary in both places. The second is the real fix; the first is what ships if the blast radius of changing `notify()` is too wide for this task. Say which and why.
- [ ] **A dedicated `NotificationKind` for the info request** (and one for the response), rather than reusing `vendor_approval_decided`. Reusing it is what made two different events collide on one dedup key, and it is why the email cannot be worded for what actually happened.
- [ ] **Put the question in the email.** The body is currently generated from the status alone, and the subject renders as *"Vendor vendor onboarding info requested: Acme"* — `_KIND_NOUN` already contains "vendor onboarding" and the template prepends "Vendor". Fix the duplication, and carry the approver's question text (COM-295's message) into the body so the requester can read it without logging in.
- [ ] **The link has to land on the right page.** Every notification email currently deep-links to `app_link("/portal")` — the All Vendors register — regardless of kind or recipient. A requester needs `/portal/requests`, an approver `/portal/approvals`. Per-recipient, not per-sender: one event emails both sides.
- [ ] **Both directions**: approver asks → requester notified; requester responds (COM-295) → approvers notified. The response notification is new.
- [ ] Mail is best-effort — `send_or_warn` logs and returns `False` with no active transport (ADR 0044). The in-app notification must not depend on the send succeeding, which is already the ordering `vendor_requests` uses: commit the notification, then queue the email.
- [ ] Tests: two consecutive questions produce two notifications and two emails; the final approval after an info round still notifies; the email body contains the question; requester and approver links differ; a missing transport loses the email and keeps the notification.