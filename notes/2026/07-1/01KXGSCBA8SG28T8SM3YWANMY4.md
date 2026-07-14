---
id: 01KXGSCBA8SG28T8SM3YWANMY4
created: 2026-07-14T17:04:19.78433007Z
updated: 2026-07-14T18:32:51.658741238Z
type: task
title: Re-author imported policies as native content
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 44
sprint: sd5fyv6
comments:
- id: 01KXGSCS4M1WH41B3Q8KRVF9RG
  author: Steve Vine
  at: 2026-07-14T17:04:33.940158866Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-17 19:50 UTC]
    **Done — in review.** PR [#43](https://github.com/Steve-vine/compass/pull/43) (`steve/dev-458-re-author-imported-policies-as-native-content`). Full-stack, one PR.

    **What was built**
    - **Backend**: `ContentItem.source` (imported/authored) + migration `0017` (backfills existing rows to imported). Importer sets `imported` on insert and **no longer clobbers** a re-authored policy on re-run (only re-attaches the PDF) — the deploy import Job is safe. Publish flips imported→authored. `POST /content/{slug}/seed-from-pdf` extracts the PDF text (pypdf) into the draft, guarded to `source=imported`.
    - **Frontend**: source badge (list + detail header); Read tab leads with the PDF + a note when imported; Edit tab "Seed draft from PDF" button (imported + PDF). Regenerated `schema.d.ts`.

    **Decisions made on the fly**
    - Publish = the imported→authored flip (no separate action).
    - `seed-from-pdf` overwrites the working draft and is refused once authored (409); pypdf gives rough plain text the author cleans up.

    **Problems encountered** — none of note. The schema regen also pulled in the decisions/notifications types merged since DEV-457 (correct — reflects `main`).

    **Checks** — green locally: `ruff check .`, `ruff format --check .`, `mypy src`, `pytest` (31), `pytest -m integration` (116, incl. 3 new); `npm run lint/typecheck/format:check`, `npm test` (56, incl. 2 new).
blocked_by:
- 01KXGS9Z64EZRB79H2HF29BQJH
- 01KXGSBD1SRS5FJ749RACBD3JZ
---
Turn the M2-imported `policies/` PDFs into native, authored Compass content, retaining the PDF for provenance (ADR 0013). Since the M2 import already models each policy as a `ContentItem` (PDF attached, placeholder body) and <issue id="d3a26549-40dd-4c14-9152-47129d684b16" href="https://linear.app/stevevine/issue/DEV-456/content-authoring-versioned-model-api">DEV-456</issue>/457 make those editable, this brief adds the imported→authored distinction, a seed-from-PDF head-start, and a PDF-forward read view until re-authored. **One full-stack PR.**

**Agreed approach (planned 2026-06-17).**

- [ ] `source` **field** on `ContentItem` — `ContentSource` enum (`imported` / `authored`), model default `authored`. Migration `0017` adds the column (+ enum) and backfills existing rows to `imported`.
- [ ] **Importer** (`seed/policies.py`): set `source=imported` on insert; on re-run **leave body/status/source untouched** for existing items (only refresh the PDF attachment + domain link) so a re-authored policy isn't clobbered by the deploy import Job.
- [ ] **Publish flips** `imported → authored` (existing publish handler) — the "re-authored" moment.
- [ ] `POST /content/{slug}/seed-from-pdf` (admin/editor): read the PDF attachment from storage, extract text with **pypdf**, set it as the draft `body` + `status=draft`. Guarded: requires a PDF attachment and `source=imported` (409 if already authored). New dep `pypdf`.
- [ ] **Schemas**: add `source` to `ContentItemOut`/`Detail`.
- [ ] **Frontend**: list `source` badge (Imported PDF / Authored); Read tab leads with the PDF + note when `source=imported`, Markdown when `authored`; Edit tab **"Seed draft from PDF"** button (when imported + PDF) → `useSeedFromPdf`. Regenerate `schema.d.ts`; add hook + `client.ts` types.
- [ ] **Tests**: backend — importer sets imported, re-run doesn't clobber, publish flips to authored, seed-from-pdf extracts real text + guards (no-PDF / already-authored 409 / role); frontend — source badge + seed button (fetch-stub).

Refs: ADR 0013. Depends on: <issue id="d3a26549-40dd-4c14-9152-47129d684b16" href="https://linear.app/stevevine/issue/DEV-456/content-authoring-versioned-model-api">DEV-456</issue>, <issue id="bcc55d57-5fea-40ee-8a6f-57e65bda891e" href="https://linear.app/stevevine/issue/DEV-457/content-authoring-ui-markdown-editor-version-history">DEV-457</issue> (done). Relates to: M2 import, M3 attachments. The PDF stays the provenance attachment throughout; progressive policy-by-policy.

---
*Migrated from Linear [DEV-458](https://linear.app/stevevine/issue/DEV-458/re-author-imported-policies-as-native-content) · created 2026-06-17 · completed 2026-06-17*