---
id: 01KXEK4B3DA7M5J93CCASZYAF5
created: 2026-07-13T20:36:37.101744186Z
updated: 2026-07-14T19:31:41.962775919Z
type: task
title: UI was stricter than the server — deadlocked every T3 change
assignee: steve
task_status: done
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 59
sprint: sdcd2jr
label: null
---
Found by the ISE-53 exit test on the first real T3 delete. Introduced in ISE-51.

The Approvals screen greyed out Approve whenever `proposed_by == me && tier in (T2, T3)`. It never checked the ADMIN CARVE-OUT.

ADR 0017 permits an admin to self-approve for a specific reason: with a single human operator, the alternative is that no T3 change can EVER be approved. The UI omitted it, so it refused a change the server would have accepted — meaning **no T3 change could be approved through the UI at all, by anyone, ever**. Exactly the deadlock the carve-out prevents.

It fails safe, so it is not a security hole. It is worse in a quieter way: **a UI stricter than the server is a rule nobody wrote, enforced in the one place that cannot be audited.** The server permits the action and records `self_approval: true`; the UI simply said no and left no trace of having done so.

Fixed in PR #56: admin may self-approve, the button reads "Self-approve", and the card states the consequence before the click. Everyone below admin is still blocked, as the server blocks them.

**How it survived review:** the test asserted the bug. `SAMPLE_USER` is an admin and the test was named "a self-proposed T3 change cannot be approved from the UI" — it encoded the wrong mental model and then passed, confirming it. The test agreed with the code because the same author wrote both believing the same wrong thing. Only walking the path a real operator walks caught it.

Worth generalising: any place the UI decides what a user "can" do is a place it can silently diverge from the server. The server is the authority; the UI mirrors. A mirror that invents rules is not a mirror.