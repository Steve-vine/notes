---
id: 01M0PSK3QPGFTFE9XF06SSDKC9
created: 2026-08-23T07:50:33.462949Z
updated: 2026-08-23T07:50:33.462949Z
type: task
title: 'Notification grammar: "A engagement amendment request" — article must agree with the noun'
priority: medium
assignee: steve
label: bug
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 375
---
The approver notification for an engagement amendment reads *"A engagement amendment request for…"*. `vendor_requests.py:427` hardcodes `f"A {noun} request…"` while `_KIND_NOUN` (line 87) supplies a vowel-initial noun for `amend_engagement`.

- [ ] Fix with article agreement, not a one-off: a tiny helper (an/a by vowel sound) or fold the article into the `_KIND_NOUN` values — either way, a future kind can't reintroduce the bug. Line 427 is the only bare `A {noun}`; the "An edited {noun}" (537) and "your {noun}" (775/778/790) sentences are already safe — check them anyway while there.
- [ ] Result: "An engagement amendment request for…", "A vendor onboarding request for…", "A new engagement request for…".
- [ ] Test: the three kinds' notification bodies each start with the right article (caplog at INFO around the notification writes — the WARNING-level trap has bitten before).