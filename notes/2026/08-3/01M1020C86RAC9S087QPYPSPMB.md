---
id: 01M1020C86RAC9S087QPYPSPMB
created: 2026-08-26T22:10:46.66282Z
updated: 2026-08-26T22:11:34.601907Z
type: task
title: Detection watches every group — in two lanes, so the queue still means something
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 452
sprint: snq23hz
assignee: steve
company:
- moneypenny
label:
- feature
priority: medium
task_status: backlog
---
Stacks on COM-451. Part 6 of COM-446, and the second decision it reverses.

Out-of-band detection watches membership on **managed groups only** — `_detect_unrequested` skips any pair whose group no active business role maps. Everything else is invisible: change membership on an unmapped group in Entra and Compass mirrors the fact and says nothing.

## What changes for the reader

**Every membership change in the tenant is recorded** — but only the ones that need a decision ask for one.

## Scope

**Detection widens to every mirrored group.** Drop the managed-only guard on membership items.

**Two lanes, because of what that does to the volume.** ADR 0045 narrowed this deliberately, on the grounds that diffing every group would drown the validation queue — and that risk is real and has not gone away. In a tenant of this size unmanaged churn will heavily outnumber governed change. The answer is to separate what needs an answer from what needs to be visible, not to narrow it again:

- **Needs validation** — managed groups, anything privileged, accounts created or disabled. Adopt or flag for reversal, in the queue engineers already work. Unchanged behaviour.
- **For information** — unmanaged group membership. Recorded, searchable, filterable and groupable by group; never nagging, never counted in the queue badge.

**Nothing above raises drift.** COM-449's exceptions and COM-451's privileged grants are executed changes with ledger entries, so `_requested_recently` should already recognise them. Verify it rather than assume it — an exception path that lands in the validation queue as unrequested would be worse than not having built it.

## Watch for

Item volume on the first sync after deploy. Every pre-existing membership is not a *change*, so it should raise nothing — but the guard that makes that true is worth a deliberate look before this goes anywhere near the tenant.

## Tests

Integration tests: an unmanaged membership change lands in the information lane; a managed one still lands in the validation lane; an executed exception raises nothing; the queue badge counts only the validation lane; a re-run creates nothing new.