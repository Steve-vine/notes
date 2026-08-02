---
id: 01KYY81FW7HW8JYS5A5R9KXK4K
created: 2026-08-01T08:46:22.087285Z
updated: 2026-08-02T14:13:50.253037Z
type: task
title: Freshservice feedback-loop guard depends on a field the desk discards
project: 01KX671DATY39VW6GWK3M2T3DN
number: 453
sprint: s5pft6a
assignee: steve
priority: high
task_status: backlog
---
**Live on main. ISE's own tickets are currently being ingested back into ISE and can feed the burst/cluster detectors.**

Found during the ISE-444 live smoke on the Moneypenny desk. ISE created ticket #439018 with `tags: ["ise-generated"]`; reading it back raw, Freshservice had stored `tags: null`. The ticket was then ingested as `fs-ticket:439018`. It has not reached a signal yet, but nothing prevents it.

Two causes, both ours to fix:

**1. The primary guard depends on the target system honouring a field.** `in_scope()` recognises ISE's own tickets solely by the `ise-generated` tag. Freshservice silently discarded it (see the sibling task for the wider field-dropping issue), so the guard is inert on that install.

**2. The secondary guard was specified but never implemented.** ADR 0068 §9 and the ISE-442 task both describe excluding ticket ids recorded in a `create_ticket` `ProposedChange.result`, with the explicit rationale that *"a desk agent can delete a tag, but ISE's own record cannot be edited from Freshservice"*. That is precisely the failure that occurred. It was written down, claimed in the PR description, and not built. `grep ProposedChange app/backend/src/ISE_api/freshservice.py` returns nothing.

**The design lesson, which is the point of this task:** a safety mechanism must not depend on a field the target system can silently discard. The ledger guard should become the **primary** cut, with the tag demoted to a human-visible convenience for desk agents.

Scope:
- Exclude ticket ids from executed `create_ticket` `ProposedChange.result.external_ref.id` for the system, in `in_scope()` — bounded and cached per sweep, not a query per ticket.
- Keep the tag as a secondary signal and for desk-agent legibility.
- Backfill: mark or delete the already-ingested `fs-ticket:439018` event so it cannot contribute to a cluster.
- Test that mirrors the live failure: a created ticket whose tag was stripped by the desk must still be excluded.

Note the summary card's `ise_raised_tickets` already reads the ledger, so the query shape exists.