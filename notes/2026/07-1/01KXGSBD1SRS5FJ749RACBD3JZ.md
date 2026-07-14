---
id: 01KXGSBD1SRS5FJ749RACBD3JZ
created: 2026-07-14T17:03:48.793894881Z
updated: 2026-07-14T18:32:50.223957912Z
type: task
title: 'Content authoring UI: Markdown editor + version history'
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 43
sprint: sd5fyv6
comments:
- id: 01KXGSBTACCS7WNR2076MKM029
  author: Steve Vine
  at: 2026-07-14T17:04:02.380211316Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-17 15:00 UTC]
    **Done — in review.** PR [#40](https://github.com/Steve-vine/compass/pull/40) (`steve/dev-457-content-authoring-ui-markdown-editor-version-history`).

    **What was built** — the Content section upgraded from read-only browse to full authoring against the DEV-456 API. No new deps.
    - `src/content/hooks.ts` mirroring `risk/hooks.ts`; detail-returning mutations write straight into the query cache (no refetch flicker; revert lands synchronously).
    - **ContentDetailPage** — tabbed **Read / Edit / History**. Read: `published_body` + PDFs + linked-control chips (→ control detail) with an unpublished-draft note. Edit (admin/editor): Markdown textarea + live preview, debounced autosave, metadata panel (owner/domain/review dates), control link picker, Publish (change-note modal). History: versions list, unified-diff compare, revert.
    - **ContentPage** — status/type filters + role-gated New content create modal.
    - Regenerated `api/schema.d.ts`; nav copy updated.

    **Decisions made on the fly**
    - `type` is create-time only (the `ContentUpdate` API has no `type` field) — shown as a header badge, not an editable field.
    - Linked-control ids resolved to ref/title client-side via `useAllControls` (the link picker needs the full list anyway) rather than adding a backend endpoint.
    - Editor re-seeds on revert via a `key` remount (avoids a setState-in-effect lint rule); autosave debounce 800ms.

    **Problems encountered** — test timing only: modal fields and the second (controls) query needed `findBy*`; Mantine's `required` asterisk made the create-modal "Title" label non-exact (used `{ exact: false }`). No product issues.

    **Checks** — green locally: `npm run lint`, `npm run typecheck`, `npm run format:check`, `npm test` (54 passed). Backend (DEV-456) already merged & deployed.
blocked_by:
- 01KXGS9Z64EZRB79H2HF29BQJH
---
The Content section (ADR 0017) upgraded from the M2 read-only browse to full in-app authoring. Consumes the <issue id="d3a26549-40dd-4c14-9152-47129d684b16" href="https://linear.app/stevevine/issue/DEV-456/content-authoring-versioned-model-api">DEV-456</issue> content API (merged, #39). React + Mantine; mirrors `risk/hooks.ts` + `RiskDetailPage` conventions. No new deps (`react-markdown` renders the preview; diffs come pre-computed from the API).

**Agreed approach (planned 2026-06-17).** Detail page is **tabbed: Read / Edit / History**.

- [ ] **API layer.** Regenerate `src/api/schema.d.ts` against the 456 backend; add `api/client.ts` type exports (`ContentCreate`, `ContentUpdate`, `ContentPublish`, `ContentRevert`, `ContentVersion`, `ContentDiff`). New `src/content/hooks.ts` (mirrors `risk/hooks.ts`): list/get/create/update(autosave)/publish/revert/versions/diff/link+unlink controls, with the `errorMessage` helper and query invalidation.
- [ ] **ContentDetailPage — tabbed.** **Read** (everyone; viewer default): render `published_body`, PDF attachments, read-only linked-control chips → `/controls/:ref`; "draft changes not yet published" note when `body !== published_body`. **Edit** (admin/editor): Markdown `Textarea` + live preview two-up, debounced autosave (PUT, saving/saved indicator), side panel (title, owner, domain, type, review/next-review dates, linked-controls add/remove picker), **Publish** → change-note modal. **History** (admin/editor): versions list (version · author · date · note), pick two → unified diff, revert (confirm). Control titles/refs resolved client-side from the controls library.
- [ ] **ContentPage (list).** Add status (All/Draft/Published) + type filters; **New content** action (admin/editor) → create-draft modal that navigates to the new slug; viewers keep read-only browse. Update copy.
- [ ] **Nav copy** for Content. No new routes (create is a modal; `content/:slug` exists).
- [ ] **Tests** (Vitest, fetch-stub + `renderWithProviders`, mirror `RiskDetailPage.test`): new `ContentDetailPage.test.tsx` (viewer sees Read only; editor sees Edit/History; autosave PUT; publish posts change note; versions render; diff renders; revert; link/unlink). Extend `ContentPage.test.tsx` (status filter, role-gated create modal).

Refs: ADR 0013, 0017. Depends on: Content authoring versioned model + API (<issue id="d3a26549-40dd-4c14-9152-47129d684b16" href="https://linear.app/stevevine/issue/DEV-456/content-authoring-versioned-model-api">DEV-456</issue>, done). Out of scope: author-from-PDF (<issue id="fdec8752-724d-4b96-b838-12d790f10b31" href="https://linear.app/stevevine/issue/DEV-458/re-author-imported-policies-as-native-content">DEV-458</issue>), reminders (<issue id="1c292ad6-deb8-4cc7-82b4-489186c4e041" href="https://linear.app/stevevine/issue/DEV-460/notifications-and-reminders-celery-beat">DEV-460</issue>), reverse procedure-surfacing on control detail.

---
*Migrated from Linear [DEV-457](https://linear.app/stevevine/issue/DEV-457/content-authoring-ui-markdown-editor-version-history) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-463*