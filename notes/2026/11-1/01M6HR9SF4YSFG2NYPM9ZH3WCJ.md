---
id: 01M6HR9SF4YSFG2NYPM9ZH3WCJ
created: 2026-11-03T22:25:58.24427Z
updated: 2026-11-04T07:45:54.871428Z
type: task
title: 'Link a stored copy to its secret by a tag — `compass-secret: SEC-12` on the vault entry attaches it on the next read; Compass also suggests pairings from names and timing for a person to confirm or dismiss'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1571
sprint: sjrd5gz
blocked_by:
- 01M6HR9DYQNBZJDG8QK5XCM0WQ
comments:
- id: 01M6JC4554NZSFG72XTGKQREVR
  author: Steve Vine
  at: 2026-11-04T04:12:25.124604Z
  text: |-
    Merged to main in PR #1585 (518b3212).

    **What's in it**
    - A stored copy tagged `compass-secret = SEC-12` in AWS or Azure is kept under SEC-12 on the next read. A tag naming a secret that doesn't exist, or one in another company, leaves the copy on Discovered and says why.
    - Discovered suggests a likely secret for a copy, from its name and from its change landing near the secret's last rotation: "Looks like SEC-12". Confirm it, or dismiss it for good.
    - Taking a copy off a secret remembers that, so neither the tag nor the suggestion puts it straight back.

    Tested by the linking integration tests, with tags, suggestions, dismissals and detach.
- id: 01M6JPZRTF916JG0HE9ESZEHR2
  author: Steve Vine
  at: 2026-11-04T07:22:15.759612Z
  text: |-
    **Pre-UAT: Couldn't check.**
    - Linking by tag and suggestions both need copies that a store read put on Discovered. E2E Test Company has no store connection, and seeding copies into staging's database was blocked.
    - The secret's Kept in card shows "Link automatically" with the tag to copy, including the lower-case Google form (`sec-12`).
    - **For Steve:** on a company with AWS secrets, tag one `compass-secret = SEC-n` and wait for the next read.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1570.

## What people see

- **On a secret's Kept in card: "Link automatically".** It shows the exact tag to add to the vault entry, with a copy button:
  - key `compass-secret`, value `SEC-12`.

  On the next read, an entry with that tag is attached to the secret by itself, and the history says **"Attached by its tag"**. Compass never writes the tag: whoever stores the secret adds it, ideally in the same script that stores it.
- **A tag Compass can't use** keeps the entry on Discovered, with the reason:
  - "Its tag names SEC-99, which isn't in this company"
  - "Two entries name SEC-12 in the same place"
- **Suggestions on Discovered.** "Looks like SEC-12 · Stripe live key" when:
  - the entry's name is close to the secret's name, its source or the system using it (`billing-api/stripe` ↔ "Stripe live key", used by billing-api); or
  - the entry changed within a day of a rotation recorded on that secret.

  **Confirm** attaches it. **Not this one** dismisses the suggestion for good.
- A stored copy belongs to **one** secret. A secret can have **many** stored copies (two regions, two vaults).
- **Removing the tag later doesn't detach** anything. Detaching is a deliberate act on the secret: "Not this secret", which sends the entry back to Discovered.

## Notes (technical)

- Tag matching runs at the end of each read, per company. The tag is case-insensitive, and the value must match `SEC-\d+`.
- Suggestions: a cheap name similarity (normalised tokens) plus a timing signal. Dismissals are stored per (entry, secret).
- The `compass-source-key` tag (pairing with a key at its source) arrives with the first read source, COM-1573.

**Chain:** on the chain (migration and API).

**Done when:** on staging, in E2E Test Company:
- a seeded store entry tagged `compass-secret: SEC-1` is attached after a read, with "Attached by its tag" in the history;
- a seeded entry named `billing-api/stripe-live` is suggested for "Stripe live key (billing-api)";
- dismissing it keeps it dismissed after the next read.