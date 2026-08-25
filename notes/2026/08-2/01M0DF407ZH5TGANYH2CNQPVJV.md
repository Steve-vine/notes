---
id: 01M0DF407ZH5TGANYH2CNQPVJV
created: 2026-08-19T16:54:22.719982Z
updated: 2026-08-25T18:43:15.240555Z
type: task
title: The notifications that go quiet after one round — dedup, wording and a link that lands
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 296
sprint: sbph5q5
blocked_by:
- 01M0DF3B1KS8MPR6BK1J5MAQNV
comments:
- id: 01M0E5HB6NFVD82ZT0F3NMSTMA
  author: Steve Vine
  at: 2026-08-19T23:26:08.597274Z
  text: |-
    Shipped in PR #291.

    **The dedup was fixed at `notify()`, which the task preferred.** It offered the call-site workaround as the fallback "if the blast radius of changing `notify()` is too wide" — it isn't: `notify()` lives in `core/vendor_requests.py` and serves the vendor request paths only (the reminders engine has its own). So both halves landed: a `dedup=False` for an event that is a *thing that happened* rather than a standing state, and — where the dedup still applies — a **read** notification is now spent and no longer blocks the next one. The resubmit path's delete-the-stale-row workaround is deleted; it existed only to defeat this dedup, and its absence on the decide path was the asymmetry that hid the bug.

    Dedicated kinds `vendor_info_requested` / `vendor_info_provided` (migration **0087**, add-only). Wording fixed — `_KIND_NOUN` already began "vendor onboarding" and the title prepended "Vendor" — and the approver's question now travels in the body **prefixed with the area that asked it**, because a requester cannot answer "somebody has a question". The answer travels the other way.

    `notification_link()` maps kind → page. Because the two halves of one event carry different kinds (the approver is told a question was answered; the requester that one was asked), a per-kind map *is* a per-recipient link with neither side passed around.

    **Implementation note worth keeping:** `_outstanding_questions` filters the approvals the caller already loaded rather than re-querying. The session runs `autoflush=False`, so the question being asked *right now* is still pending and a fresh SELECT would not see it — the same reason `derive_status` works on that list. Caught by a test, not by review; the same trap bit COM-297's criticality rollup.

    Tests: two consecutive questions produce two notifications and two emails each carrying its own question; the final approval after an info round still notifies; the answer notifies approvers under its own kind and carries the answer; requester and approver links differ; a read notification no longer blocks; a missing transport loses the email and keeps the notification.
assignee: steve
company: null
label:
- bug
priority: high
task_status: done
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