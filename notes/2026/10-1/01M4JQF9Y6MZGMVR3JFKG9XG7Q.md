---
id: 01M4JQF9Y6MZGMVR3JFKG9XG7Q
created: 2026-10-10T10:59:21.158215Z
updated: 2026-10-10T11:09:50.708345Z
type: task
title: 'Request windows: change pills in normal case, Submit expedited outlined in red'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 900
sprint: sme8esk
comments:
- id: 01M4JR2G0FF87SJKRQYQ4TRK1H
  author: Steve Vine
  at: 2026-10-10T11:09:49.967274Z
  text: |-
    Done 2026-10-10 — PR #886, merged to main as 0050f286.

    - Adding / Removing pills are in normal case in all six windows (ChangeBadge tt="none").
    - Submit expedited is outlined in red again in all six windows.

    Two lines; CI green. Goes to staging with COM-896 and COM-897.
assignee: steve
priority: medium
task_status: review
---
## What Steve asked (2026-10-10)

After seeing the summary of COM-898/899: "Change pills back to standard case and red border around expedited button."

## Behaviour wanted

- **Adding / Removing pills read as they are written** — "+ 24 Hour — can open", not "+ 24 HOUR — CAN OPEN". All six windows; managed groups, manual groups and shared mailboxes alike.
- **Submit expedited has a red outline** again, in every request window — it is the break-glass button and should look like one. Greyed when it can't be pressed, as now.

## Build

- `access/requestWindow.tsx` `ChangeBadge`: `tt="none"` on the adding/removing tones.
- `access/RaiseRequestModal.tsx`: the expedited button back to `color="red" variant="outline"`.
- `brief/information-architecture.md` unaffected.

## Smoke test (Steve — Safari)

1. Move someone, change the primary role: the pills under Access changes are in normal case.
2. Any request window: Submit expedited is outlined in red once a justification is typed.