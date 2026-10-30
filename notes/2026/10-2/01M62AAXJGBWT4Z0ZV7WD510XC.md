---
id: 01M62AAXJGBWT4Z0ZV7WD510XC
created: 2026-10-28T22:33:18.672987Z
updated: 2026-10-30T08:01:13.266345Z
type: task
title: Auditors comment and accept in the portal — comment on a request or finding, mark a request Accepted or Need more, accept a corrective action plan and a closure; owners hear about it in Actions, and auditors get a daily email of what's newly provided
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1432
sprint: swcbxt0
blocked_by:
- 01M62AAHPF64H86BWBEH4X8545
comments:
- id: 01M6460SMHC4QC683HAWZGWFDJ
  author: Steve Vine
  at: 2026-10-29T15:56:21.520903Z
  text: |-
    Done — PR #1449 (stacked on #1448). Migration 0738.

    What's there: in the portal, Comment (always shared), Accept / Need more on a provided request, Accept plan / Plan needs work and Accept closure / Closure not accepted on a finding, and "New since your last visit". They use the same rules as Compass, so the screen and portal can't disagree. In Compass each one shows as "<auditor>, <firm>"; the audit's Overview shows Waiting on the auditor / Waiting on us. A daily email to each auditor at 08:00 UK time, only when something changed — counts and a link, never evidence or comment text.

    My calls, for you to overturn:
    1. An auditor's comment sits in Actions for the owner(s) and the audit lead until anyone at the company comments after it.
    2. The email counts what changed since the last one (requests provided, plans and closures submitted, the company's shared comments); it links to the portal's address, which asks for the link from the invitation — the personal link isn't re-sent.
    3. A closed audit takes no more comments or verdicts from the portal, though open findings carried on are still worked in Compass.
    4. Need more and other sending-back verdicts reach the owner through the existing Actions items rather than a separate email.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 97, Audit Management (ADR 0133, COM-1425).

## What people see

**In the portal:**
- On a **request**: **Comment** (always shared), **Accept**, **Need more** (needs a comment). A request that hasn't been provided can be commented on but not accepted.
- On a **finding**: **Comment**, **Accept plan** / **Plan needs work**, then **Accept closure** / **Closure not accepted**.
- **"New since your last visit"** at the top: requests provided or provided again, new findings responses, new shared comments.
- Verdicts are final. A mistaken one is answered by the next verdict ("Need more" after "Accepted"), and both stay in the history.

**Inside Compass:**
- Each verdict and comment appears on the request or finding as "<auditor>, <firm>", with the time. The owner gets an Actions item for **Need more**, **Plan needs work** and **Closure not accepted**. A new auditor comment goes to the owner and the audit lead.
- The audit's Overview shows **Waiting on the auditor** (requests provided but not yet reviewed) and **Waiting on us** (open, need more, plans to write).

**Email to auditors** (optional per auditor, on by default): one email a day at 08:00 UK time, only when something changed: "3 requests provided, 1 corrective action plan submitted for AUD-12", with a link to the portal. It never includes the evidence or comment text.

## Who can do what

An auditor can do these things only within their audit, and only while their access lasts. They can't add, edit or withdraw a request, a finding or evidence.

## Notes (technical)

- Portal write routes under `/api/auditor/…` go through `core/audits/status.py` (COM-1430), so the screen and portal share every rule.
- These routes are the **only** writes an external party makes, so add them to an exact-set test like the vendor and Trust Centre portals' (see memory "Portal write-routes allowlist").
- Daily email: a Beat task, idempotent per (auditor, day), through the mail ledger, using ADR 0121 for UK time.
- An Actions source for owners and the audit lead (extends COM-1427/1429's sources rather than adding a new one where possible).

**Chain:** on the chain (API).

**Done when:** on staging, as an auditor in the portal, Steve marks one request Need more with a comment and accepts another. The owner sees the Need more in Actions; the next morning's email arrives after the owner provides again.