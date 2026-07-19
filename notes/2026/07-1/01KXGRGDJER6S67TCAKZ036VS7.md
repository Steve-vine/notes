---
id: 01KXGRGDJER6S67TCAKZ036VS7
created: 2026-07-14T16:49:04.590661959Z
updated: 2026-07-19T21:30:28.245948487Z
type: task
title: Domains & controls browse UI
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 13
sprint: sz3kacg
comments:
- id: 01KXGRGRX9CNRN5XQQ53PWSY3Y
  author: Steve Vine
  at: 2026-07-14T16:49:16.200964246Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 19:28 UTC]
    **Built — in review.** PR: https://github.com/Steve-vine/compass/pull/12 · branch `steve/dev-399-domains-controls-browse-ui`. Frontend-only (no backend/chart changes).

    ### What was built
    - **DomainsPage** (`/domains`) — list + control counts + placeholder status/maturity.
    - **DomainDetailPage** (`/domains/:slug`) — header, a Policy card linking to the Content viewer (`/content/<slug>`), and the domain's controls table.
    - **ControlsPage** (`/controls`) — flat list with a client-side ref/title filter.
    - **ControlDetailPage** (`/controls/:ref`) — canonical control text + domain link; labelled placeholders for the assessment panel + linked procedures.
    - `StatusCells` shared helper; routes wired in `App.tsx`.

    ### Decisions
    - Status/maturity rendered as placeholder ("Not assessed") now — real data with the Assessment UI brief.
    - Domain's policy links to the existing Content viewer (DRY), not re-embedded.

    ### Checks
    `npm run lint` / `typecheck` / `test` (7 pass) / `build` — all green. No CI surprises expected (frontend only).
- id: 01KXGRH0K98GH3K6J8PZ3NGNMG
  author: Steve Vine
  at: 2026-07-14T16:49:24.073556558Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 19:40 UTC]
    **Rolled and verified — done.** Merge `aa4f0d2`; Release built (multi-arch), then `helm upgrade … --set image.tag=aa4f0d2` (revision 6, deployed).

    Live verification:
    - Both deployments on `…:aa4f0d2`; `compass-frontend` rolled out cleanly (1/1 Ready — readiness probe serves the SPA).
    - Backing data intact: 35 domains / 269 controls; the Content/domains/controls read APIs the pages consume were confirmed serving in the prior rolls.

    Domains, Controls and Content are now all browsable at https://compass.citops.net: Domains list → domain (policy card + controls) → control detail; flat Controls index with the filter. Image-only roll (no migration/hook), as expected.
assignee: steve
task_status: done
priority: medium
---
Domain-led browse of the playbook per ADR 0017. Frontend-only — the read APIs (domains, controls, content) all exist (<issue id="6f8b0cb1-3b79-498a-8347-533231cce7bc" href="https://linear.app/stevevine/issue/DEV-397/domain-and-core-control-models-import-controlscsv">DEV-397</issue>/398). Supersedes <issue id="21f35d48-aaf3-467b-a8d8-dfca0f5bb77c" href="https://linear.app/stevevine/issue/DEV-421/domains-and-controls-ui-browse-the-control-library">DEV-421</issue> (Duplicate).

**Agreed approach (plan-mode, 2026-06-14):**

* **DomainsPage** (`/domains`): list with `control_count` + placeholder Status/Maturity columns.
* **DomainDetailPage** (`/domains/:slug`): header (name/description); a **Policy card** linking to the existing Content viewer (`/content/<slug>`, <issue id="81818b78-136c-4940-a590-2176d5c701de" href="https://linear.app/stevevine/issue/DEV-398/read-only-content-import-policies">DEV-398</issue>); a controls table (Ref → control detail, Title, placeholder Status/Maturity).
* **ControlsPage** (`/controls`): flat list with a client-side filter over ref/title; placeholder Status/Maturity.
* **ControlDetailPage** (`/controls/:ref`): canonical control text (ref/title/description/status), domain name+link (resolved from the cached domains list); labelled placeholders for the assessment panel + linked procedures.
* `StatusCells` shared helper for the placeholder columns; routes wired in `App.tsx` (filter `/domains` + `/controls` out of the placeholder loop, as done for `/content`).
* Vitest for Domains/Controls/ControlDetail.

**Resolved forks:** (1) status/maturity rendered as placeholder ("Not assessed") now — real data with the Assessment UI brief; (2) domain's policy links to the Content viewer (not re-embedded).

No backend/chart changes. Refs: ADR 0017.

---
*Migrated from Linear [DEV-399](https://linear.app/stevevine/issue/DEV-399/domains-and-controls-browse-ui) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-420*