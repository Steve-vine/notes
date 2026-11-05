---
id: 01M6M7DW96FTXD5ZKDP4PR8S83
created: 2026-11-04T21:28:49.702552Z
updated: 2026-11-05T00:24:51.532402Z
type: task
title: 'Control search: a reference finds that control first, and only by its current reference'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1584
sprint: srkxswe
comments:
- id: 01M6MHG5SSZE6PZ11M7FY1Q1F2
  author: Steve Vine
  at: 2026-11-05T00:24:50.745538Z
  text: |-
    Done: PR #1609, merged to main as 0b276087.

    What changed: a control search written as a reference matches current refs from their start, with the exact one first and the rest in library order. A reference here is letters, a dot, then optional digits, like "INS.1" or "INS.". So "INS.1" lists INS.1, then INS.10 to INS.19, and nothing else. A plain word (e.g. "policy", "MFA") still searches refs, titles and descriptions as before. Old pre-renumbering refs are never searched, which also means Polaris no longer finds a control by one.

    This applies on Add controls, the Library's control list and its export, since they share one search.

    Tested: test_controls.py checks that "ACC." matches by prefix, that "acc.1" gives ACC.1 first then ACC.1x in number order, and that an old ref no longer finds its control. The Polaris lookup test is updated.

    CI note: the first run failed one unrelated flaky test in the Secrets sprint's key guard. It's logged as COM-1594 in the backlog, and the rerun was green.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
On an initiative's **Add controls** window, Steve filtered to Information Security Governance and typed "INS.1". He got 15 controls, among them INS.3, INS.5 and INS.6, none of which looks related.

**Why:** the search matches the text anywhere in four fields: a control's reference, its *previous* reference from before the renumbering, its title and its description. Matching on previous references brings in INS.3 (was INS.1), INS.5 (was INS.10), INS.6 (was INS.13) and INS.7 (was INS.19). INS.10–INS.19 also match because they start with "INS.1".

**Steve (2026-11-04):** the old IDs have never been used in Compass and should be removed completely. Their removal everywhere is COM-1585. This task is the search behaviour.

**Wanted behaviour:**
- Previous references are never searched.
- When the search looks like a reference, the control with exactly that reference comes first. Other controls whose reference starts with it follow, in reference order.
- Searching for words still matches titles and descriptions as it does now.

**Done when:** in E2E Test Company, filtering Add controls to Information Security Governance and searching "INS.1" lists INS.1 first, then INS.10–INS.19, and nothing else. A word search such as "policy" still finds INS.3. The Library's control list behaves the same way, because it uses the same search.

**Implementation:** `_library_query` in `app/backend/src/compass_api/api/v1/controls.py` (~L286) ORs `ilike('%q%')` over `ref`, `legacy_ref`, `title` and `description`. Drop `legacy_ref`. If `q` matches a ref pattern, match `ref` by prefix and order an exact match first. Otherwise keep title/description matching. Write an integration test. If COM-1585 lands first, the `legacy_ref` line is already gone. The `q` description in the route is OpenAPI, so run the drift check if it changes.

**On the chain?** Independent unless the `q` docs change.

Found by Steve while testing Initiatives (2026-11-04).