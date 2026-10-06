---
id: 01M486Q0M25AAX7KY1C4XBGZNB
created: 2026-10-06T08:54:03.650832Z
updated: 2026-10-06T08:54:05.516004Z
type: task
title: The joiner form accepts a sign-in name with no domain — the account then gets @MP7400.onmicrosoft.com
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 844
sprint: sme8esk
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found by Steve testing the joiner process on staging, 2026-10-06.

## What happens

The joiner **Angus Plop** (request raised 2026-10-06 07:53) was given the User principal name `angus.plop` — no `@` and no domain. Compass accepted it, the request was approved, and the account was created in Active Directory with exactly that. When the account synced to Entra, Entra had no domain to go on and filled in the tenant's fallback: **angus.plop@MP7400.onmicrosoft.com**. Exchange Online then gave the mailbox the same address.

It is not caused by a missing email field. The joiner raised on 2026-10-02 with the domain typed (`aardvark.smith@moneypenny.co.uk`) has the right sign-in name in Entra. Across staging's synced accounts the email address is the same as the sign-in name for 1,109 of 1,127 people on the two real domains — the email follows the sign-in name.

Nothing warned anyone at any step, and the mistake is only visible once the account exists.

## What people should see

**The sign-in name is typed in two parts: the name, then `@`, then the domain chosen from a list.**

- The list holds the domains the organisation actually signs in with (on staging: `moneypenny.co.uk` and `moneypenny.com`). The fallback `…onmicrosoft.com` domain is not offered.
- The organisation's default domain is pre-selected; with only one domain there is nothing to choose.
- Pasting a whole address (`ada.lovelace@moneypenny.com`) into the name box splits it — the name stays, the domain is selected — and an address on a domain that isn't in the list is refused there and then, saying which domains are.
- The same control is used wherever the sign-in name can be corrected at approval.
- A request raised any other way (through the API) with no domain, or a domain not on the list, is refused **when it is raised**, with the same message — never discovered after approval.

## Fixing the account already made

Angus Plop's account needs its sign-in name changed by hand in Active Directory to `angus.plop@moneypenny.co.uk` (or deleting, if it was only a test); the sync carries the change to Entra. Compass doesn't repair it.

## Decisions taken (say if any is wrong)

- **A list, not just a check for an `@`.** Requiring an `@` would still let `@moneypeny.co.uk` or `@moneypenny.local` through, with the same result. Staging has two real domains in use, so people do need to choose.
- **The list comes from the directory, not from a setting someone maintains** — it can't go stale.

## Notes (technical)

- No validation today: `JoinerRows` in `app/frontend/src/access/RaiseRequestModal.tsx` takes any non-blank string (`row.user_principal_name.trim()`), the API stores it, and `_join_in_ad` (`tasks/access_execute.py`) passes it straight to `ad_writer.create_user` as `userPrincipalName`. In Entra ID only the same input would instead fail at `POST /users` — after approval — which is the same defect with a louder ending.
- Where the domain list comes from (Compass holds none today — no `verifiedDomains` / UPN-suffix code exists):
  - Entra ID only and Hybrid: the tenant's verified domains from Graph (`/domains`: `isVerified`, `isDefault`, `isInitial` — drop the initial `onmicrosoft.com` one; `isDefault` is the pre-selection). Check which Graph permission the app already holds covers it (`Domain.Read.All`, or `organization?$select=verifiedDomains` under an existing one) — a new permission means an admin consent and a worker restart before the token carries it.
  - AD only: the forest's UPN suffixes (`uPNSuffixes` on `CN=Partitions,CN=Configuration,…`) plus the forest's own DNS name.
  - Hybrid is the Entra list: a suffix AD accepts but Entra hasn't verified is exactly what produces `onmicrosoft.com`.
  - Read on the mirror's schedule and store it, so the form doesn't call the directory on open and still works when the directory is briefly unreachable. Until a list has been read, fall back to "must contain `@` and a domain" rather than blocking joiners.
- Server-side validation on raise and on a gate save (one validator), comparing the domain case-insensitively. Also reject whitespace and the characters neither directory allows in the name part.
- Gate editor: the UPN `TextInput` in `SubjectFieldsEditor.tsx`. A request raised before this ships may hold a domain-less name — the gate must show it as invalid and make the approver fix it, not crash on the split.
- Overlaps COM-840, which rebuilds each joiner's block on this form: whichever lands second adopts the other's layout. Independent otherwise — this can ship first.
- API change → regenerate `schema.d.ts`, run the drift script.

## Done when

- The joiner form and the gate editor take the name and a domain from the list; the default is pre-selected; a pasted address is split; a domain not on the list is refused.
- The API refuses a joiner with no domain or an unlisted one at raise.
- Tests: the control (split on paste, default, single domain, refusal), the API validator, the domain read for each setup, a legacy domain-less request at the gate.
- Smoke-tested on staging: a joiner raised with each real domain arrives in Entra with that sign-in name and email.