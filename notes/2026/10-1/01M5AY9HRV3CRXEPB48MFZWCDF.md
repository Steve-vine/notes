---
id: 01M5AY9HRV3CRXEPB48MFZWCDF
created: 2026-10-19T20:40:18.971084Z
updated: 2026-10-20T12:22:28.013461Z
type: task
title: A round's page shows the name each person typed when they signed — "Signed as" beside the signed date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1128
sprint: s7s7mn9
assignee: steve
label:
- feature
priority: low
task_status: active
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