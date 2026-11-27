---
id: 01M8EJ64S3YC91ZZZX9G6WNGWQ
created: 2026-11-27T13:12:47.651503Z
updated: 2026-11-27T20:09:06.185731Z
type: task
title: '"Their roles have changed since this was raised" shows only on a request that hasn''t run yet — never on one already carried out'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2188
sprint: smq8t5s
comments:
- id: 01M8EMNYFTA9F8ASVBKFC0MA8B
  author: Steve Vine
  at: 2026-11-27T13:56:22.650077Z
  text: |-
    Built — PR #2186, merged to main as 5c25fbd67 (not yet on staging; goes with the sprint deploy).

    What changed: a mover's "Their roles have changed since this was raised" warning now shows only while the request is still to be carried out — a draft, awaiting approval, or approved (or expedited) and waiting for its scheduled time. Once it has run (executing, executed, awaiting validation, validated, amended, failed) there's no warning: the roles moved because of the request itself, and validation re-runs nothing. "Held when raised" stays as the record. The last line now reads "…so when it runs it will undo that change too" rather than "approving it will undo…", which also fits a scheduled request nobody approves again.

    "Changed again since: ACR-3…" note: not added — the page can't find the later request from what it already loads, so it would need an API change (said so in the PR).

    For you to consider: a failed request shows no warning, as the task asked — but a failed request can be retried, which runs the whole set again and could undo a newer change silently. If you want the warning before a retry too, it's a one-line addition.

    Tests: an executed and an awaiting-validation mover with drift show no warning; an awaiting-approval one still does.
- id: 01M8FA0DW9RQBZPXZBG2BV5A0P
  author: Steve Vine
  at: 2026-11-27T20:09:06.185275Z
  text: |-
    Pre-UAT on staging 30786db4f: Couldn't check (E2E Test Company has no mover).

    Steps: as E2E Admin A, went through E2E Test Company's requests (132 leavers, 1 joiner, 1 recertification removals, plus my two from today). There is no mover, expedited or pending, so the warning can't be seen on either side of the change. The one executed request, ACR-72 (a joiner), shows no warning, but joiners never had one.

    For Steve: on production, ACR-2 and ACR-3 (Arnold Rimmer's expedited movers, awaiting validation) should no longer show "Their roles have changed since this was raised". A pending mover for someone whose roles changed after it was raised should still show it, ending "…so when it runs it will undo that change too".

    Screenshots: none. Folder ~/compass-uat/sprint-128/COM-2188/
assignee: steve
label:
- bug
priority: medium
task_status: review
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