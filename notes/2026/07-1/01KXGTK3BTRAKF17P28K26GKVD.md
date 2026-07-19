---
id: 01KXGTK3BTRAKF17P28K26GKVD
created: 2026-07-14T17:25:29.59424616Z
updated: 2026-07-14T17:25:36.866286155Z
type: task
title: Frontend — framework & requirement editing + description enrichment (inline + bulk)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 89
sprint: s7sxqts
assignee: steve
label:
- brief
priority: medium
task_status: done
---
Frontend for **M19 — Frameworks**, consuming the editable/enrichable framework API from <issue id="8180697a-da35-4607-bd3a-0f20f3d74322" href="https://linear.app/stevevine/issue/DEV-655/backend-editable-and-enrichable-frameworks-crud-disable-descriptions">DEV-655</issue>. Make the Frameworks section curatable by **library writers** (analyst/admin) and — the milestone's headline — let users **fill in the missing requirement descriptions**. The API stays the enforcement boundary; the UI mirrors `canWriteLibrary` affordances (ADR 0026). Design decided in **ADR 0028**. **Depends on the backend brief.**

### Why

Requirements today show a `ref` + `title` but no description (the standards' text is copyrighted, so seeds shipped names only — ADR 0028). This milestone surfaces an editable `description` and a bulk-import path so an org can load the clause text it's licensed for. Existing pages: `pages/FrameworksPage.tsx` (list) and `pages/FrameworkDetailPage.tsx` (requirements + mapped controls); `frameworks/hooks.ts`.

### Scope (ADR 0028)

- [ ] Regenerate `schema.d.ts` from the updated OpenAPI; add the new mutations to `frameworks/hooks.ts` (create/update/disable/delete framework + requirement, bulk description import) with toasts via the central `MutationCache` (`meta.successMessage`) and cache invalidation.
- [ ] **Frameworks list** (`FrameworksPage`): an **Add framework** action (name, version, slug, description) for `canWriteLibrary`; show disabled frameworks (muted, with a toggle to `include_disabled`) only to writers; per-row edit/disable/delete. Keep read-only for everyone else.
- [ ] **Framework detail** (`FrameworkDetailPage`): edit framework fields; **add/edit/disable/delete requirements**; each requirement shows its **description** with **inline edit** (writers) and read display (everyone). Disabled requirements muted + writer-only `include_disabled` toggle. Preserve the existing mapped-controls / crosswalk display.
- [ ] **Bulk description import**: an "Import descriptions" action on the framework detail — upload a `ref,description` (or `ref,title,description`) CSV, POST to the import endpoint, show the applied / skipped / unmatched summary. This is the practical answer to "how do I get ~150 descriptions in" — make it the prominent path.
- [ ] **Guarded-delete UX**: surface the backend **409 "in use — disable instead"** as a clear message and steer the user to disable (mirror the M18 control/domain delete UX, <issue id="220efae1-6e5a-4bf8-9a0c-92497299951b" href="https://linear.app/stevevine/issue/DEV-629/frontend-domain-and-control-editing-control-detail-page">DEV-629</issue>/637).
- [ ] **Gate everything on** `canWriteLibrary`: viewers/assessors see read-only frameworks (no add/edit/disable/delete/import affordances); analysts/admins get the full set.
- [ ] Tests: list/detail render; writer sees edit/add/import affordances, non-writer doesn't; inline description edit; bulk-import summary; disabled toggle; 409→disable messaging.

Refs: ADR 0028 (this milestone), 0027 / <issue id="220efae1-6e5a-4bf8-9a0c-92497299951b" href="https://linear.app/stevevine/issue/DEV-629/frontend-domain-and-control-editing-control-detail-page">DEV-629</issue> (the M18 frontend pattern this mirrors), 0026 (library write gate / section visibility), 0017 (Frameworks IA). Depends on: <issue id="8180697a-da35-4607-bd3a-0f20f3d74322" href="https://linear.app/stevevine/issue/DEV-655/backend-editable-and-enrichable-frameworks-crud-disable-descriptions">DEV-655</issue> (backend).

---
*Migrated from Linear [DEV-656](https://linear.app/stevevine/issue/DEV-656/frontend-framework-and-requirement-editing-description-enrichment) · created 2026-06-26 · completed 2026-06-26*  
*Related to (Linear): DEV-629, DEV-655*