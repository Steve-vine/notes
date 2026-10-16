---
id: 01M525AAFP4Y56YRJ1BYVK19YY
created: 2026-10-16T10:49:54.422767Z
updated: 2026-10-16T14:21:32.030765Z
type: task
title: Document review is a block you place — {{document-review}}, like Contents, Posture and Domain controls — instead of a page always added at the end
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1007
sprint: s2ufsxd
comments:
- id: 01M52HDMY7RTYH3ST8N4GP09PQ
  author: Steve Vine
  at: 2026-10-16T14:21:26.342806Z
  text: |-
    Done in PR #996 (main 31ddaacf). Insert ▸ Document review places the review record exactly where you put it — in the PDF, Print preview, Word and plain text; in Markdown it's {{document-review}}. A document without the block has no review record. It has no page break of its own; put a Page break before it if you want it on its own page. The assistant knows the block. ADR 0110 has an amendment.

    On deploy: every templated draft gets a Page break and a Document review block added at the end of its last section, so each PDF looks as it does today; authors can move or delete it. Documents' "updated" time doesn't change and published documents don't show unpublished changes. Published versions are never edited: each existing version is marked as "from before" and is read as ending with the review record — when printed, restored, or compared with the draft. SharePoint (managed) documents keep the review page added at the end.

    My call (from the task), not confirmed: new documents start without the block.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Asked for in Steve's smoke test of sprint 71, 2026-10-16: "Can the Document Review be made a tag inserted content, like Contents, Posture and Domain controls rather than always added on."

**Builds on COM-1006**, which makes the review record part of the document in the house style. Build that first, or in the same branch.

## What people see

- **Insert ▸ Document review** in the editor's Insert menu, beside Contents, Posture, Domain controls and Page break.
  - In the editor it shows as the same kind of placeholder block: "Document review: filled in when the document is made".
  - In Markdown it's `{{document-review}}` on a line of its own.
- **Where it's placed, the document shows its review record:** a "Document review" heading, then one row per recorded review (Reviewed, Reviewer, Job title, Comment), newest first, in the house style's table look. With no reviews yet it says "No reviews recorded yet."
  - It sits wherever you put it: the end, the front, after the approval section.
  - **No page break of its own.** If you want it on a page by itself, put a Page break before it.
- **A document without the block has no review record at all.** Nothing is added on.
- **The same in every format:** the PDF, Print preview, Word and plain text all place it where the block is. The Read tab shows the placeholder, as it does for Contents.
- **Several blocks** in one document each show the record. That's allowed but unusual.
- **Documents that already exist keep their review record on the day this ships.** Each existing templated document gets a Page break and a Document review block added at the end of its last section, so its PDF looks exactly as it does now. Authors can then move or delete it like any other block.
- **Versions already published** keep their review page at the end, as they printed when they were published. A published version is frozen and isn't edited.
- **New documents** start without it. Insert it where you want it.
- **Documents kept in SharePoint** (managed content) can't hold Compass blocks, so they keep the review page added at the end, as now.
- **The assistant** knows the block, and can place it when asked.

**My call:** existing documents get the block, so nothing silently disappears from a document that printed with its review history yesterday, and new ones start without it. Say if you'd rather new documents start with it at the end too.

## Technical

- **The block:** add `document_review` to `SPECIAL_KINDS` (`core/richtext/schema.py:31`) and to `schema.json`, the shared contract with the frontend's `extensions.ts` test.
  - Markdown `{{document-review}}`: `convert.ts:34` regex, `parse.py` / `serialise.py`.
  - The editor label goes in `commands.ts` (beside `domain_controls: 'Domain controls'`) and the Insert menu.
  - Round-trip it in the converter's idempotence tests.
- **Rendering:**
  - `core/render/html.py` fills the block with the review table (COM-1006's markup, minus its forced page break);
  - `word.py` and `plaintext.py` do the same in place;
  - remove the "always at the end" from `_ensure_styled_pdf`, the docx `render_docx(..., review_rows)` tail (`word.py:503`) and `_plain_text`.
  - The reviews digest stays in the cache key only when the block is present, or simply always (it's cheap).
- **Existing drafts (data migration, append-only):** for every templated item with sections, append `pageBreak` + `specialBlock{kind:"document_review"}` to the last section's `doc`, and `{{page-break}}\n\n{{document-review}}` to its body. Items with no sections are still read from `body`, so append there.
  - Don't touch `content_versions` snapshots.
  - Write it in raw SQL/JSONB, not the ORM ([[migration-tests-orm-fixtures-drift]]).
  - Test it against a populated database, not just a fresh one ([[migrations-fresh-db-blindspot]]).
  - The migration must not bump `updated_at` or count as an unpublished change. Otherwise every published document shows "unpublished changes" on the day.
    - Option: append to the latest version snapshot too, the only exception to "frozen", and document it in the ADR.
    - Option (preferred): a `review_record_legacy` boolean on `content_versions` (true for every existing row), so a version published before this change still gets the record at the end when rendered. Then the draft's new block isn't a difference from the published version for the unpublished-changes check, because the comparison treats a legacy version as if it ended with the block.
    - Decide in the PR and say which.
- **The Insert menu** order: Contents, Posture, Domain controls, Document review, Page break.
- **Assistant:** `assistant/tools/content.py` describes the special blocks. Add `{{document-review}}`.
- **ADR:** an addendum to ADR 0110 (special blocks) noting the review record moved from always-appended (ADR 0034 / DEV-759) to placed, and the legacy rule.
- **Tests:**
  - parse/serialise round-trip;
  - a PDF with the block mid-document has the table there and no page added at the end;
  - a document without the block has no review record;
  - a pre-change version still has it at the end;
  - the migration on a populated DB leaves `has_unpublished_changes` false for published items.

## Done when

- [ ] Insert ▸ Document review places the review record exactly there, in the PDF, Word and text.
- [ ] A document without it has no review record.
- [ ] Every existing document's PDF looks the same on the day it ships, and authors can move or remove the block.
