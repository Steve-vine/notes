---
id: 01M5FJYG02E0HZSTG8RSE8RBQY
created: 2026-10-21T15:58:14.530139Z
updated: 2026-10-21T15:58:14.530139Z
type: task
title: '"Overdue" on plan, attestation and portal screens follows the reader''s own day'
priority: medium
assignee: steve
label: improvement
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1195
---
Found while building COM-1186 (sprint 79), which moved Actions and the digests onto each reader's day. Follows ADR 0121 §3.

**What's wrong:** a few screens still decide "overdue", "due today" or "today" on the server's clock (the UK day, or UTC):
- the **Security Assurance Plan** screens' own overdue flags on activities and entries
- the **attestation** pages (a round or a person's signing due / overdue)
- the **portal** pages that show due or overdue items

So a New York reader can see something marked overdue on these screens while Actions says it's still due today, or the other way round.

**What it should do:** these screens judge "today", "due today" and "overdue" on a dated item by the reader's own day, exactly as Actions does. An exact-moment deadline is still overdue at that moment for everyone. Background jobs stay on the deployment clock.

**Done when:** for a New York reader, an item due 12 Nov shows overdue on these screens at New York's midnight, the same moment Actions does, and a London reader sees no change.