---
id: 01M0XE78829JRERW98X1V1RJFS
created: 2026-08-25T21:46:31.554696Z
updated: 2026-09-01T13:55:52.019991Z
type: task
title: Every module declares its actions — and the work that was only ever an email appears
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 409
sprint: sbph5q5
blocked_by:
- 01M0XE6NEYM936EBGSGTEHYK2J
comments:
- id: 01M0YYXZ3GCV5VET8KFB9MEEM4
  author: Steve Vine
  at: 2026-08-26T11:57:47.504028Z
  text: |-
    Done — PR #412, merged to main.

    Each module now declares its action sources in `core/actions/`, and the queue is the thing that runs the declarations and merges. A declaration says what to select, which module it belongs to, and whether a new row is urgent or can wait for the digest — that last one is unused until COM-410, but it is declared now so nothing needs a second pass when the mail inverts.

    The queue went from five kinds of work to thirteen. New: a request waiting on an area or owner approval, a question an approver has asked you, a vendor whose review has come due, a certification expiring, an expedited access change waiting on its second pair of eyes, an unrequested directory change, and recertifications waiting on attestation. Every one of those existed only as email before.

    And the two that were invisible because nobody owned them now appear against the module: a questionnaire the rules require that nobody has assigned, and a vendor overdue for review with no owner. They never appear under "mine", and they reach whoever holds that module's role.

    Two things to flag:

    **Approvals fan out per decider** — one row per person who could sign it, the same way a content review already fans out over its reviewers. Any of them can close it and each needs it under "mine". For an owner approval the deciders are worked out at read time, so a pending signature follows the vendor through an ownership transfer.

    **Vendor approvals, questions and unassigned questionnaires carry no due date.** Nothing in Compass puts an SLA on an approval, and the queue is not the place to invent one — how hard we chase approvers is a decision nobody has taken. They sort last, as an undated gap always has. Happy to make it a follow-up if you want dates on them.
assignee: steve
label:
- feature
priority: high
task_status: done
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
