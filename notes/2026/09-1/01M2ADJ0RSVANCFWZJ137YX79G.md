---
id: 01M2ADJ0RSVANCFWZJ137YX79G
created: 2026-09-12T09:00:45.209261Z
updated: 2026-09-12T16:16:31.36118Z
type: task
title: 'Software assets — a third Inventory register for licensed software: record, SFT ids, support dates, licence model, owner, review cadence, portal'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 691
sprint: skdc1az
blocked_by:
- 01M2ACBBJSG6Y17AEMN3QBRY8Y
comments:
- id: 01M2AVJYFYAB3SC37APA8RBSNH
  author: Steve Vine
  at: 2026-09-12T13:05:55.71064Z
  text: |-
    Merged to main in PR #699 (2026-09-12).

    Inventory has a third tab, Software Assets, after Data Assets: licensed software with SFT-NNN refs. A record holds title, version, publisher, type (Operating system · Database engine · Infrastructure software · Business application · Security tooling), when mainstream and extended support end, owner and additional owners from the directory (an owner with no Compass account gets one at save and sees it in the portal), licence model (Per core · Per device · Per user · Subscription · Open source · Other, with Other requiring its own words), licence count, annual cost in pounds, notes, and the same lifecycle as technology assets. Whether it is in support is derived from the two dates: Mainstream support, Extended support, Out of support, or Not recorded (which counts as out). Extended support can never end before mainstream. Licences used and Deployed on are derived from installations (COM-692). The register lists and filters on type, support and status; the detail page carries record, support, licensing and cost, lifecycle with Decommission, Deployed on, notes and the audit trail; Confirm accurate works; the review cadence card gains a third default and software raises review-due actions. Owners edit their software in the portal; owner and status stay reserved. ADR 0072 §1, §3, §11 amended.

    Tests: refs across companies and duplicate titles; support at the boundaries; the date rule; the Other rule both ways; lifecycle, decommission, delete and no number reuse; an owner provisioned from the mirror who signs in, sees and edits it, and loses the grant when reassigned; the third cadence raising and Confirm accurate closing the action; the tab, modal and portal list on the frontend.

    Deploys to staging with the rest of sprint 59. Smoke: add, edit and decommission a software asset; mainstream ending last year with extended next year reads Extended support; Other insists on its text; a mirror-only owner can sign in and see it in the portal.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Requested by Steve, 2026-09-12: a **Software Assets** register — licensed software such as operating systems and database engines — alongside Technology Assets and Data Assets. This task is the register itself; installing software on technology assets and the derived licence numbers are COM-692, CSV/links/search/tile are COM-693.

**Placement**: Inventory gains a third tab, **Software Assets**, after Data Assets. Company-scoped like the other two. Refs `SFT-NNN` from a third deployment-wide sequence (ADR 0072 §3 applied again).

**The record** (`software_assets`, standard composition + `CompanyScoped`, audited):
* `asset_ref`, **Title**, **Version** (text), **Publisher** (text — a vendor link may follow; not now).
* **Type** enum `software_type`: `operating_system | database_engine | infrastructure_software | business_application | security_tooling` — labels Operating system · Database engine · Infrastructure software · Business application · Security tooling.
* **End of mainstream support**, **End of extended support** — both dates, nullable, extended ≥ mainstream when both set (422 otherwise). **Derived `support_state`**: today ≤ mainstream → *Mainstream support*; mainstream < today ≤ extended → *Extended support*; past extended, or past mainstream with no extended date → *Out of support*; neither date → *Not recorded* (counts with Out of support anywhere a number is reported — the COM-685 rule).
* **Owner** + additional owners, the COM-678 picker (directory mirror, account created at save, `asset_owner` role granted) — the same owner machinery as the other registers, so the COM-690 fix must land first.
* **Licence model** enum `licence_model`: `per_core | per_device | per_user | subscription | oss | other`, plus `licence_model_other` (text, required when Other, cleared otherwise). **Licence count** (integer ≥ 0, nullable — OSS typically blank).
* **Licences used** and **Deployed on** — derived, from COM-692; this task returns `licences_used: 0` and `deployed_on: []` so the shapes are stable.
* **Annual cost** — `Numeric(14, 2)` in **GBP** (the vendor engagement precedent; one currency until someone needs two), label "Annual cost (£)".
* **Notes** (Text, last on the form, the COM-686 size). **Status** `in_build | live | deprecated | decommissioned` + dates, guarded delete (installed anywhere → decommission). `last_verified_at` + `review_interval_months`.

**Screens**: list (ref, title, version, publisher, type, owner, support pill, licence model, licences count/used, annual cost, status, next review — all sortable; filters on type, support state, status), detail (record, support with both dates and the derived pill, licensing, cost, *Deployed on* section placeholder, notes, audit trail), Add/Edit modal using `FieldRow`, Decommission, **Confirm accurate**. Same table treatment as the other two tabs (COM-681).

**Portal**: owners see and edit their software assets in the portal Inventory tab (title/version/publisher/type/support dates/licence fields/cost/notes; owner and status reserved). **Review cadence**: a third default interval on the Inventory settings card; the review-due Beat task covers software.

**Permissions**: the existing Inventory group — nothing new. **API** `/api/v1/software-assets`. **ADR 0072** amendment: §1 gains the third register and the SFT series; §11 the third interval. `labels.ts` gains the vocabularies.

Tests: refs across companies, support derivation at the boundaries (mainstream today, extended today, past both, no dates), licence-model Other validation, owner creation from the mirror, portal edit scope, review-due for software. Regenerate `schema.d.ts`.

**Acceptance**: a Software Assets tab with add/edit/decommission; a record with mainstream support ending last year and extended support next year shows Extended support; Other licence model requires its text; an owner with no Compass account can sign in and see it in the portal.