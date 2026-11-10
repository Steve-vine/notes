---
id: 01M716F9WEKKNHSA9NN4FQSYAM
created: 2026-11-09T22:22:15.438926Z
updated: 2026-11-10T10:01:59.434004Z
type: task
title: 'Replacing a Collection account''s key: the new-key box is too small to type into — it gets room of its own'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1663
sprint: sjvqrdg
comments:
- id: 01M72B54ASP94PG345ZK1ZQCWM
  author: Steve Vine
  at: 2026-11-10T09:03:19.385442Z
  text: |-
    **Done: merged to main in PR #1672.**

    **What it does:** clicking **Replace secret** on a Collection account now opens a row of its own under the account, spanning the table (the way "Ask Polaris why" does), instead of squeezing the box into the Secret column. The row holds:
    - the new key, labelled e.g. "New token for Datadog - Staging" and as wide as the Add account form's key field, with the show/hide eye;
    - its expiry;
    - **Save** (disabled until something is typed; saving tests the key as before);
    - **Keep** (closes the row and forgets what was typed).

    The row's button always reads "Replace secret", so the buttons don't jump about. The Secret column keeps showing the current key's last four characters while you replace it.

    **Tests:** two new screen tests: the field sits in its own full-width row, Save sends the key and its expiry and closes the row, and Keep closes it without saving anything. Lint, the type check and the screen-conventions test pass.

    **To look at on staging** (after the next deploy): Datadog ▸ Accounts ▸ Replace secret, and type a full token into the box.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Raised by Steve while testing on staging (2026-11-09), on a Collection integration's accounts (e.g. Datadog). Clicking **Replace secret** on an account opens a box for the new key, but it's too narrow to type into.

## The problem

The new-key box opens inside the account's row, in the narrow column that normally shows "…9d7a · set on 9 Nov". It sits on one line beside its **Save** button with no width of its own, so the table squeezes it to almost nothing. The expiry fields underneath sit in the same column.

## Done when

- **Replace secret** gives the new key room to type and see: at least as wide as the key field on the **Add account** form (a long token such as `ddsat_…` or `cfat_…` fits most of its length).
  - Either the replace form opens on its own line under the account's row, spanning the table,
  - or it opens in a small dialog, "Replace the key for Datadog - Staging", with the key, its expiry and Save.
  - Pick whichever reads better at the table's usual widths; the row must not jump the other columns about.
- **The show/hide eye** on the box still works, and Save stays disabled until something is typed.
- **Keep** still closes it without changing anything.
- **Nothing else changes:** saving still runs the test and shows its result, including what the service said (COM-1662).
- **Tests:** a Vitest test for Accounts that opening Replace secret shows a key field with a usable width (e.g. a min-width style, or that it's no longer in the nowrap group), and that Save sends the key and expiry as today.
- **On staging:** Replace secret on an account opens a box you can type a full token into, at the normal laptop width.

## Notes

- **Independent:** frontend only. No migration, no API change.
- Where: `app/frontend/src/integrations/collection/Accounts.tsx`, the `replacing` branch of the secret column. That's a `PasswordInput size="xs"` with no `w`/`miw` inside `<Group gap="xs" wrap="nowrap">` in a `Table.Td`, followed by `KeyExpiryFields`.
- Read `brief/information-architecture.md` → *Screen conventions* first, and run the screen-conventions test.