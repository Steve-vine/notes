---
id: 01M7D5YDE8T17QRD6ZXQ8AGCWG
created: 2026-11-14T14:03:55.208021Z
updated: 2026-11-14T14:24:59.242402Z
type: task
title: '"Change the fields it keeps" falls back to the check''s last filed capture when the service can''t be read, and never offers the fields the check leaves out'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1825
sprint: spsp226
comments:
- id: 01M7D74WNXK4DMXKWA2X3EKTB6
  author: Steve Vine
  at: 2026-11-14T14:24:55.99729Z
  text: |-
    Built — PR #1819 (74da4101), auto-merge on. Frontend only, no API change.

    What you now see in Change the fields it keeps:
    - When the sample can't be taken it says why, then shows the check's last filed capture as the table (kept columns with data, other fields as name-only columns), each labelled with its account and "collected <date>". If the accounts it reads now have filed captures, one per account; if none (like CHK-2, whose account went with its deleted integration), the newest capture it ever filed, from whichever account — so CHK-2 shows its 6 Nov capture and no "hasn't captured anything" message.
    - Only a check that has never filed a capture gets the list of names ("it hasn't filed a capture yet"), now with Find a field, All and None, cursor in the search.
    - Fields the check leaves out as sensitive (id, principalId on CHK-2) are never shown or offered on any path; All can't put them back.
    - The service's reason ends with a full stop.

    No API change was needed: the check's history already lists every capture, including those from accounts it no longer reads.

    Choices: the fallback uses only filed captures (before, whatever was on the card, held ones included); the name list is laid out as wrapping ticks so it shares the table's header, search and All/None.

    Tests: four new tests (removed-account capture as fallback with its date; left-out fields excluded on all three paths and All keeping only what's offered; Find a field on the name list; name list only when nothing filed) — all fail on the old component; full vitest 4,167 passed; eslint/tsc/prettier clean.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
## What happened

Found in Claude's pre-UAT pass of COM-1819 on staging 53965a3b (2026-11-14), E2E Test Company, as E2E Admin A: ACC.13 ▸ Evidence ▸ CHK-2 ⋯ ▸ Change the fields it keeps. CHK-2's Collection integration was deleted, so the fresh sample fails (as expected, "That Collection integration doesn't exist"). Then:

1. **Wrong fallback.** It says "And it hasn't captured anything yet, so here are the fields by name." But CHK-2 has 5 filed captures from 6 Nov, listed just above ("last collected 6 Nov 2026, 12:21"). The fallback only looks for the latest capture from a *current* account, and this check's account went with its deleted integration.
2. **Left-out fields offered.** In that name-list fallback, `id` and `principalId` — the check's left-out (sensitive) fields — are offered as unticked boxes ("102 of 104 ticked"). The fresh-sample path filters them out; the fallback doesn't.
3. The name-only fallback has no Find a field search.

Screenshots: ~/compass-uat/spsp226/COM-1819/.

## What people see

- When the fresh sample can't be taken, it says why and shows the check's **last filed capture**, whichever account it came from, as the table (kept columns with data, other fields as name-only columns), labelled with its date.
- Only a check that has never filed a capture gets the plain list of names, and that list has the Find a field search too.
- Fields the check leaves out as sensitive are never shown or offered, on any path.

## Done when

- On CHK-2 in E2E Test Company the fallback shows the 6 Nov capture as a table, with its date, and no "hasn't captured anything" message.
- id and principalId aren't offered on any path.
- The name-only list has Find a field.
- Vitest covers: capture from a removed account used as fallback, left-out fields excluded in every path, search on the name list.

**Independent** (front end only, unless the last filed capture from a removed account isn't reachable through the API — then say so; it joins the chain). Fix-forward from COM-1819.