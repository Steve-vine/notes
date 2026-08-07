---
id: 01KYY81FW7HW8JYS5A5R9KXK4K
created: 2026-08-01T08:46:22.087285Z
updated: 2026-08-07T11:55:47.046137Z
type: task
title: Freshservice feedback-loop guard depends on a field the desk discards
project: 01KX671DATY39VW6GWK3M2T3DN
number: 453
sprint: skxht3g
comments:
- id: 01KZ7AYTGC34B7QR4QPJADY0TD
  author: Steve Vine
  at: 2026-08-04T21:30:30.28456Z
  text: |-
    Built — PR #464, ADR 0081, migration 0097. PR CI green.

    Done as scoped: the ledger is now the PRIMARY cut and the tag is demoted to secondary. `ise_raised_ticket_ids` reads executed `create_ticket` results once per sweep and hands `in_scope` a set — bounded and cached per sweep, not a query per ticket, using the same query shape the summary card's `ise_raised_tickets` already uses, as you pointed out.

    Two scoping decisions worth confirming, both beyond the literal ask:
    - **Per System.** Ticket ids are per-desk, so a ticket ISE raised on one desk must not silence an unrelated ticket carrying the same number on another. The query filters on `system_id`.
    - **`executed` only.** A proposal that never ran created no ticket, so its id must not exclude a real one.

    The design lesson is recorded as ADR 0081 rather than only fixed in code, because it generalises past Freshservice: a guard protecting ISE from a third-party system must not depend on that system honouring anything. That reads directly onto every connector's write catalogue, so it seemed worth a decision record rather than a comment.

    One thing the ADR flags as a residual risk: the ledger cut goes blind for any ticket ISE raises through a path that writes no `ProposedChange`. There is none today (ADR 0017 makes every write a proposal), but a future direct write path to a service desk must extend the ledger rather than bypass it.

    Migration 0097 clears what the tag-only era already let in — including the live `fs-ticket:439018`. Deleting rather than flagging: a stored ticket event has no signal hanging off it by design, and the detectors count rows, so a flag would need every counting path to honour it, which is the same "one more place to forget" the task exists to close.

    **Sequencing note:** 0097 is stacked on 0096 (ISE-539), so #461 merges before #464 or the revision graph forks.

    Smoke: after the staging deploy, confirm `fs-ticket:439018` is gone from the Events screen, and that the next Freshservice sweep still ingests genuine user tickets normally.
assignee: steve
priority: high
task_status: done
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