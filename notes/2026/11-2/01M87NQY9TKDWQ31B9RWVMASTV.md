---
id: 01M87NQY9TKDWQ31B9RWVMASTV
created: 2026-11-24T21:00:15.54699Z
updated: 2026-11-25T04:06:29.670954Z
type: task
title: The business impact analysis assesses the business services list, replacing its own list of functions, and Continuity reads per service
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2156
sprint: ss3ttbb
blocked_by:
- 01M87NPND8AN476F9PXXD35AMQ
- 01M87NQ09XED3JVCD11CASC93A
comments:
- id: 01M88AWGK8J73Y5K1P3JK20TJH
  author: Steve Vine
  at: 2026-11-25T03:09:45.447871Z
  text: |-
    Built and merged to main: PR #2154 (a63d542b2), migration 0921_bia_service_assessments. ADR 0178 §7 gained "as built" notes; ADR 0131 already carries "Amended by 0178 §7".

    What people see:
    - A new business impact analysis lists every active business service (Internal and Client facing, never a retired one). Each is assessed as a function was: impact over time, tolerable period (suggested, or set with a reason), RTO and RPO, busiest times, minimum service, people and sites.
    - A service added during the draft appears under "Not in this analysis yet" with Add / Add all. Any service can be left out with a reason, and put back. Submit needs every service assessed or left out.
    - What a service depends on (its Inventory links, the systems they reach, and its vendors with their routes) comes from the service, shown live while the BIA is worked and kept when approved. Changing the service afterwards (links or name) changes nothing in the approved BIA or Continuity. Approved BIAs are frozen.
    - Older approved function-based BIAs read exactly as before. A draft with functions offers, per function, to carry it across: to the matching service (pre-picked), another service, or a new service started from it (Internal by default; needs Manage the Inventory). Answers move, and its systems and data become the service's links. Anything that can't come across (e.g. a vendor) is shown in a notice.
    - Start the next one carries each service's answers forward. A service left out last time is asked about again; retired ones are dropped.
    - Continuity reads by service: the Continuity page groups by service (linked to its page), system and vendor cards name the service, and the CSV/PDF say "Service".
    - A service's page has a Recovery targets card: tolerable period, RTO, RPO, minimum service, each system it needs against IT's RTO/RPO with Continuity flags, or why the approved BIA left it out.
    - Polaris reads a BIA's services, assesses one / leaves it out / puts it back, adds services to a draft, carries a function across, and its Continuity tools read by service.

    Tested: backend integration for a new BIA listing services, add / leave out / put back, assess and approve, frozen, Continuity by service and the service / system / vendor cards, approved BIA unchanged after a service's links and name change, Start the next one, an old function BIA unchanged, carrying functions across (with the permission refusal), Polaris, and migration up → down → up with seeded function rows. Vitest covers the services card, assess, leave out, read-only approved, carry across, Recovery targets and Continuity By service. CI green.

    For Steve to decide:
    1. Continuity reads what each service depended on when the BIA was approved, not its links today. A system linked to TAS after approval gets no targets until the next BIA, as with functions before. The alternative is to read the service's links live.
    2. Carrying functions across is offered, not required. A draft can be approved with leftover functions, and Continuity then shows functions and services side by side.
    3. Any service can be left out with a reason (not only one retired during the draft).
    4. A service a BIA has assessed can't be deleted, only retired.

    Not checked yet: seen in a browser; the BIA's PDF (now with a Business services section) not opened. Staging pre-UAT next.
- id: 01M88E4D16ZW48T7YG92R8P81C
  author: Steve Vine
  at: 2026-11-25T04:06:29.670686Z
  text: |-
    Pre-UAT on staging a63d542b2: **Passed** for the new flow. **Couldn't check** the older-BIA points.
    - RAS-5 (assessor Admin A, approver Admin B) listed TAS and Payroll. TAS assessed (suggested tolerable period 1 day; RTO 4 h, RPO 1 h); Payroll left out with a reason. Submitted and approved.
    - TAS's Recovery targets card shows the targets plus AST-54 and AST-42 with their Continuity flags. Payroll's card says why it was left out.
    - The Continuity page groups by service.
    - Frozen: AST-59 linked to TAS after approval didn't appear in Continuity or RAS-5.
    - The PDF has a Business services section.
    - Couldn't check: an older approved function BIA opening unchanged, and "Carry across" (E2E Test Company has no function BIA or draft).
    - Found (low): the Submit dialog still says "Every business function has an owner…". In the BIA PDF, a left-out service's row is in the wrong columns (Type shows "Left out", and the reason sits under the tolerable period). Fix-forward task raised.
    - RAS-5 is now E2E Test Company's current BIA.
    Screenshots: ~/compass-uat/ss3ttbb/COM-2156/
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Business Services". Follows the Inventory links and the vendor blast radius.

**Steve decided (24 Nov 2026): option 2, replace the BIA's own list of business functions with the business services list.** One list everywhere. Internal functions such as Payroll become Internal services.

## What people see
- **A new BIA assesses every active business service of the company,** Internal and Client facing, instead of a list of functions typed into the BIA. Each service gets the same assessment a function had: its impact over time, maximum tolerable disruption (suggested, or set with a reason), RTO and RPO, busiest times, minimum service, and the people and sites it needs.
- **What a service depends on** comes from the service itself: its Depends on (COM-2151) and its Vendors (COM-2152). It's shown in the BIA and kept with the BIA when it's approved, so an approved BIA still reads as it was even if the service's links change later. Nothing is typed twice.
- **A service added after a BIA was started** can be added to that draft. A service retired during a draft can be left out, with a reason.
- **Approved BIAs from before this change keep their functions** and read exactly as they did. A draft BIA still in progress when this lands offers to carry each of its functions across to a matching service (by name), or to start a new service from it. Nothing is lost.
- **Continuity** reads the current approved BIA. Once that's a service-based one, every flag, card and the Continuity page read **by service**: each service, its targets, whether IT can meet them, and the systems at fault. Until then it works as today.
- **A service's page** shows its recovery targets from the current approved BIA and its Continuity flags.
- Polaris's BIA and Continuity tools work with services.

## Done when
- In E2E Test Company: start a BIA. It lists every active service. Assess TAS and approve it. TAS's page shows its targets and flags, and the Continuity page lists TAS with any systems that can't meet them.
- An older approved BIA with functions still opens and reads as before.
- A draft BIA with functions can carry them across to services.
- Changing TAS's dependencies after approval doesn't change what the approved BIA shows.

## For the build
- The BIA's rows become per-service assessments (e.g. `bia_service_assessments`: assessment_id, business_service_id, plus the fields `bia_functions` has), with a snapshot of the service's dependencies taken at approval. `bia_functions` and `bia_function_dependencies` stay for older BIAs, read-only.
- `core/business_impact.py` (create, start next, submit, approve, supersede) and `core/continuity.py` (`system_targets`, `flags`, `vendor_needs`) learn the per-service source, falling back to functions for a function-based current BIA.
- Screens: the BIA editor (`riskAssessments/bia/`), Continuity cards and page. Polaris `risk_assessments_*` BIA tools and `*_get_continuity`.
- The assessment's frozen-on-approval rule (`EDITABLE_STATUSES`) applies to the new rows too.
- ADR 0178 records option 2. ADR 0131 (business continuity) is amended or superseded for the BIA's rows.
- **On the chain**: migration + API. The largest task in the sprint; it can be split if it grows.