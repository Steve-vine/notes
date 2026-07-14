---
id: 01KXGSBD1SRS5FJ749RACBD3JZ
created: 2026-07-14T17:03:48.793894881Z
updated: 2026-07-14T17:03:48.793894881Z
type: task
title: 'Content authoring UI: Markdown editor + version history'
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 43
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