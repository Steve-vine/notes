---
id: 01M18ZDMQ88EXY6S365XRVESPN
created: 2026-08-30T09:18:45.480517Z
updated: 2026-08-30T09:18:49.611406Z
type: task
title: Why a membership exists is derived from current facts, not stamped once — role beats exception
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 524
sprint: sz42uhw
assignee: steve
company:
- moneypenny
label:
- bug
priority: high
task_status: todo
---
"Why does this person have this?" is answered by a row written once, at the moment of the grant, and never revisited. So the answer goes stale the moment anything around it changes, in both directions:

* A group is granted as an **exception**, then later added to a role the person holds. It still reads as an exception, indefinitely — though everyone with that role now gets it, and there is no deviation left to record.
* A group was **role-derived**, then the role stopped mapping it. It still claims that role granted it, which is no longer true.

Worse, the answer is not even stable. If the record is ever rebuilt — the membership drops out of the mirror briefly and returns, so `reconcile()` re-creates it — the ledger path (`_ledger_attribution`) reconstructs provenance against the **current** matrix and calls the first case role-derived. Two paths, two answers, and which one a reader sees depends on unrelated mirror churn.

## The rule

**role-derived › exception › unexplained.**

* Any active role the person holds maps the group → **role-derived**.
* Otherwise an approved, unrevoked exception for that person and group → **exception**.
* Otherwise → **unexplained**.

A role is the rule; an exception is a deviation from it. Once the rule covers the group there is no deviation, and an exception register padded with entries that are now standard access for a role is a worse register — it is the short, individually-justified list an auditor actually reads.

## Derive it, don't convert it

The exception record is **kept**, not consumed or closed. Only the classification is derived.

That is what makes the rule reversible and self-correcting: if the role later stops mapping the group, the standing exception is still there and the membership falls back to **exception** rather than to unexplained. Converting or closing the exception on absorption would throw that away and quietly downgrade someone's access to unexplained later, for a reason nobody would be able to reconstruct.

It also makes COM-523's behaviour fall out of the same rule rather than needing its own: a role dropping a group leaves holders unexplained *because* no exception stands for them, not as a special case.

## What stays stamped

The classification is derived; the **provenance of record is not**. Which request approved it, who decided, when — that stays exactly as it is, from the stamp at write time and the append-only ledger behind it. Those are facts about a decision that was made, and inferring them would be guessing at something that was known (the standing reasoning in `core/membership_provenance.py`).

So: `provenance` becomes a function of current facts; `request_id` and the approving history do not.

## Consequences worth expecting

No migration. The first reconcile pass after deploy corrects the existing rows, and it is a **record correction only** — no Graph writes, nobody's access changes.

It will move the numbers, though. Every exception a role has since absorbed reclassifies as role-derived, so the exception count on the dashboard drops, possibly sharply, on the first pass after deploy. That is the register becoming correct rather than anything being lost, but it should not be a surprise when it happens.

## Notes

* `record()` (`core/membership_provenance.py:103`) upserts whatever the caller asserts; `reconcile()` (:226) only handles set differences and never revisits an existing row's attribution. The derivation belongs alongside the reconcile, where the matrix and the mirror are both already in hand.
* `_ledger_attribution` already classifies exactly this way ("a group the subject's business roles map is `role_derived`, anything else about that subject is an `exception`"), against the current matrix. That logic is right and is the thing to lift — the defect is that only the rebuild path uses it.
* Precedence among several roles mapping the same group is already settled (lowest role id wins, so a re-run does not flip between two equally true answers) — keep it.
* Blocks nothing, but COM-523 depends on this rule for its "declined removal leaves them unexplained" behaviour to be principled rather than a special case.
