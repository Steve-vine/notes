---
id: 01M6M7DW96FTXD5ZKDP4PR8S83
created: 2026-11-04T21:28:49.702552Z
updated: 2026-11-04T21:28:52.357342Z
type: task
title: 'Control search: a reference finds that control, not ones it used to be'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1584
sprint: srkxswe
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
On an initiative's **Add controls** window, Steve filtered to Information Security Governance and typed "INS.1". He got 15 controls, among them:
- INS.3 (Information Security policy)
- INS.5 (legal, regulatory and contractual requirements)
- INS.6 (management review)

None of those three looks related to INS.1.

**Why:** the search isn't fuzzy. It matches the text anywhere in four fields: a control's reference, its *previous* reference from before the renumbering, its title and its description. Matching on previous references brings in INS.3 (was INS.1), INS.5 (was INS.10), INS.6 (was INS.13) and INS.7 (was INS.19). INS.10–INS.19 also match because they start with "INS.1".

**Wanted behaviour:**
- When the search looks like a reference, the control with exactly that reference comes first. Other controls whose reference starts with it follow, in reference order.
- A previous reference finds a control only on an exact match. The row then shows "was INS.1" so it's clear why it's there.
- Searching for words still matches titles and descriptions as it does now.

*Assumption (decided, not asked): previous references stay searchable, by exact match only, because people still quote the old numbers.*

**Done when:** in E2E Test Company, filtering Add controls to Information Security Governance and searching "INS.1" lists INS.1 first, then INS.10–INS.19. INS.3 appears labelled "was INS.1", and INS.5, INS.6 and INS.7 don't appear. A word search such as "policy" still finds INS.3. The Library's control list behaves the same way, because it uses the same search.

**Implementation:** `_library_query` in `app/backend/src/compass_api/api/v1/controls.py` (~L286) ORs `ilike('%q%')` over `ref`, `legacy_ref`, `title` and `description`. If `q` matches a ref pattern, match `ref` by prefix and `legacy_ref` exactly, ordering an exact `ref` match first. Otherwise keep the current behaviour. Check whether `CoreControlListOut.legacy_ref` is already shown in `AddControlsModal.tsx`, and add the "was …" hint if not. Write an integration test with the INS renumbering as the fixture. The `q` description in the route is OpenAPI, so run the drift check if it changes.

**On the chain?** Probably independent: it changes behaviour, not the API shape. It joins the chain if the `q` docs change.

Found by Steve while testing Initiatives (2026-11-04).