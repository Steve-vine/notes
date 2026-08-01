---
id: 01KYY8FRZ56SEXQD0KB6KDS5DD
created: 2026-08-01T08:54:10.149712Z
updated: 2026-08-01T08:54:10.149712Z
type: task
title: Register documents on the Confluence integration's own page, not a separate Documents nav item
assignee: steve
priority: medium
label: improvement
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 458
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
