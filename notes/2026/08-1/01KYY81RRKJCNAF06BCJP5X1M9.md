---
id: 01KYY81RRKJCNAF06BCJP5X1M9
created: 2026-08-01T08:46:31.187041Z
updated: 2026-08-02T14:15:50.648031Z
type: task
title: Freshservice silently discards priority, status and tags on create
project: 01KX671DATY39VW6GWK3M2T3DN
number: 454
sprint: s5pft6a
assignee: steve
label: null
priority: medium
task_status: backlog
---
Found during the ISE-444 live smoke. ISE sends `priority: 2`, `status: 2`, `tags: ["ise-generated"]`; the Moneypenny desk stores `priority: 1`, `status: 20`, `tags: null`. `subject`, `description` and `type` are accepted, so the payload is parsed — these three are being overridden.

**Not a workspace or permission limit.** Across 390 recent tickets the priority spread is 301 Low / 63 Medium / 26 High, so priority is settable on that desk. Every ticket is in workspace 2, same as ISE's. Status 20 is a custom status. No ticket on the desk carries tags at all.

Most likely a Freshservice-side Workflow Automator or business rule firing on ticket creation. **Steve to confirm** — if an automation resets priority on create, no ISE-side change wins that argument, and knowing either way decides whether the priority selector in the Raise-ticket modal is worth keeping.

Two ISE-side pieces regardless of the cause:

**1. Truthful completion (ADR 0064 §6 / 0065 §4).** `create_ticket` reports "Raised Freshservice ticket #439018" and records `executed`, while three fields it sent were discarded. Those ADRs require `detail` to record only what the API confirmed. Read the created ticket back and report honestly when the desk overrode what ISE asked for — a one-call verify on a T1 action is cheap, and silence here is what let this go unnoticed.

**2. Priority should default from incident severity.** The Raise-ticket modal always offers Medium regardless of the incident. The smoke case was a `high` incident that got a Medium proposal and a Low ticket. Map the canonical severity ladder onto Freshservice's 1-4, still operator-overridable.

Blocked on the automation question only for whether to keep the selector; the truthful-completion half is worth doing either way.