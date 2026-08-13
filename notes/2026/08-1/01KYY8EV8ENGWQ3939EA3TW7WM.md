---
id: 01KYY8EV8ENGWQ3939EA3TW7WM
created: 2026-08-01T08:53:39.72662Z
updated: 2026-08-13T18:59:59.990612Z
type: task
title: 'Documents become instance-owned: registered against a chosen Confluence integration, not whichever one claims the URL'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 455
sprint: sfv5yw0
comments:
- id: 01KYYC6NWZ5XPSVVPVN308WK0D
  author: Steve Vine
  at: 2026-08-01T09:59:06.39903Z
  text: |-
    Built 2026-08-01 — PR #396, merged to staging (e2f3ebd). ADR 0070, migration 0082.

    Everything in the plan landed. Three things it did not anticipate:

    1. ADR 0042's "register it anyway and explain later" had to be RETIRED, not just adjusted. A URL nothing recognised was previously accepted with an explanatory fetch_error. That was coherent while binding was automatic; once the operator NAMES the integration, a URL it cannot fetch is a mistake to correct at that moment — accepting it creates a row that can never be fetched and whose eventual error reads as a broken link rather than "wrong account". ADR 0070 §2 records the reversal explicitly and a test pins it.

    2. The plan cited "ADR 0042 §2" as the section being amended. That was the citation in the model's code comment, not what §2 actually says (§2 is "Documents are a connector capability"). The URL-only identity rule is in §1. ADR 0070 amends §1 and the resolution behaviour §2's capability framing implied, and says so.

    3. GET /documents needed an `orphaned` filter that was not in the plan. Once the register lives on integration pages, a document whose integration was deleted belongs to no page at all — it would be data that exists but is unreachable from every screen. ADR 0070 §3 records it.

    Also: making DocumentWrite.system_id required broke the frontend build, so DocumentsPage's register modal gained an integration picker on this branch. ISE-458 deletes that page, but this branch has to stand on its own.

    Gates: full backend suite 2035 passed (this touched a shared function, so the whole suite ran, not just the document tests); migration check green — ORM matches migrations; frontend 472 / 83 files; ruff, mypy strict, build, eslint, prettier green.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Foundation for the Documents card task. **Headless by design** — no user-facing surface of its own; the screen lands in the dependent task. Called out explicitly per the DoD rather than assumed.

**Today (ADR 0042 §2).** `document` is unique on `url` ALONE, and `system_id` is *derived*: `documents.resolve_system()` asks every Documents-capable connector "is this URL yours?" and takes the first yes (Confluence answers by matching the hostname of its configured site). Repos and status pages already work the other way — unique on `(system_id, …)`, with `system_id` chosen by the operator in the POST body.

**Steve's call 2026-08-01:** two Confluence integrations means two separate Confluence *accounts*, not two views of one wiki, so a central URL-keyed register is the wrong model. Make documents instance-owned like the other two registers.

**Changes**
- **Migration 0082** (head is 0081): drop `uq_document_url`, add `uq_document_system_url` on `(system_id, url)`. No data backfill needed — existing rows already carry a resolved `system_id`. Rows no connector claimed stay NULL, and Postgres treats NULLs as distinct in a unique index, exactly as `repo` and `status_page` already live with.
- **`DocumentWrite` gains a required `system_id`** — the operator picks the integration, as they already do when registering a repo or a status page.
- **`resolve_system()` inverts from discovery to validation.** Keep `connector_owns()`, but use it to *reject* a registration (422) whose URL the chosen integration cannot fetch — "that page is not on this Confluence site". Registration stops searching.
- **Drop the lazy re-resolve in `scrape()`** (`documents.py`, the `if document.system_id is None` branch). Silently re-attaching an orphaned document to whichever instance now claims the hostname is precisely the ambiguity this task exists to remove; an orphan stays orphaned and visible until a human re-registers it.
- **`GET /documents` gains a `system_id` filter** — the per-instance list the card will read.
- **ADR 0070** amending ADR 0042 §2 (append-only — supersede the section, never rewrite it). Record why URL-global was chosen originally and what changed: separate accounts, not separate views of one wiki.

**Acceptance**
- The same URL registers successfully under two different Confluence integrations and yields two rows.
- Registering a URL against an integration whose site does not host it returns 422 with a message an operator can act on.
- `GET /documents?system_id=` returns only that instance's rows.
- Existing registrations survive the migration with their bindings intact.
- ruff, mypy strict and the full backend suite green; OpenAPI snapshot regenerated.
