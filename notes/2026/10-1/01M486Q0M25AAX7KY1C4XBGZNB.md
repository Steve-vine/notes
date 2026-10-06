---
id: 01M486Q0M25AAX7KY1C4XBGZNB
created: 2026-10-06T08:54:03.650832Z
updated: 2026-10-06T15:17:38.149268Z
type: task
title: The joiner form accepts a sign-in name with no domain — the account then gets @MP7400.onmicrosoft.com
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 844
sprint: sme8esk
comments:
- id: 01M48KT9DH6EX88YREABXRVCQP
  author: Steve Vine
  at: 2026-10-06T12:43:02.449336Z
  text: |-
    Merged to main — PR #849 (2026-10-06).

    What people see now:
    - Joiner form: the sign-in name is a name, an @, and a domain chosen from a list. The default is pre-selected; with one domain it is just shown. Pasting a whole address splits it; one on a domain that isn't offered is refused there, naming the ones that are. Spaces and characters neither directory takes before the @ are refused too.
    - Access Control ▸ Admin ▸ Sign-in domains: every domain the directory has (the onmicrosoft.com fallback excluded), how many people sign in with each, a tick for the ones joiners can be given, and a default among the ticked. Nothing ticked → every domain is offered and the card says so. A new domain arrives unticked; a ticked one that leaves shows as "No longer in the directory" and stops being offered — if it was the default the card asks for a new one.
    - Through the API: no domain, or one not offered, is refused at raise with the same message.
    - Requests already raised: one with no domain can't be approved until it's corrected. One on a domain un-ticked since stands as raised unless the approver edits the name.

    One departure from the task's technical note — say if it's wrong: two tables rather than one. The directory's domains are stored once for the tenant, and each company's ticks separately. With one per-company table the sync would have had to write a copy of the same facts for every company, and a company created later would have had nothing to offer until the next read.

    Where the domains come from:
    - Entra ID only / Hybrid: the tenant's verified domains, read after every directory sync. Read through the "organization" object, which the permission Compass already holds covers — so no new permission, no admin consent, no worker restart.
    - AD only: the forest's own DNS name (the default) plus its UPN suffixes, during the AD read.
    - A failed read never fails the sync; the last list is kept.

    Tests: both reads; every refusal and its wording; the card; the form's list read by a requester with no Access write; raise refused/accepted; a legacy domain-less joiner at approval and at the gate; a joiner on a since-unticked domain; the control and the card on screen.

    After deploy:
    - The card fills in on the first directory sync after deploy (a few minutes). I'll compare it with what Exchange shows and note any difference here.
    - Angus Plop's account still needs its sign-in name changing by hand in AD (or deleting) — Compass doesn't repair it.
    - Smoke test: tick two domains, raise a joiner with each, check each arrives in Entra with that sign-in name and email.
- id: 01M48WNBQ5XM3N53TZJV6W57VB
  author: Steve Vine
  at: 2026-10-06T15:17:38.149009Z
  text: |-
    After the staging deploy (2026-10-06 15:15 sync): Compass read 16 sign-in domains from the tenant; moneypenny.co.uk is marked as the directory default.

    alpha-mail.com, alphapage.com, callpenelope.ai, cirravox.com, moneypenny.co.uk, moneypenny.com, moneypenny.uk, moneypenny.us, nextpbx.com, ninjanumber.com, qualityansweringservice.com, sunshine1.com, voicenation.com, voicenation.us — plus two that are mail-routing domains nobody signs in with: d8pdgfgt95h0v99v35r0y6w4bs.smtp.exclaimer.cloud and i27.gw.hellodoor.solutions.

    To do on the Sign-in domains card (Access Control ▸ Admin): untick the two routing domains, and any brand domains new starters shouldn't be given.

    Not done: I said I'd compare this list with Exchange's accepted domains. I can't read Exchange from here, so that comparison is yours to eyeball — the list above is every verified domain Entra reports.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found by Steve testing the joiner process on staging, 2026-10-06.

## What happens

The joiner **Angus Plop** (request raised 2026-10-06 07:53) was given the User principal name `angus.plop` — no `@` and no domain. Compass accepted it, the request was approved, and the account was created in Active Directory with exactly that. When the account synced to Entra, Entra had no domain to go on and filled in the tenant's fallback: **angus.plop@MP7400.onmicrosoft.com**. Exchange Online then gave the mailbox the same address.

It is not caused by a missing email field. The joiner raised on 2026-10-02 with the domain typed (`aardvark.smith@moneypenny.co.uk`) has the right sign-in name in Entra. Across staging's synced accounts the email address is the same as the sign-in name for 1,109 of 1,127 people on the two domains in use — the email follows the sign-in name.

Nothing warned anyone at any step, and the mistake is only visible once the account exists.

## What people should see

### On the joiner form

**The sign-in name is typed in two parts: the name, then `@`, then the domain chosen from a list.**

- The list holds the domains an admin has ticked for joiners (below). The default one is pre-selected; with only one domain there is nothing to choose.
- Pasting a whole address (`ada.lovelace@moneypenny.com`) into the name box splits it — the name stays, the domain is selected — and an address on a domain that isn't offered is refused there and then, saying which domains are.
- The same control is used wherever the sign-in name can be corrected at approval.
- A request raised any other way (through the API) with no domain, or a domain that isn't offered, is refused **when it is raised**, with the same message — never discovered after approval.

### On Access Control ▸ Admin — a new card, "Sign-in domains"

(Decided with Steve, 2026-10-06: the organisation has about 17 domains set up, far too many to offer on a joiner form, and most are never used to sign in.)

- The card lists **every domain the directory has** — Compass reads them; nobody types one, so a domain that doesn't exist can't be added. The fallback `…onmicrosoft.com` domain is not listed.
- Beside each: **how many people sign in with it today** (on staging: `moneypenny.co.uk` 929, `moneypenny.com` 198, the rest none) — so it's obvious which ones matter.
- **Tick the ones a joiner can be given.** Mark one of the ticked ones as **the default**.
- **Until anything is ticked, the joiner form offers every domain**, with the organisation's own default pre-selected, and the card says so — joiners are never blocked waiting for someone to set this up.
- A domain that appears in the directory later arrives **unticked**. A ticked domain that is removed from the directory shows as gone and stops being offered; if it was the default, the card asks for a new one and the form falls back to the organisation's own default meanwhile.
- Needs Access write, like the rest of this screen.

Changing the ticks affects joiner forms opened afterwards. Requests already raised keep the sign-in name they were raised with.

## Fixing the account already made

Angus Plop's account needs its sign-in name changed by hand in Active Directory to `angus.plop@moneypenny.co.uk` (or deleting, if it was only a test); the sync carries the change to Entra. Compass doesn't repair it.

## Decisions taken (say if any is wrong)

- **A list, not just a check for an `@`.** Requiring an `@` would still let `@moneypeny.co.uk` or `@moneypenny.local` through, with the same result.
- **The directory supplies the candidates; an admin chooses among them.** The candidates can't go stale or be mistyped; the choice keeps the form's list short.
- **One set of ticks for the organisation**, not one per business role. (A role defaulting the domain — "everyone in this role is `.com`" — would be a follow-on to COM-843 if wanted.)

## Notes (technical)

- No validation today: `JoinerRows` in `app/frontend/src/access/RaiseRequestModal.tsx` takes any non-blank string (`row.user_principal_name.trim()`), the API stores it, and `_join_in_ad` (`tasks/access_execute.py`) passes it straight to `ad_writer.create_user` as `userPrincipalName`. In Entra ID only the same input would instead fail at `POST /users` — after approval — which is the same defect with a louder ending.
- Where the candidates come from (Compass holds none today — no `verifiedDomains` / UPN-suffix code exists):
  - Entra ID only and Hybrid: the tenant's verified domains from Graph (`/domains`: `isVerified`, `isDefault`, `isInitial` — drop the initial `onmicrosoft.com` one and any `*.mail.onmicrosoft.com` routing domain; `isDefault` is "the organisation's own default"). These are what Exchange's accepted domains are provisioned from, so expect the ~17 Steve sees in Exchange; if the two lists differ on staging, note which and why in the PR. Check which Graph permission the app already holds covers it (`Domain.Read.All`, or `organization?$select=verifiedDomains` under an existing one) — a new permission means an admin consent and a worker restart before the token carries it.
  - AD only: the forest's UPN suffixes (`uPNSuffixes` on `CN=Partitions,CN=Configuration,…`) plus the forest's own DNS name (which is then the default).
  - Hybrid uses the Entra list: a suffix AD accepts but Entra hasn't verified is exactly what produces `onmicrosoft.com`.
  - Read on the mirror's schedule and store it (one table: company, domain, is_directory_default, last seen / vanished, **offered**, **is_default**). The form and the card read the table, never the directory, so both work when the directory is briefly unreachable. Before the first read has happened, fall back to "must contain `@` and a domain" rather than blocking joiners.
- The offered set = ticked, non-vanished domains; if that is empty, every non-vanished domain. One function, used by the form's GET and by the server validator on raise and on a gate save. Compare case-insensitively. Exactly one default among the ticked (enforce in the API: un-ticking the default, or ticking none, clears it).
- "How many people sign in with it": a grouped count over the mirror's live accounts by UPN domain — computed on read, not stored.
- Card goes in `SECTIONS` in `app/frontend/src/access/AccessAdminPage.tsx` (same file COM-839 adds "Joiner fields" to — independent cards). Screen conventions: `w="fit-content"` on each checkbox / radio; the table needs `SortableTh` or a no-sort comment.
- A requester needs the offered list without Access write — serve it from a GET guarded like raising a request, separate from the admin endpoints.
- Also reject whitespace and the characters neither directory allows in the name part.
- Gate editor: the UPN `TextInput` in `SubjectFieldsEditor.tsx`. A request raised before this ships — or before a domain was un-ticked — may hold a name the current list wouldn't offer. A domain-less one must show as invalid and be fixed before approval; one on a real but no-longer-offered domain is left valid as raised (don't make approvers rewrite history) unless the approver edits it.
- Overlaps COM-840, which rebuilds each joiner's block on this form: whichever lands second adopts the other's layout. Independent otherwise — this can ship first.
- API change → regenerate `schema.d.ts`, run the drift script. Migration: revision id ≤ 32 chars.

## Done when

- Access Control ▸ Admin has a Sign-in domains card listing the directory's domains with their head-counts; ticks and the default save; nothing ticked → the card says every domain is offered.
- The joiner form and the gate editor take the name and a domain from the offered list; the default is pre-selected; a pasted address is split; a domain not offered is refused.
- The API refuses a joiner with no domain or one not offered, at raise.
- Tests: the card (tick, default, none ticked, new domain arrives unticked, ticked domain vanishes); the control (split on paste, default, single domain, refusal); the API validator; the domain read for each setup; a legacy domain-less request at the gate.
- Smoke-tested on staging: the card shows the same domains Exchange does; tick two, raise a joiner with each, and each arrives in Entra with that sign-in name and email.