---
id: 01M880Y72A6RYAS66KRWT6TG1B
created: 2026-11-25T00:15:55.466635Z
updated: 2026-11-25T04:06:31.622066Z
type: task
title: Polaris can set an engagement's business services when adding or editing it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2159
sprint: ss3ttbb
blocked_by:
- 01M87NQ09XED3JVCD11CASC93A
comments:
- id: 01M88AWNF9HYCMKBC9R1KHS718
  author: Steve Vine
  at: 2026-11-25T03:09:50.441355Z
  text: |-
    Built and merged to main: PR #2155 (121acc569). Polaris only; no migration or API change.

    What people see:
    - Polaris can add an engagement with its business services named in words, by name or reference ("TAS", "SVC-4"), ignoring case.
    - On an existing engagement it can replace them, or clear them with an empty list. Not mentioning them leaves them as they are.
    - A name that isn't one of the company's active services is refused, listing the active services. A retired service already on the engagement can be kept, not newly added.
    - Choosing services needs View inventory, as on screen. Without it Polaris saves the rest of the change and says the services were left alone, or refuses if they were the only change.
    - The engagement Polaris reports back names its services. The vendor's blast radius shows each one through the engagement, and the routes go when cleared.

    Tested: integration test adding an engagement with three services (all in the blast radius), an unknown name refused, a retired one kept but refused elsewhere, clearing (blast radius empty), and the no-permission note and refusal. Area and unit suites pass. CI green.

    For Steve to decide: without the inventory right, Polaris saves the other changes rather than refusing the whole add or edit.

    Not checked: a real Polaris conversation.
- id: 01M88E4EY61CWRHH89V3P3MFPC
  author: Steve Vine
  at: 2026-11-25T04:06:31.621876Z
  text: 'Pre-UAT on staging a63d542b2: **Couldn''t check.** It needs a Polaris conversation, and Polaris writes through Steve''s own account. Steve: ask Polaris to add an engagement on E2E Test Vendor with business services "TAS, Payroll". The vendor''s Blast radius should show both through that engagement, and clearing them should remove those routes.'
assignee: steve
label:
- follow_up
priority: low
task_status: review
---
Sprint "Business Services". Follow-up from COM-2152 (24/25 Nov 2026): on screen, adding or editing a vendor engagement can pick the business services it helps deliver, and Polaris now reads them, but Polaris's `vendors_add_engagement` and `vendors_update_engagement` can't set them.

## What people see
- Polaris can add an engagement with its business services named in words ("TAS, LiveChat"), and change or clear them on an existing engagement.
- A name that doesn't match one of the company's active services is refused, with the list of services. A retired service already on the engagement can be kept.
- As on screen, this needs the right to view the inventory. Without it, Polaris says so and leaves the services alone.

## Done when
- Polaris adds an engagement with two services, and the vendor's Blast radius shows both through that engagement.
- Polaris clears them, and the engagement routes go.

Independent: Polaris tools only (`assistant/tools/vendors_engagements.py`, reusing the engagement API's `business_service_ids` from COM-2152). No migration or API change.