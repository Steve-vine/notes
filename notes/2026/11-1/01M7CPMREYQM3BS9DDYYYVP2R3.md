---
id: 01M7CPMREYQM3BS9DDYYYVP2R3
created: 2026-11-14T09:36:30.174083Z
updated: 2026-11-14T09:36:34.25586Z
type: task
title: A check can turn a code into its name (change_type 2 → Standard), from a list read from the service or a fixed list, and Polaris designs it in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1816
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
## What happened

On 2026-11-14, reviewing checks, Steve found columns that hold codes pointing at another list, e.g. `change_type` showing 1, 2, 3. The evidence means nothing to a reader (or an auditor) without the name behind each code. He asked whether Polaris could design a check that shows the name instead.

Today a check can follow a read with a read **for each item** (ADR 0148 §1), but it can't read a list **once** and use it to turn codes into names.

## What people see

1. **Names, not codes.** In a check's table, a lookup column shows the name with the code beside it in grey ("Standard · 2"), so nothing is hidden. This applies on the review page, the check's page, captures, the Evidence tab, and audit packs and exports.
2. **Two kinds of list:**
   - **Read from the service** (preferred): Compass reads the service's own list (its change types, form field choices, statuses…) once per capture, with the same account, and matches each code to its name. If the service adds a type, the next capture picks it up.
   - **A fixed list**: when the service has no list to read, the check carries one (1 = Minor, 2 = Standard, 3 = Major, 4 = Emergency). Polaris fills it from the service's documentation or from what it sees, and a person can correct it.
3. **Polaris designs it in.** When Polaris tries a check's reads and sees a column that looks like codes (small numbers, ids, short keys), it looks among the service's reads for the list behind it. It then proposes the lookup as part of the check. The review page shows what it will do ("change_type: 1 → Minor, 2 → Standard … from Change types") and the sample shows the names. If it can only offer a fixed list, it says where the names came from. It's approved with the check, never applied on its own.
4. **Adding one later.** "Show the change type names in CHK-14" in chat makes Polaris add a lookup to an existing check, try it, and show the fresh sample. On screen, the lookup can be seen and removed from the column's header menu (with COM-1814's Rename), and edited in the reads editor (COM-1806).
5. **A code with no name** shows as "5 · no name in Change types", and the capture notes it. It's never dropped or guessed.
6. **Evidence stays honest.** The raw capture keeps the service's own values. The list that was used is captured alongside it (for a read list) or recorded with the check (for a fixed list), so the names can be shown to have come from somewhere.

## Rules (my calls; Steve can overturn)

- A pass/fail rule (COM-1606) can refer to either the code or the name.
- Adding, changing or removing a lookup on a live check changes how the evidence reads, not what's collected, so it doesn't send the check back to Review. It's recorded in the check's history. If the lookup adds a new read from the service, that read must be approved, as any new read is.
- A list read counts toward the run's limits, stays on the service's own host, and is read once per capture however many rows use it.
- Service-agnostic: a general capability of the check and definition language, with no lists or code for any particular service (ADR 0147 §9, the COM-1696 test). It amends ADR 0148 with a new section on lookups.
- Out of scope here: lookups in Collection feeds (Vulnerabilities, Inventory, Secrets). The same capability could serve them later.

## Done when

- A check can carry a read-list lookup and a fixed-list lookup, and its table shows "name · code" everywhere its evidence appears.
- On a FreshService-like sample (proved on staging with fixtures), Polaris proposes a lookup for a code column, finding the list read where one exists and falling back to a fixed list with its source named.
- Polaris can add, change and remove a lookup in chat, and a person can remove one on screen.
- A code with no name shows as such and is noted on the capture.
- The list used is kept with each capture.
- There are tests for matching, missing codes, list-read limits and host, the no-service-names rule, and history entries.

**On the chain** (the check's reads and the API change, ADR 0148 is amended; a migration only if lookups aren't kept inside the existing reads data).