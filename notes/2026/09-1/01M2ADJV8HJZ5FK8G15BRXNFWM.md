---
id: 01M2ADJV8HJZ5FK8G15BRXNFWM
created: 2026-09-12T09:01:12.337196Z
updated: 2026-09-12T09:01:31.088985Z
type: task
title: Software assets join the rest of Compass — CSV import, links to risks/decisions/vendors/controls, global search, dashboard tile
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 693
sprint: skdc1az
blocked_by:
- 01M2ADJH55DKJ3SFG2DKFFBDNE
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
The finishing work for the Software Assets register, on the same pattern the other two registers had (COM-667, COM-668, COM-673).

* **CSV**: template download and create-only, all-or-nothing import for software assets (`title, version, publisher, type, end_of_mainstream_support, end_of_extended_support, owner, licence_model, licence_model_other, licence_count, annual_cost, review_interval_months, notes`); owner resolves by email/UPN through the mirror; enum columns accept labels or identifiers; dates ISO. Row-level errors, preview step, `source: csv_import` in the audit trail.
* **Links**: risks, decisions and controls on a software asset (the polymorphic link shapes gain the type), shown from both ends; **Publisher** gains an optional vendor link (the vendor's Assets section lists it) while the text stays for publishers that are not vendors.
* **Global search**: software assets as typed results (ref, title, version, publisher).
* **Dashboard tile**: the Inventory tile adds software **out of support** (extended date passed, or not recorded) and **over-allocated licences**, each linking to the tab filtered accordingly.
* **Reports**: nothing new — but note for the report catalogue (ADR 0062) that a licence position report (title, count, used, cost, over-allocation) is now a query.
* Activity page entity names; `brief/information-architecture.md` Modules list; ADR 0072 §12/§13/§16 amendments.

Tests: import happy path and each row error, links from both ends, search hit by publisher, tile counts. Regenerate `schema.d.ts`.

**Acceptance**: a 20-row software CSV imports or is rejected with row errors; a risk linked to a software asset shows on both; search finds "PostgreSQL"; the tile's out-of-support and over-allocated numbers match the register.