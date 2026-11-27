---
id: 01M8EJ64S3YC91ZZZX9G6WNGWQ
created: 2026-11-27T13:12:47.651503Z
updated: 2026-11-27T13:27:43.778561Z
type: task
title: '"Their roles have changed since this was raised" shows only on a request that hasn''t run yet — never on one already carried out'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2188
sprint: smq8t5s
assignee: steve
label:
- bug
priority: medium
task_status: active
---
**Independent** (screen only — no migration, no API change).

Seen by Steve on production 27 Nov 2026 on **ACR-2** and **ACR-3**: two expedited movers for the test account Arnold Rimmer, both carried out on 13 Oct and awaiting validation. Each shows the yellow warning:

> "Their roles have changed since this was raised — they hold Nothing now. This request replaces the whole set, so approving it will undo that change too."

It's wrong in two ways:
- The requests have **already run**. The roles held now differ from those held when raised **because of the request itself**, not because anything changed since.
- It talks about "approving" a request that's waiting for **validation**, which never re-runs anything.

## What people see
- **Only before it runs:** the warning appears only while a request is yet to be carried out (awaiting approval, approved and waiting for its scheduled time, or a draft). That's the only time approving it could overwrite a newer change.
- **Not after it has run:** no warning once a request has been carried out (executing, executed, awaiting validation, validated, amended, failed). The *Held when raised* line stays as the record of where the person started.
- **A change since this request ran** is a different story. If someone's roles change after a mover ran (e.g. ACR-3 undoing ACR-2), the earlier request may say so in a quiet note: "Changed again since: ACR-3 removed this role on 13 Oct". Only add this if the later request is easy to find. Otherwise leave it out and say so in the PR.

## Notes (technical)
- `app/frontend/src/access/RequestDetailPage.tsx` ~593–715: `drifted` compares `held_business_roles` (now) with the held-when-raised snapshot, whatever the request's status.
- Gate the alert on the request's status (not yet executed). Validation (`validate_request` in `api/v1/access_requests.py`) only records the second person and never re-executes, so the alert has no meaning there.
- Test: one per side of the gate — a pending mover with drift shows it; an executed or awaiting-validation mover doesn't.

**Done when:** on staging, an expedited mover awaiting validation shows no drift warning, and a pending mover whose person's roles changed since it was raised still does.