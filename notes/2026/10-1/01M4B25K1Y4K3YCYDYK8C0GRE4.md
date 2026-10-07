---
id: 01M4B25K1Y4K3YCYDYK8C0GRE4
created: 2026-10-07T11:32:21.694183Z
updated: 2026-10-07T14:57:49.318866Z
type: task
title: Requests list — "Standard" in the Mode column is a coloured pill, the same colour as "Executed"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 853
sprint: sme8esk
comments:
- id: 01M4B7EJ5TR6RWZ8RCXQYY8Z3D
  author: Steve Vine
  at: 2026-10-07T13:04:38.586258Z
  text: |-
    Done — PR #857, merged (46a7d26) and on staging.

    On the Requests list, Standard in the Mode column is now a pill in the same teal as the Executed status pill. Expedited is unchanged; sorting and the Mode filter work as before.

    Only the Requests list changed: a request's own page still shows an "Expedited" pill in its header and nothing for a standard request. Say if you want a "Standard" pill there too.
assignee: steve
label:
- improvement
priority: low
task_status: done
---
Asked for by Steve after smoke-testing sprint 63 on staging, 2026-10-07.

## Why

On the Requests list the Mode column shows **Expedited** as a pill and **Standard** as plain grey text. The column reads unevenly, and a standard request looks as if its mode is missing rather than stated.

## What people see

- In the **Mode** column of the Requests list, **Standard** is a pill, in the same colour as the **Executed** status pill (teal).
- **Expedited** is unchanged.
- Sorting and the Mode filter are unchanged.

## Decisions taken (say if any is wrong)

- **Only the Requests list.** The request's own page shows an "Expedited" pill in its header only when the request is expedited, and says nothing for a standard one; that is left as it is. Say if the header should carry a "Standard" pill too.

## Notes (technical)

- `app/frontend/src/access/RequestsPage.tsx`, the Mode cell (~line 300): the `else` branch renders `<Text>Standard</Text>`; make it `<StatusPill value="standard" label="Standard" … />`.
- Colour: "Executed" is `executed: 'teal'` in `app/frontend/src/components/statusColors.ts`. Add a `standard` entry mapped to the same colour (or pass the colour explicitly) — check `standard` isn't already a key used for something else in that map.
- Screen conventions: a pill never truncates (`brief/information-architecture.md` → Screen conventions). Mantine `autoContrast` needs a colour with a shade — assert the resolved `--badge-color` if a test checks the colour.
- Tests: `RequestsPage.test.tsx` — any assertion that finds "Standard" as plain text; add one that it renders as a pill.

## Done when

- A standard request's Mode reads as a teal "Standard" pill on the Requests list; an expedited one is unchanged.
- Sorting by Mode and filtering by Mode still work.