---
id: 01KYY8FRZ56SEXQD0KB6KDS5DD
created: 2026-08-01T08:54:10.149712Z
updated: 2026-08-07T10:09:18.559577Z
type: task
title: Register documents on the Confluence integration's own page, not a separate Documents nav item
project: 01KX671DATY39VW6GWK3M2T3DN
number: 458
sprint: sfv5yw0
blocked_by:
- 01KYY8EV8ENGWQ3939EA3TW7WM
comments:
- id: 01KYYCSB8GHXWHSVDQ62BND4JZ
  author: Steve Vine
  at: 2026-08-01T10:09:18.0961Z
  text: |-
    Built 2026-08-01 — PR #397 (stacked on #396/ISE-455), merged to staging.

    DocumentsPage became DocumentRegisterCard via git mv, gated on the documents capability. The register modal lost the integration picker that ISE-455 had to add to keep its own branch building — the card knows whose page it is on, and the server refuses a URL the account does not host, so the mistake surfaces as "wrong Confluence account" at the moment it is made.

    Orphan handling, left open at planning time, resolved as: each Documents card lists orphaned registrations by name with an invitation to adopt (register again here) or remove. Backed by the `orphaned` filter added in ISE-455 and pinned by a test.

    The staging merge conflicted in THREE files, all because this branch came off ISE-455 and never saw ISE-456/457:
    - App.tsx and nav.ts — each side still had the other's page/nav entry; resolved by dropping both, since all three pages are deleted.
    - SystemDetailPage.tsx — here the resolution is "keep BOTH", and my first mechanical attempt interleaved the two card blocks and dropped a closing brace. The build caught it. Rewrote the region by hand so all three register cards render in order before ActionsPanel.

    Also worth recording: the full frontend suite failed ONCE during merge verification (1 of 476) and passed clean on re-run — the known load-flake in this suite, not a real break. Re-ran rather than assuming.

    Test file moved with it: renders the card directly instead of <App /> at a route that no longer exists. Every original assertion survives; three new ones cover the scoped query, the posted system_id, and the orphan callout.

    Gates: frontend 476 tests / 84 files; build, eslint, prettier green.
assignee: steve
label: null
priority: medium
task_status: done
---
The third of the register moves (Steve, 2026-08-01), and the one with a prerequisite: **blocked by the instance-ownership task** — until `system_id` is operator-chosen and the unique constraint is `(system_id, url)`, a per-instance card would be a filtered view of a global register rather than a register the integration owns.

**Changes**
- **New `DocumentRegisterCard` on `SystemDetailPage`**, rendered when the system's capabilities include `documents` — same card pattern as the rest of that page. It carries, for ONE integration, what `DocumentsPage` does globally today: the registered documents with fetch status, freshness (`source_modified_at`, last-changed) and unreachable count, register by URL, edit description, deregister, tags.
- **Registration posts the card's own `system_id`** — no URL guessing. A URL the integration's site does not host is rejected server-side (422) and the card shows that message, so the failure reads as "wrong Confluence account", not "broken link".
- **Orphaned documents** (`system_id` NULL — registered before the ownership change, or left behind by a deleted integration) appear on no integration's card. Surface them somewhere honest rather than letting them vanish: simplest is a line on the card of each Documents integration offering to adopt them. Agree the treatment during build; the one unacceptable outcome is silence.
- **Delete `pages/DocumentsPage.tsx` and the `/documents` route**; remove the Documents entry from `NAV_SECTIONS`. Note `DocumentsPage.test.tsx` renders `<App />` at `/documents` — it moves to the card.

**Acceptance**
- With two Confluence integrations configured against different accounts, each integration's page lists only its own documents, and the same URL can be registered under both.
- Registering a URL the chosen integration cannot fetch shows a readable rejection on the card.
- Documents is gone from the left nav; `/documents` no longer resolves.
- Documents still reach the estate through their tags, and the on-demand `read_document` path is untouched.
- `npm run build`, eslint, `format:check`, vitest and the backend suite green.
