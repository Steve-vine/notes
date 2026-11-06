---
id: 01M6RQMX2D42QN9A7E6VQFZK91
created: 2026-11-06T15:29:14.829885Z
updated: 2026-11-06T15:29:14.829885Z
type: task
title: '"Polaris wasn''t sure of" tells the person what to do — each point says what it means for them and whether they need to check or change anything; points that need nothing from them aren''t shown'
label: improvement
task_status: todo
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1621
---
Found by Steve while testing on staging (2026-11-06): adding a GitHub Collection integration with Polaris.

## What happens

The review step shows a box headed "Polaris wasn't sure of" listing what Polaris noticed in the docs, e.g.:

- GitHub suggests sending an X-GitHub-Api-Version header (e.g. 2026-03-10). If Compass leaves it out, GitHub uses its default API version.
- A few list endpoints (e.g. search, /installation/repositories) put their items inside an object (items, repositories) instead of returning a bare array. The item path depends on the endpoint.

The person can't tell what, if anything, to do about either. The first is something Compass can't do at all (no extra headers), and GitHub's default works, so it needs nothing from them. The second is about how later checks read GitHub, not about this form.

## What it should do

Each point is written for the person, in three kinds:

- **Check this before you save:** a field on the form Polaris guessed at. Name the field and what to compare it with (e.g. "Base address: GitHub Enterprise Server uses your own host, so change it if that's you").
- **Good to know:** a limit that changes what Compass can read, in plain words and with its effect (e.g. "Compass reads GitHub's default API version. That's fine for evidence.").
- **Nothing to do:** don't show it.

If nothing is left, there is no box. Rename the box so the heading says what it is for, e.g. "Check before you save".

## Done when

- Polaris is told to sort each point into one of the kinds above, name the field when there is one, and drop points that need nothing from the person. The kind is kept with the point, so the screen can group them.
- The review step shows "Check before you save" points first, beside the field they name where possible, then "Good to know" points. There is no box when there are none.
- Re-running GitHub on staging gives no point the person can't act on. The wrapped-list point goes away once the separate item-path task lands, or reads as "Good to know" with its effect until then.

## Where

- `app/backend/src/compass_api/core/collection/polaris_define.py`: the `unsure` field in DEFINE_SCHEMA and the DEFINE_SYSTEM prompt.
- `app/frontend/src/integrations/collection/WithPolarisPage.tsx`: the "Polaris wasn't sure of" Panel in Review.