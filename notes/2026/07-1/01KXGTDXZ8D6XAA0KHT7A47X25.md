---
id: 01KXGTDXZ8D6XAA0KHT7A47X25
created: 2026-07-14T17:22:40.232812576Z
updated: 2026-07-14T17:22:45.831169812Z
type: task
title: Frontend — domain & control editing + control detail page
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 84
sprint: s114vjm
---
Frontend for **M18 — Domains & Controls Editing**, consuming the new mutations from the backend brief. **Depends on the backend brief.** Design in **ADR 0027**. All write affordances gated on `usePermissions().canWriteLibrary` (analyst/admin); the API is the enforcement boundary, the UI mirrors it for UX.

### Checklist

- [ ] **Domains list** (`DomainsPage`): "Add domain" button (canWriteLibrary) → create modal (name, slug, description). Surface uniqueness 409 on the slug field.
- [ ] **Domain detail** (`DomainDetailPage`) becomes editable: edit name/slug/description inline (DecisionDetailPage pattern), keep the policy link, and show the controls list below with per-control add/edit/disable/delete plus an "Add control to this domain" action. Disable/enable toggle + status badge (UsersSection pattern). Disabled domain clearly badged.
- [ ] **Controls list** (`ControlsPage`): "Add control" button → create modal (domain select, ref, title, description). Edit/disable/delete row actions. A **"show disabled"** toggle (uses `include_disabled`) for library writers; disabled controls badged.
- [ ] **Control detail page restructure** (`ControlDetailPage` — the key change): lead with control **library metadata** (ref, title, description, domain link, status badge, mapped framework requirements, linked content/decisions/risks), editable inline (canWriteLibrary). Demote the per-company `AssessmentPanel` to a clearly labelled **"Assess for {company}"** section below, shown only when a company is selected and `canWriteCompany`. Clicking a control anywhere lands on this library view, not straight into assessment.
- [ ] **Hooks**: `useCreateDomain/useUpdateDomain/useDeleteDomain`, `useCreateControl/useUpdateControl/useDeleteControl` (content/decisions hooks pattern; invalidate `['domains']`/`['controls']` + detail keys; toast via queryClient `meta`).
- [ ] **Error UX**: delete 409 shown as a friendly "disable instead" message; create/edit uniqueness 409 shown on the field.
- [ ] Regenerate OpenAPI types (`api/schema.d.ts`) from the backend.

Refs: ADR 0027, 0017 (the control detail page is the integration point), 0026 (canWriteLibrary), 0022 (UI patterns).

---
*Migrated from Linear [DEV-629](https://linear.app/stevevine/issue/DEV-629/frontend-domain-and-control-editing-control-detail-page) · created 2026-06-25 · completed 2026-06-25*  
*Related to (Linear): DEV-656, DEV-637, DEV-628*