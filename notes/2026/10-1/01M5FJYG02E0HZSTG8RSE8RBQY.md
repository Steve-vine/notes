---
id: 01M5FJYG02E0HZSTG8RSE8RBQY
created: 2026-10-21T15:58:14.530139Z
updated: 2026-10-21T20:16:50.867836Z
type: task
title: '"Overdue" on plan, attestation and portal screens follows the reader''s own day'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1195
sprint: ss8348q
comments:
- id: 01M5FPE6XDEVQFCW3K0FBRS13A
  author: Steve Vine
  at: 2026-10-21T16:59:15.24587Z
  text: |-
    Done — PR #1209, merged 21 Oct 17:56 BST.

    - The Security Assurance Plan's Schedule, entry pages, Overview and Coverage mark an entry overdue from the reader's own midnight, the same moment Actions does.
    - Attestation pages count a person as overdue, and show a round's days left, on the reader's own day. That covers Open, a round's people, Compliance by role, document and person, a person's record, a document's attestation card and the running round on a role's Content tab.
    - In the User Portal the same rule applies to the reader's documents to sign, their plan entries, and "review overdue" on their assets.
    - For a New York reader, something due 12 Nov turns overdue at New York's midnight on all of these and in Actions. A London reader sees no change.
    - A plan entry's "Completed on" can't be the reader's tomorrow, and a date that's already today for them is allowed. When the assistant marks an entry done without a date, it uses the person's own today.
    - A repeating plan activity counts "today" on its own schedule's clock. Background jobs stay on the deployment's clock.

    My calls:
    - Opening rounds and assigning attestations still run on the schedule's own clock (as COM-1186 decided). On a role's Content tab, "next opens" follows the schedule; only the running round's overdue count and days left follow the reader.
    - I included the portal's asset "review overdue", since it's a portal page that shows overdue items.

    Still on the deployment's day, not changed: the plan's export and evidence of operation, Inventory's own review-overdue flags (internal screens), and some assistant tools' default "today" (vendors, gaps, risks, reports). Say if you want a task.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Found while building COM-1186 (sprint 79), which moved Actions and the digests onto each reader's day. Follows ADR 0121 §3.

**What's wrong:** a few screens still decide "overdue", "due today" or "today" on the server's clock (the UK day, or UTC):
- the **Security Assurance Plan** screens' own overdue flags on activities and entries
- the **attestation** pages (a round or a person's signing due / overdue)
- the **portal** pages that show due or overdue items

So a New York reader can see something marked overdue on these screens while Actions says it's still due today, or the other way round.

**What it should do:** these screens judge "today", "due today" and "overdue" on a dated item by the reader's own day, exactly as Actions does. An exact-moment deadline is still overdue at that moment for everyone. Background jobs stay on the deployment clock.

**Done when:** for a New York reader, an item due 12 Nov shows overdue on these screens at New York's midnight, the same moment Actions does, and a London reader sees no change.