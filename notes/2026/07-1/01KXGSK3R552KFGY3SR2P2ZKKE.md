---
id: 01KXGSK3R552KFGY3SR2P2ZKKE
created: 2026-07-14T17:08:01.413230718Z
updated: 2026-07-14T17:08:13.118641847Z
type: task
title: 'Search UI: top-bar box + results'
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 51
sprint: sd2bf6k
---
Enable the top-bar search box (disabled since the M1 shell, ADR 0017) + a results page, against the merged <issue id="bdd34e9e-9133-4bdd-bc14-a703b35c783c" href="https://linear.app/stevevine/issue/DEV-467/search-api-cross-entity-search">DEV-467</issue> API. Frontend-only. Closes Milestone 6.

**Agreed approach (planned 2026-06-18).**

- [ ] Regenerate `schema.d.ts` (`/api/v1/search`); `client.ts` `SearchResult` type; `src/search/hooks.ts` → `useSearch(q, companyId)` (`GET /search?q=&company=`, enabled only when `q.trim()` non-empty).
- [ ] **Top-bar** (`AppLayout`): drop `disabled` on the search `TextInput`; controlled; Enter/submit → `/search?q=<encoded>` (wrap in a form); optional `/` focus shortcut. Per-company results use the globally-selected company.
- [ ] `SearchPage` (`/search`): reads `q` from the query string + `useCompany().current?.id`; results **grouped by type** in a fixed order (Controls, Content, Decisions, Risks, Frameworks, Requirements, Domains, Gaps), each row label + sublabel + snippet linking to `result.target`; query echoed + total; loading / empty / no-results states; a pre-filled search box on the page to refine. Route added to `App.tsx`.
- [ ] Tests (fetch-stub): top-bar Enter navigates to `/search?q=…`; SearchPage renders grouped results with working deep links + empty-state; search box enabled.

Refs: ADR 0017, 0021. Depends on: Search API (<issue id="bdd34e9e-9133-4bdd-bc14-a703b35c783c" href="https://linear.app/stevevine/issue/DEV-467/search-api-cross-entity-search">DEV-467</issue>, done).

---
*Migrated from Linear [DEV-468](https://linear.app/stevevine/issue/DEV-468/search-ui-top-bar-box-results) · created 2026-06-17 · completed 2026-06-18*