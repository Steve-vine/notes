---
id: 01KZK9FZ1DY86ZJPC7N2TZ56XA
created: 2026-08-09T12:55:48.013438Z
updated: 2026-08-09T17:59:27.866499Z
type: task
title: Fleet table is missing the 'Estate' column heading — every column after Connection is shifted
project: 01KX671DATY39VW6GWK3M2T3DN
number: 629
sprint: sesjg7z
comments:
- id: 01KZKEXWJ5F79KEQ2T3C5H1CE8
  author: Steve Vine
  at: 2026-08-09T14:30:47.109003Z
  text: |-
    BUILT 2026-08-09 — PR #569, `feature/ise-629-fleet-table-headers`.

    **The one-line fix:** `<Table.Th>Estate</Table.Th>` between Connection and Profile.

    **The guard is the point, and it generalises rather than pinning this one column.** Every table on the Servers screen — Fleet, Discovered, Connection profiles — is now asserted to have as many `<th>`s as its rows have `<td>`s. Discovered has since grown a checkbox column and had exactly the same exposure.

    Two details that decide whether that guard is worth anything:

    - **It waits for a POPULATED row before counting.** An empty-state table satisfies a shape assertion vacuously, which is the one way this kind of test can lie.
    - **Verified to bite.** I removed the header again and watched both new tests fail, then restored it. A guard nobody has watched fail is a guard nobody knows works.

    It has already earned itself: ISE-628 adds a select-all checkbox column to this table, and the count test carried that change without anyone re-reading the markup.

    **On the cause** — the paired edit whose header half no-opped. That is now a standing check for me rather than a note: applying a change by string replacement fails SILENTLY on a non-matching anchor, so both halves of a paired edit get verified, not just the one whose effect is visible.
assignee: steve
label:
- bug
priority: medium
task_status: done
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