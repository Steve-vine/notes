---
id: 01M1RYW8MF7APNHYA570EGD48Q
created: 2026-09-05T14:17:06.959895Z
updated: 2026-09-05T14:17:12.086275Z
type: task
title: the actions total counts work for companies that are not in the list
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 561
sprint: s2fcksg
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
Found by Steve on staging, 2026-09-05. Reported as: open actions still showing for a company that was **permanently deleted** (archived, then the type-the-name confirmation).

**Symptom.** With **This company only** off, the Actions total is larger than the per-company totals added together. Steve read the surplus as work belonging to a company that no longer exists. Nothing on the screen can confirm or deny that, because the rows never say which company they are for — COM-560.

## What was ruled out before writing this

The purge (COM-507) derives its graph from the schema rather than a hand-written list, and it holds up on inspection:

- Every table with a foreign key to `companies` has a single-column primary key, so none is silently skipped by the seed's `pk_of` guard.
- Walking foreign keys outward from `companies` at the schema level and comparing against what the purge deletes (closure + the FK fallback) leaves nothing company-scoped uncovered. The tables that come out "uncovered" are all global ones reachable only through `users`, which is deliberately never purged.
- Every source the queue reads — gaps, treatment plans, assessments, access requests, recertification campaigns and instances, vendors and their assessments and requests — sits on a table the closure reaches.

So a genuine orphan is possible but not evidenced, and there is a benign explanation that produces exactly this arithmetic: **content reviews carry no company at all.** They are library work (`company_id=None`), so they appear in the all-companies list and drop out of *every* company-scoped view. All-companies total = the companies added up, **plus** the library. That surplus would look precisely like work belonging to a company that is not in the switcher.

I could not settle it either way this session — reading the staging database is blocked from this seat.

## What to do

1. Settle it with the data first, before changing anything: are there action-bearing rows whose `company_id` points at no row in `companies`? Check the tables the sources read — `gaps`, `risks`/treatment plans, `assessments`, `access_requests`, `recert_schedules`/`recert_campaigns`, `vendors`, `vendor_assessments`, `vendor_onboarding_requests`.
2. **If there are orphans**: find which table the purge missed and why, fix the purge, and clean up what is already stranded. The schema-derived design means the fix belongs in the derivation, not in a list of tables.
3. **If there are none**: the surplus is the library, and COM-560 makes that legible on screen — those rows will name themselves as library work. Close this having proved it, and say so, rather than leaving the count unexplained.

Note that `activity_log` rows deliberately outlive a purged company (they carry no foreign key, by design) and attachment **rows** survive as well — the purge deletes the files but the rows are not reachable. Neither produces an action, so neither explains this, but both are worth not mistaking for the bug while looking.

## Related

- COM-560 — an action says which company it is for. Do that one first; it turns this from arithmetic into something visible.
- COM-507 — the company purge.
