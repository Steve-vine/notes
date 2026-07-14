---
id: 01KXGSCBA8SG28T8SM3YWANMY4
created: 2026-07-14T17:04:19.78433007Z
updated: 2026-07-14T17:04:19.78433007Z
type: task
title: Re-author imported policies as native content
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 44
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