---
id: 01KZK9FZ1DY86ZJPC7N2TZ56XA
created: 2026-08-09T12:55:48.013438Z
updated: 2026-08-09T12:56:00.945241Z
type: task
title: Fleet table is missing the 'Estate' column heading — every column after Connection is shifted
project: 01KX671DATY39VW6GWK3M2T3DN
number: 629
sprint: sesjg7z
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Reported by Steve 2026-08-09: the "In estate" link sits under the **Profile** heading.

**Confirmed in `ServersPage.tsx`** — the Fleet table has six header cells and seven body cells:

```
headers:  Hostname | OS | Connection |         | Profile | Last contact | (blank)
cells:    Hostname | OS | Connection | Estate  | Profile | Last contact | actions
```

So everything after Connection reads one column to the left: In-estate under Profile, the profile name under Last contact, and the last-contact time under the blank actions header.

**Cause.** The Estate column was added in ISE-565 as two edits — one inserting the `<Table.Td>` with the entity link, one inserting the matching `<Table.Th>Estate</Table.Th>`. The cell landed; the header did not, because the edit was applied by string replacement and a non-matching anchor fails silently rather than erroring.

**Fix**: add `<Table.Th>Estate</Table.Th>` between Connection and Profile.

**Worth more than the one-line fix.** Nothing caught this — not the type checker, which has no opinion about table shape; not the build; not the 28 frontend tests, which assert on cell CONTENT and never on the header row. A table whose headers and cells have drifted apart still renders, still passes, and is simply wrong on screen.

Cheapest guard is a test that the Fleet table's header count matches its per-row cell count. That generalises: the same silent drift is available in every table on the Servers screen, and Discovered has since grown a checkbox column, so it has the same exposure.

**Acceptance**: In-estate sits under an "Estate" heading and every other column lines up; a test fails if a column is added to one of the two rows and not the other.