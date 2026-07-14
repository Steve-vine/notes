---
id: 01KXGSFCN60TNJPSZY1SP9N8KK
created: 2026-07-14T17:05:59.462454405Z
updated: 2026-07-14T17:06:09.667875803Z
type: task
title: Decision records UI + linked-decision surfacing
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 47
sprint: sd5fyv6
---
The Decisions section + authoring (frontend), against the merged <issue id="0c85675f-5f5a-42e4-8a4f-d414c5bfcc7c" href="https://linear.app/stevevine/issue/DEV-459/decision-records-in-app">DEV-459</issue> API. Mirrors the content/risk hook + page conventions. **Linked-decision surfacing is split to** <issue id="e15ab352-ac30-4303-af15-0521bebbcbfb" href="https://linear.app/stevevine/issue/DEV-466/linked-decision-surfacing-on-controlriskcontent">DEV-466</issue>**.**

**Agreed approach (planned 2026-06-17).**

- [ ] **API layer**: `client.ts` types (`Decision`/`DecisionOut`, `DecisionDetail`, `DecisionCreate`, `DecisionUpdate`, `DecisionStatus`); `src/decisions/hooks.ts` — `useDecisions(status?)`, `useDecision(number)`, `useCreateDecision`, `useUpdateDecision(number)` with `errorMessage` + cache invalidation.
- [ ] **Nav + routes**: new **Decisions** sidebar item (`IconGavel`) in `nav.ts`; `/decisions` + `/decisions/:number` in `App.tsx`.
- [ ] **DecisionsPage** (`/decisions`): table (№, title, status, decided-on) + status filter; **New decision** (admin/editor) create modal (title, status, decided-on, optional body, optional `supersedes`) → navigate to the new number. Viewers: read-only.
- [ ] **DecisionDetailPage** (`/decisions/:number`): render `body_markdown`; status + decided-on; **supersession links** derived from the list (id→number) — "Superseded by ADR N" / "Supersedes ADR M". Admin/editor: edit mode (title/status/decided-on/body via Textarea + preview, explicit **Save** via PUT) + **"Supersede this"** (create modal preset with `supersedes`).
- [ ] **Tests**: `DecisionsPage.test` (list, status filter, role-gated create); `DecisionDetailPage.test` (renders body/status, supersession link, viewer no edit, editor edits + supersede posts `supersedes`).

Address by `number` (shown as "ADR N"); edit is explicit Save (decisions aren't versioned); supersede = create a new superseding decision. Reads open; authoring gated admin/editor (server-enforced).

Refs: ADR 0013, 0001, 0017. Depends on: <issue id="0c85675f-5f5a-42e4-8a4f-d414c5bfcc7c" href="https://linear.app/stevevine/issue/DEV-459/decision-records-in-app">DEV-459</issue> (done). Out of scope → <issue id="e15ab352-ac30-4303-af15-0521bebbcbfb" href="https://linear.app/stevevine/issue/DEV-466/linked-decision-surfacing-on-controlriskcontent">DEV-466</issue> (linked-decision surfacing + backend target filter).

---
*Migrated from Linear [DEV-463](https://linear.app/stevevine/issue/DEV-463/decision-records-ui-linked-decision-surfacing) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-457*