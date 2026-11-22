---
id: 01M81A3P9ZNH9RGYR8CHYF4TJK
created: 2026-11-22T09:41:31.071467Z
updated: 2026-11-22T09:41:31.071467Z
type: task
title: Provide a register to an audit request — as it stood on a chosen date (default the audit period's end), pinned like provided evidence, removed or withdrawn the same way
assignee: steve
task_status: todo
label: feature
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2094
---
Sprint "Registers - Phase 2" (ADR 0167 §6, in COM-2087). Builds on "An import that updates" in chain order. The auditor's side is the next task.

## What people see
- On an audit request, **Provide ▸ A register** sits beside providing evidence. Pick a register (only those the person can open), and a date it's shown as at:
  - default: the end of the audit's period (observation end, else planned end)
  - any day up to today. Today means the moment it's provided, so later edits today don't change it.
- Compass suggests registers kept for the request's controls first.
- A Restricted register shows the warning that the audit's auditors will see it.
- The request lists it like provided evidence: "Obligations (OBL), as at 31 Mar 2026, 48 entries", opening the internal as-at view.
- **Pinned**: what's provided doesn't change. If the register changed after that date, the request says "The register has changed since 31 Mar" and the owner may provide it again as at a later date.
- **Taking it off** (ADR 0133 §3): removed freely until the auditor opens it; after that, withdrawn with a reason and shown to the auditor as withdrawn.
- The audit's Activity records providing, removing and withdrawing it.
- Who: whoever can provide evidence to the audit, and can open the register.

## Implementation notes (technical)
- A new kind of provided item on a request: register id + as-at moment (timestamp; for a past date, end of that day in the company's time zone). Nothing copied; views render from revisions at that moment.
- "Changed since": any revision of the register's entries after the moment.
- Reuse the provided-evidence remove/withdraw/lock flags and the activity entries.

## Done when
- A register can be provided as at the period end, as at a past day and as at now; each shows the right entries and values.
- Editing an entry afterwards doesn't change what's provided, and the request says the register has changed.
- Before the auditor opens it, it can be removed; afterwards only withdrawn with a reason.

On the chain: migration + API.