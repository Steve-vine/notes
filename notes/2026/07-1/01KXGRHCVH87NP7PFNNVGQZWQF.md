---
id: 01KXGRHCVH87NP7PFNNVGQZWQF
created: 2026-07-14T16:49:36.625871855Z
updated: 2026-07-14T16:49:56.778968856Z
type: task
title: Controls flat index (searchable)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 14
sprint: sz3kacg
comments:
- id: 01KXGRHP95J0YAP0F7K5R8G0AW
  author: Steve Vine
  at: 2026-07-14T16:49:46.277443168Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 19:57 UTC]
    **Built — in review.** PR: https://github.com/Steve-vine/compass/pull/13 · branch `steve/dev-400-controls-flat-index-searchable`.

    ### What was built
    - **Backend** `GET /controls?q=` — case-insensitive substring (ILIKE, LIKE wildcards escaped) across ref/title/description, combined with the existing `?domain=`.
    - **Frontend** `ControlsPage` — server-driven search (debounced) + a domain `Select` dropdown; `keepPreviousData` so rows don't flash on each keystroke. Regenerated `schema.d.ts`.

    ### Decisions
    - Server search API + upgraded UI (not API-only); substring ILIKE (not full-text).

    ### Checks
    Backend ruff/mypy/pytest (27 default, 28 integration — new cases: ref match, text match, q+domain, no-match, `%` escaped). Frontend lint/typecheck/test/build green.

    Image-only roll (no migration/hook) once merged.
- id: 01KXGRJ0HANAES7EQPBTGQPQZ0
  author: Steve Vine
  at: 2026-07-14T16:49:56.778693525Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 20:06 UTC]
    **Rolled and verified — done.** Merge `f05fe53`; Release built (multi-arch), `helm upgrade … --set image.tag=f05fe53` (revision 7, both deployments rolled out cleanly).

    Live API checks (authenticated, temp token cleaned up):
    - `q=ACC.4` → `['ACC.4']` (partial-ref match)
    - `q=password` → 4 controls (text match)
    - `q=ACC.4&domain=access-control` → `['ACC.4']` (combine)
    - `q=%` → `[]` (LIKE wildcard escaped, treated literally)
    - no `q` → 269 (all)

    The Controls page at https://compass.citops.net now has server-driven search + a domain dropdown.
assignee: steve
label:
- brief
priority: medium
task_status: done
---
A flat, searchable Core control library complementing the domain-led browse (ADR 0017). The index UI shipped in <issue id="eba6e737-9bfc-4229-b4aa-8550996f7d30" href="https://linear.app/stevevine/issue/DEV-399/domains-and-controls-browse-ui">DEV-399</issue> (client-side filter) and the controls API in <issue id="6f8b0cb1-3b79-498a-8347-533231cce7bc" href="https://linear.app/stevevine/issue/DEV-397/domain-and-core-control-models-import-controlscsv">DEV-397</issue> (?domain); this makes **search a first-class API capability** and drives the UI from it.

**Agreed approach (plan-mode, 2026-06-14):**

* **Backend** `api/v1/controls.py`: add `?q=` — case-insensitive substring (ILIKE, wildcards escaped) across `ref`/`title`/`description`, combined with the existing `?domain=`; ordered by ref.
* **Frontend** `ControlsPage`: switch from the client-side filter to **server-driven search** (debounced `?q=`) + a **domain dropdown** (`Select` from `/domains`). Regenerate `schema.d.ts` for the new param.
* **Tests:** backend (`?q=ACC`, description match, q+domain combine, no-match, `%` escaped); frontend (server-driven refetch narrows rows).

**Resolved forks:** (1) server search API + upgrade UI (not API-only); (2) substring ILIKE (not full-text).

No chart/migration changes. Refs: ADR 0017.

---
*Migrated from Linear [DEV-400](https://linear.app/stevevine/issue/DEV-400/controls-flat-index-searchable) · created 2026-06-13 · completed 2026-06-14*