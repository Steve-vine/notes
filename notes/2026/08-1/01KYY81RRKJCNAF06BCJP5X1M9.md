---
id: 01KYY81RRKJCNAF06BCJP5X1M9
created: 2026-08-01T08:46:31.187041Z
updated: 2026-08-07T11:55:43.136863Z
type: task
title: Freshservice silently discards priority, status and tags on create
project: 01KX671DATY39VW6GWK3M2T3DN
number: 454
sprint: skxht3g
comments:
- id: 01KZ7AZ3JCKG4R7MXP8SHWMKX1
  author: Steve Vine
  at: 2026-08-04T21:30:39.564839Z
  text: |-
    Built — PR #465. No migration, no API change.

    Both ISE-side pieces done. **The question for you is still open and I have not pre-empted it:** whether a Freshservice Workflow Automator resets priority on create. The priority selector is deliberately KEPT — if an automation does override it, no ISE-side value wins that argument and the selector may not be worth having, but that is your call and nothing here forecloses removing it. Worth checking during the staging smoke now that ISE will actually tell you what the desk did.

    **1. Truthful completion.** `create_ticket` reads the ticket back and names any field the desk did not keep: "…(the desk overrode: priority Medium → Low; status Open → 20; dropped tags ise-generated)". Three rules keep it from becoming noise an operator learns to ignore:
    - only the three fields the smoke found being rewritten, compared by meaning — not a diff of a document full of server-owned fields;
    - **absence is never evidence of rejection, per field** — a read-back omitting `tags` says nothing, while `"tags": null` (the live case) says they were discarded;
    - a failed read-back does NOT fail the create. The ticket exists by then; refusing to report a successful create because a follow-up read 500ed would be a worse lie than the one being fixed.

    **2. Priority from severity.** Canonical ladder → Freshservice 1-4, mirrored in the modal and shown in the field's description so you can see what ISE chose, still overridable, and re-derived on each open so an escalation is picked up. `info` and `low` both land on Low — four rungs to ISE's five, and collapsing at the quiet end is the harmless direction.

    Worth noting: the pre-existing frontend test asserted `priority: 2` for a `high` incident. The test encoded the bug, so it now asserts 3.

    Also, the truthful-completion half is what makes ISE-453's failure mode visible in future — a dropped `ise-generated` tag now shows up in the timeline rather than passing silently.
assignee: steve
priority: medium
task_status: done
---
Found during the ISE-444 live smoke. ISE sends `priority: 2`, `status: 2`, `tags: ["ise-generated"]`; the Moneypenny desk stores `priority: 1`, `status: 20`, `tags: null`. `subject`, `description` and `type` are accepted, so the payload is parsed — these three are being overridden.

**Not a workspace or permission limit.** Across 390 recent tickets the priority spread is 301 Low / 63 Medium / 26 High, so priority is settable on that desk. Every ticket is in workspace 2, same as ISE's. Status 20 is a custom status. No ticket on the desk carries tags at all.

Most likely a Freshservice-side Workflow Automator or business rule firing on ticket creation. **Steve to confirm** — if an automation resets priority on create, no ISE-side change wins that argument, and knowing either way decides whether the priority selector in the Raise-ticket modal is worth keeping.

Two ISE-side pieces regardless of the cause:

**1. Truthful completion (ADR 0064 §6 / 0065 §4).** `create_ticket` reports "Raised Freshservice ticket #439018" and records `executed`, while three fields it sent were discarded. Those ADRs require `detail` to record only what the API confirmed. Read the created ticket back and report honestly when the desk overrode what ISE asked for — a one-call verify on a T1 action is cheap, and silence here is what let this go unnoticed.

**2. Priority should default from incident severity.** The Raise-ticket modal always offers Medium regardless of the incident. The smoke case was a `high` incident that got a Medium proposal and a Low ticket. Map the canonical severity ladder onto Freshservice's 1-4, still operator-overridable.

Blocked on the automation question only for whether to keep the selector; the truthful-completion half is worth doing either way.