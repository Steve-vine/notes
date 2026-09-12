---
id: 01M2ADJV8HJZ5FK8G15BRXNFWM
created: 2026-09-12T09:01:12.337196Z
updated: 2026-09-12T16:16:33.287229Z
type: task
title: Software assets join the rest of Compass — CSV import, links to risks/decisions/vendors/controls, global search, dashboard tile
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 693
sprint: skdc1az
blocked_by:
- 01M2ADJH55DKJ3SFG2DKFFBDNE
comments:
- id: 01M2AWVDJRBQMFZE3SG8RZM88N
  author: Steve Vine
  at: 2026-09-12T13:28:01.880608Z
  text: |-
    Merged to main in PR #701 (2026-09-12).

    The software register joins the rest of Compass. A CSV template and create-only, all-or-nothing import for software assets (owner by email or UPN, enum columns by label or identifier, dates ISO, pounds with or without the sign; row-level errors; preview; csv_import in the audit trail), with the Import CSV button on the software tab. Risks, controls and decisions link to a software asset and show from both ends; a citation guards the delete. The publisher may also name a vendor — the detail links to it with its risk tier, the modal offers a vendor picker to those who can read vendors, and the vendor's Assets section lists what it publishes beside what it supplies and receives. Software assets are typed results in global search (ref, title, version, publisher) and the search page's type filter offers them. The Inventory tile counts software out of support and over-allocated licences, each linking to the tab filtered accordingly, and its count line names the third register. ADR 0072 §12, §13, §16 and the IA brief's Modules entry amended. Reports: nothing new — a licence position report is now a query over the register for the report catalogue.

    Tests: a 20-row import previews, imports and is audited as csv_import, and a bad file is rejected with one error per row naming the column; risk and decision links from both ends and the delete guard; the publisher vendor round trip, cross-company refusal and the vendor's published list; search by title, publisher and ref; tile counts; tile badges and the vendor link on the frontend.

    Deploys to staging with the rest of sprint 59. Smoke: a 20-row software CSV imports or is rejected with row errors; a risk linked to a software asset shows on both; search finds "PostgreSQL"; the tile's numbers match the register.
assignee: steve
label:
- feature
priority: medium
task_status: done
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