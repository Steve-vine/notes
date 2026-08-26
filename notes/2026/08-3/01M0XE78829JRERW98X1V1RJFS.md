---
id: 01M0XE78829JRERW98X1V1RJFS
created: 2026-08-25T21:46:31.554696Z
updated: 2026-08-26T09:46:32.274644Z
type: task
title: Every module declares its actions — and the work that was only ever an email appears
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 409
sprint: sbph5q5
blocked_by:
- 01M0XE6NEYM936EBGSGTEHYK2J
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: active
---
ADR 0055 §3 and §4. Depends on COM-408.

The queue knows five kinds of work and has not grown since it was built.
Everything Vendors, Access and Recertification have added since exists only as
email — which means it is read once, at the wrong time, by whoever was at
their desk.

## What changes for the reader

Work that was previously only an email now appears in Actions, owned and dated
like everything else:

- **Vendors** — a request waiting on your decision (area or owner approval);
  a question an approver has asked you about your request.
- **Access** — an expedited change still waiting on its second pair of eyes;
  an unrequested change waiting for someone to explain it.
- **Recertification** — an instance or item waiting for your attestation.

And two kinds of work that today are invisible **because nobody owns them**:

- a questionnaire the assessment rules require that nobody has assigned;
- a vendor overdue for review with no owner.

Both appear against the **module** rather than a person, visible to whoever
holds that module's role. They are never suppressed for want of a recipient —
that is exactly backwards, and it is why they rot today.

## What earns a place

Somebody can close it by doing something, and it has a date. A terminal
outcome — "your request was approved" — is news, keeps its bell notification,
and gets no row. ADR 0055 §2 has the table.

## Implementation

The point of this task is the **declaration**, not the six new selects.
`_collect` is five hand-written blocks in one function; a sixth module means a
sixth block. Replace that with each module declaring its action sources:

- what to select (a query, filterable by reader and by module — see COM-408's
  note on pushing the filter down);
- how to normalise a row to `ActionOut`;
- which module it belongs to, for the role rule;
- whether a new one is **immediate** or **digest** (unused until COM-410 §7,
  but declared here so the sources are complete when the mail inverts).

`_collect` becomes the thing that runs the declarations and merges. **ADR
0025's rule is untouched: still derived, still no `actions` table, still no
sync job.**

Then add the sources above. Each has an existing notification scan or inline
notification to read for the right predicate — reuse it, do not re-derive it,
or the queue and the mail will disagree before they are even joined up.

The unowned rows need `ActionOut.owner_id` to be genuinely optional in the
reader-filtering logic, not just in the schema: rule one excludes them, rule
two must include them.

`ActionOut.type` grows several members and the frontend groups and icons by
it — check `ActionsPage.tsx` handles an unknown type gracefully before adding
six.

Tests: each new source appears for the right reader and not for others; an
unowned row appears for a module role-holder and not under "mine"; a
terminal-outcome notification produces no row.
