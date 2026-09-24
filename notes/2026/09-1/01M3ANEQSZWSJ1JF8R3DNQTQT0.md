---
id: 01M3ANEQSZWSJ1JF8R3DNQTQT0
created: 2026-09-24T21:34:28.159987Z
updated: 2026-09-24T21:34:30.664948Z
type: task
title: A domain shows all of its documents, not just its policy
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 746
sprint: s71mee4
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Content types are user-defined (Content → Mappings, ADR 0030 §2), but the domain page still refers to one of them by name. Its top card is **Policy**. It asks for content of type `policy` in the domain and shows only the **first** match. The card breaks if Policy is renamed at the slug level or deleted. It hides a second policy in the same domain, and it never shows the domain's standards, procedures, runbooks or any type someone adds.

## What changes

The **Policy** card on a domain's page becomes a **Documents** section: every document linked to that domain, of any content type, each one linking to its page.

- Each row shows the document's **title** (a link to `/content/<slug>`), its **type** and its **status** (a draft is visibly a draft).
- Rows are ordered by content type (the order set in Mappings), then by title.
- A domain with no documents says so: *"No documents are linked to this domain."* The current wording, *"No policy imported for this domain."*, is a leftover from the original PDF import.
- Documents whose type has been **disabled** still appear. Disabling a type stops new documents using it but doesn't hide existing ones.
- A viewer sees the same documents they would see in the Content list for this domain. This task adds no new visibility rule.

## Done when

- The domain page no longer mentions `policy` by name. Grep `DomainDetailPage.tsx` for `'policy'` and it returns nothing.
- A domain with two policies, a standard and a runbook shows all four.
- Renaming or deleting the Policy type doesn't break the page.
- The section follows *Screen conventions* in `brief/information-architecture.md` (card, pill, sortable-table rules if it's a table).

## Notes

- The data is already available: `GET /api/v1/content?domain=<slug>` without the `type` filter returns every item in the domain. Expect a frontend-only change plus tests, with no API or schema change.
- Out of scope: the seed importer (`seed/policies.py`) still looks up the `policy` type by slug to file the original imported PDFs. It only runs when that starting data is loaded, so it's left as is.

Raised in sprint 61 (Content upgrade) planning, 2026-09-24.