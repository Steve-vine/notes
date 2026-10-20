---
id: 01M5AY9HRV3CRXEPB48MFZWCDF
created: 2026-10-19T20:40:18.971084Z
updated: 2026-10-20T15:55:34.697115Z
type: task
title: A round's page shows the name each person typed when they signed — "Signed as" beside the signed date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1128
sprint: s7s7mn9
comments:
- id: 01M5CPQS40ZMEP0NG8Z08M95YY
  author: Steve Vine
  at: 2026-10-20T13:06:45.504099Z
  text: |-
    Merged in PR #1148 (main c88ca908) at 13:06 UTC on 2026-10-20.

    **What changed:** on Attestations ▸ Open ▸ a round, the People table has a **Signed as** column next to Signed.
    - It shows the name typed with the signature that counts, exactly as typed (spacing included).
    - It's blank for anyone who hasn't signed.
    - When the signature that counts was made for another round or role (sign-once), it shows that signature's name.
    - It sorts, and long names wrap. The assistant's view of a round returns it as "signed_as".
    - Nothing about a signature changes.

    **Calls:** none beyond the task.

    **Checks:**
    - Integration: the round endpoint (including Hal's signature counted from another company's round), and the assistant's round tool.
    - Frontend: the round page test (column 3 blank for the unsigned), and the screen-conventions test.
    - CI's static checks: ruff, mypy, eslint, tsc -b, prettier.
    - The OpenAPI drift script (schema.d.ts regenerated).

    **CI:** run 39423720609 took 27 min, with backend-test at 26.0 while four workers shared g5. The frontend job ran on ubuntu-latest (14.1 min).
assignee: steve
label:
- feature
priority: low
task_status: done
---
Sprint 78, Attestations (ADR 0117, COM-1092). Raised by Steve while smoke-testing on staging, 2026-10-19.

## What's wrong

On Attestations ▸ Open ▸ a round (one document on one role), each person shows their status, when they signed and when it's due, but **not the name they typed when they signed**. The typed name is kept with every signature, and it's shown on the person's page (Compliance ▸ By person), in exports and on the signer's own portal page. It's missing from the page where you check who has signed a document, so the name you typed seems to have gone nowhere.

## What people see

- The round's People table gains a **Signed as** column, next to **Signed**: the name typed with the signature that counts for this round, exactly as typed.
- Blank for anyone who hasn't signed.
- When the signature that counts was made for another round or role (the sign-once rule), it shows that signature's typed name, as **Signed** already shows its date.
- The column sorts, like the others.

## Notes (technical)

- `AttestationRoundPersonOut` gains `typed_name: str | None`, filled from the signature that counts (the one `signed_at` / `signed_for` already come from). Regenerate schema.d.ts and run the drift check.
- `AttestationRoundPage.tsx`: a `SortableTh` "Signed as" column; long names wrap, never truncate.
- Tests: the round endpoint returns the counted signature's typed name, including a signature counted from another round; the page renders the column and blank for the unsigned.
- Read-only: nothing about a signature changes.