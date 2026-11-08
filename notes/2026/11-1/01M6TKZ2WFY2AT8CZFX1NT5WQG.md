---
id: 01M6TKZ2WFY2AT8CZFX1NT5WQG
created: 2026-11-07T09:03:23.023656Z
updated: 2026-11-08T08:59:57.873268Z
type: task
title: Every key Compass signs in to an integration with is in the Secrets register by itself — its expiry known or asked for, its owner reminded before it runs out, and the replacement recorded as a rotation when someone puts in a new key
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1625
sprint: s5khbev
comments:
- id: 01M6TZGF3PYS86XKZP2NJSVE37
  author: Steve Vine
  at: 2026-11-07T12:25:06.934577Z
  text: |-
    **Done: merged to main in PR #1652, for Collection integrations.** Core connections are split into **COM-1639** (backlog), as this task allowed. It reaches staging with the rest of sprint 107.

    **What it does:** every Collection account's key is now a secret in that company's Secrets register, made by Compass with nothing to add by hand.
    - **The secret:** named e.g. "GitHub · Engineering: Compass's key". Its kind follows how the service signs in, its owner is the integration's owner, and it's stored in "Compass ▸ GitHub ▸ Engineering". The register never holds the value.
    - **Expiry:**
      - Adding or replacing a key asks **"Key expires on"** or **"It doesn't expire"**.
      - Where the service says itself (GitHub does, on every answer), its date replaces what was typed at the next Test.
    - **Alerts** are the register's own, unchanged: the owner is reminded before the key expires, and an overdue key raises the secrets check's gap.
      - Inside the reminder window, the account row says "Key expires in 12 days", in red once expired, with a link to its secret (SEC-n).
      - The integration's tile says which account and when.
    - **A new key** is recorded as a rotation, proven because Compass saw it change.
    - **Removing the account, or the integration,** retires its secret and keeps its history. The register won't let anyone retire it while the account is still there.
    - **Accounts made before today** are registered by the next deploy.
    - **Polaris in chat** answers "which keys expire this month?" with the existing secrets tools.
    - ADR 0141 is amended.

    **Not in this task: COM-1639** covers the credentials Compass holds for its Core connections (Microsoft, Exchange, AWS, Azure, Google, AD, mail, SSO, the attachment store and Polaris's key). It has one question for you: organisation-wide ones such as SSO need a home, because the register is per company.

    **To look at on staging:**
    - Admin ▸ Integrations ▸ GitHub ▸ Accounts: the account row shows the key's expiry and its SEC link.
    - Secrets: the key is in the register for Test Company.
    - Replace the key: a rotation shows on the secret.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Raised by Steve while testing on staging (2026-11-07): "with the potential to have many integrations with expiring credentials it would be useful if Compass was able to track and alert on expiring credentials in integrations."

## The idea

Compass already has a place for this: the **Secrets register** (ADR 0141). It works out when a secret is due, reminds the owner before it is due, raises a check when one is overdue, and records rotations. The keys Compass itself uses to sign in to integrations aren't in it. Today they appear only when they stop working: the account goes Broken and a "Fix sign-in" action lands on the integration's owner (COM-1611), after evidence has already been missed.

So each integration key joins the register on its own. Nobody adds it by hand.

## What the person sees

- **Adding or replacing a key** on a Collection account asks "Does this key expire?" with a date, or "It doesn't expire". If the service says itself when the key expires, Compass fills that in and says where the date came from. Examples:
  - GitHub's `github-authentication-token-expiration` header on any answer;
  - an Entra app secret's end date;
  - an OAuth token's lifetime does **not** count, as it is renewed automatically.
- **The register** shows a secret per key, e.g. "GitHub · Engineering org — read key". It shows kind (token, API key or client secret), owner (the integration's owner, editable), used by (the integration account, linked), stored in (Compass), and the expiry. There is never a value, as for every secret.
- **Before it expires** the owner gets the register's normal reminders. Overdue raises the secrets check's gap. The integration tile and account row also show "Key expires in 12 days" (orange within the reminder window, red once expired).
- **Putting in a new key** on the account records a rotation by itself, proven by Compass because Compass holds the key and saw it change. Its expiry is then updated, by reading it again or by asking.
- **Removing the account or the integration** marks its secret retired, keeping its history.
- **Core integrations too:** the Entra app secret or certificate, the AWS key and the AD service account Compass uses appear the same way where Compass can read their expiry. Entra already can: its app secrets are a Secrets source. Where Compass can't read an expiry, the person is asked once, on the connection's page.

## Done when

- Each Collection account's key and each Core connection's credential has exactly one secret in the register, created when the account or connection is added and existing ones backfilled. It is marked as Compass's own, so it can't be deleted from the register while the account exists.
- The expiry is read from the service where it says (GitHub header, Entra end date), otherwise asked when the key is entered. "It doesn't expire" is recorded as long-lived, information only, as the register already treats it.
- The owner is reminded, and the check raises its gap, through the register's existing reminders and check, not a new mechanism.
- The tile and account row show the days left once inside the reminder window, and "Expired" after.
- Replacing a key records a rotation (proof: Compass saw it change) and refreshes the expiry. Removing the account retires the secret.
- Polaris in chat: "which integration keys expire this month?" is answered by the existing secrets tools, since these are ordinary secrets.
- Tests: adding an account makes its secret; GitHub's header sets the expiry; replacing the key records a rotation; removing the account retires it; the backfill is idempotent.
- On staging: the E2E GitHub test service shows its key's expiry, a reminder is sent within the window, and replacing the key shows the rotation.

## Notes

- This needs an ADR amendment (0141 and 0142): Compass's own integration keys become secrets it registers itself. That is the one case where Compass holds the value, and it still never shows it.
- It is on the chain: a link from secret to integration account or connection (a migration) and API changes.
- It might split into two once scoped: Collection accounts first, then Core connections.
- Where: `core/secrets/` (records, due, rotations, sources), `core/collection/` (account create, update and delete, plus the client reading the expiry header), the Collection account form, and the integration tiles.