---
id: 01M16YSHEF8JSYH565P6QD4Q86
created: 2026-08-29T14:29:17.90398Z
updated: 2026-08-29T17:08:10.060255Z
type: task
title: 'Users screen: status and row actions share one column, so nothing lines up'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 511
sprint: s2fcksg
assignee: steve
company: null
label:
- bug
priority: medium
task_status: todo
---
**Reported:** on Admin ▸ Users the Status column reads *Active · Disable · Reset password · Delete* and the items don't line up down the rows.

## Why

`admin/UsersSection.tsx:192-249` packs the status pill **and** all three action buttons into a single `Table.Td` under a header labelled `Status` (`:128`, `w={380}`). The layout is `<Group gap="xs" wrap="nowrap">` (`:199`) with **no `justify`**, so everything is packed left, starting wherever the pill happens to end.

Two things then vary per row, and they compound:

1. **The pill's width** — "Active" vs "Disabled" (`StatusPill`, sized to its label). Every button after it shifts.
2. **The first button's label** — `{u.status === 'active' ? 'Disable' : 'Enable'}` (`:218`). "Enable" is narrower than "Disable", so *Reset password* and *Delete* shift again. A disabled row gets a **wider pill and a narrower first button**, which is why the raggedness looks arbitrary rather than uniform.

The `flexShrink: 0` on every child (`:200`, `:208`, `:228`, `:242`) is correct and should stay — it came from COM-285, where the pill ellipsised and *Disable* was pushed out of view. It isn't the cause here.

Also note the `w={380}` doesn't constrain anything: per `brief/information-architecture.md:52-60` a fixed column width is a **preference, not a cap**.

## The fix — follow the pattern the rest of Admin already uses

Every other Admin table separates the two concerns: a narrow **Status** column, then a **trailing unlabelled fixed-width actions column** whose cell is `<Group gap="xs" wrap="nowrap" justify="flex-end">`. Right-aligning is what makes the actions line up regardless of what's to their left.

Precedent, all consistent:

| Screen | Actions column |
|---|---|
| `admin/CompaniesSection.tsx:60, 79-100` | `<Table.Th w={240} />`, `justify="flex-end"` |
| `admin/TokensSection.tsx:51, 65-75` | `<Table.Th w={100} />` |
| `admin/SsoMappingsPanel.tsx:126-172` | `<Table.Th w={90} />` |
| `admin/MaturityRubricSection.tsx:102`, `AccessRubricSection.tsx:118`, `RiskTierRubricSection.tsx:202` | same Group recipe |
| `access/UsersPage.tsx:156`, `GroupsPage.tsx`, `DevicesPage.tsx` | `<Table.Th w={44} aria-label="Actions" />` |
| `pages/VendorsPage.tsx:224-234` (the IA doc's reference screen) | every `StatusPill` in its own column, no actions mixed in |

`UsersSection` is the only Admin table that doesn't do this.

So: split the cell into a `Status` column and a trailing unlabelled actions column, right-aligned. Give the trailing header an `aria-label="Actions"` as the Access screens do, so an empty header cell isn't silent to a screen reader.

## Also worth settling while in here

**Keep Enable/Disable a stable width.** The label swap is the second half of the misalignment and it survives right-alignment — with actions right-aligned, a narrower "Enable" now shifts *Reset password* and *Delete* leftward instead. Options: a fixed `w`/`miw` on that button, or a single stable label. CompaniesSection avoids the whole problem by preferring `disabled=` over conditional rendering; the same instinct applies to labels.

**Don't restyle the pill at the call site.** `information-architecture.md` §"A pill shows its whole label" is explicit that pill sizing rules live in `theme.ts` as `Badge`/`Pill`/`Chip` overrides. If a minimum pill width is the answer, it belongs there, not in `UsersSection`.

**Consider writing the convention down.** The Screen conventions section has no rule about action columns yet, even though six screens already agree on one. A short entry — *"row actions live in a trailing unlabelled column, right-aligned; values and actions never share a cell"* — would have prevented this and would settle the next one. Small doc change, worth folding in.

## Verify
With a mix of active and disabled users, plus the current admin's own row, the three actions form clean vertical columns. `UsersSection.test.tsx` covers the buttons' presence and disabled states — extend it to assert the actions sit in their own cell rather than the status cell.
