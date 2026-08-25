---
id: 01M0PSK3QPGFTFE9XF06SSDKC9
created: 2026-08-23T07:50:33.462949Z
updated: 2026-08-25T18:42:52.314067Z
type: task
title: 'Notification grammar: "A engagement amendment request" — article must agree with the noun'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 375
sprint: sbph5q5
comments:
- id: 01M0Q000M7VBSHHD3XYJTMAWRE
  author: Steve Vine
  at: 2026-08-23T09:42:27.719013Z
  text: |-
    Done — PR #377, merged to main as bd049cc.

    `indefinite_article()` in `core/vendor_requests.py` now decides a/an from the noun, and the pending-approval notification (the one bare `f"A {noun} request…"`) uses it. Approvers read "An engagement amendment request for…", "A vendor onboarding request for…", "A new engagement request for…".

    The neighbouring sentences were checked as asked: "An edited {noun} request…" and "Your {noun} request…" put a fixed word before the noun, so they were already safe whatever a future kind brings — a test pins that so they stay safe.

    Tests are unit-level rather than caplog-around-the-write: the bug lives in the string, not the delivery, so `test_vendor_request_wording.py` covers the helper, the three kinds' opening words, and that every kind has a noun (a new kind without one would KeyError at notification time). One thing that fell out of writing them: `"" in "aeiou"` is True, so the naive membership test called an empty noun "an" — the helper tests against a frozenset.
assignee: steve
company: null
label:
- bug
priority: medium
task_status: done
---
The approver notification for an engagement amendment reads *"A engagement amendment request for…"*. `vendor_requests.py:427` hardcodes `f"A {noun} request…"` while `_KIND_NOUN` (line 87) supplies a vowel-initial noun for `amend_engagement`.

- [ ] Fix with article agreement, not a one-off: a tiny helper (an/a by vowel sound) or fold the article into the `_KIND_NOUN` values — either way, a future kind can't reintroduce the bug. Line 427 is the only bare `A {noun}`; the "An edited {noun}" (537) and "your {noun}" (775/778/790) sentences are already safe — check them anyway while there.
- [ ] Result: "An engagement amendment request for…", "A vendor onboarding request for…", "A new engagement request for…".
- [ ] Test: the three kinds' notification bodies each start with the right article (caplog at INFO around the notification writes — the WARNING-level trap has bitten before).