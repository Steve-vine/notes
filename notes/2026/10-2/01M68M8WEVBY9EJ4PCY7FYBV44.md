---
id: 01M68M8WEVBY9EJ4PCY7FYBV44
created: 2026-10-31T09:22:24.347781Z
updated: 2026-10-31T13:00:04.616413Z
type: task
title: Anything created by hand needs an owner — every form and API that makes trackable work requires one, pre-filled with the person creating it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1482
sprint: scpaa6p
blocked_by:
- 01M68M56FJGX3ZRTFG9SNDVXQX
comments:
- id: 01M68XFGWZW9NQ8503AD5ARF36
  author: Steve Vine
  at: 2026-10-31T12:03:19.071317Z
  text: |-
    Done: PR #1498 merged.

    - **Creating something with no owner makes the creator its owner.** I chose this over refusing the save so Polaris keeps working: asked to raise a gap with no owner, it now names the person it's acting for.
    - **On screen,** new gaps, treatments, incidents, BIA functions, assets and plan activities start with you as owner. The owner picker can't be emptied. DSRs, requests to disclose and DDQs already started with the creator.
    - **Editing can hand an owner to someone else, but can't clear it.** It's refused with "The owner can't be cleared — choose someone else to hand it to", on screen, through the API and through Polaris.
    - **Records made before this** with no owner can still be saved until someone picks one.
    - **Where clearing is refused:**
      - every record above, plus contract commitments, vendor review follow-ups, Q&A entries and risks;
      - for vendors, DDQs, risk assessment items and a vulnerability's owner, that's the only change.
    - **Left for you to decide:**
      - **New vendors still start unowned.** Owner approvals depend on whether a vendor has an owner, so defaulting to the creator would make them approve that vendor's requests. Tell me if you want that.
      - **Audit requests** keep "unowned means the audit lead's" (ADR 0133).
    - **Unchanged:** imported and generated records (discovery, scanners, portal reports, Trust Centre arrivals). A hand-recorded vulnerability still takes its owner from the system it's on.

    To test on staging, in E2E Test Company:
    1. On each form above, the owner should be pre-filled with you and can't be emptied.
    2. Editing should refuse to clear an owner.
    3. Ask Polaris to raise a gap without an owner; it should name you.
- id: 01M690QEM8X20DDQQXNZXKD4CZ
  author: Steve Vine
  at: 2026-10-31T13:00:04.616219Z
  text: |-
    Pre-UAT (staging, 31 Oct, as E2E Admin A, through the API): Passed.
    - A gap raised in E2E Test Company with no owner was owned by E2E Admin A, who created it.
    - Clearing its owner was refused: "The owner can't be cleared — choose someone else to hand it to".
    - Browser journeys 1–3 (after COM-1496) raise a gap, add a treatment and record an incident on forms pre-filled with the account, and all passed.

    Couldn't check: each form on screen (no browser), or asking Polaris to raise a gap (needs the AI provider).
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Sprint 100, Actions (ADR 0137 rule 3, Steve 2026-10-31: "for things that are manually created we'll need to make owner a required field where it isn't").

## What people see

- Every form that creates something that becomes an action needs an **Owner**. It's pre-filled with the person creating it, who can change it to someone else.
- Saving without an owner is refused, and the field says why.
- Editing a record can't clear its owner. To hand it on, choose someone else.
- Polaris and the API refuse it the same way, so Polaris asks who should own it.

**Sweep.** Check each one and make the owner required where it's optional:
- Gaps
- Risks
- Treatment plans
- Vulnerabilities (recorded by hand; register imports use the company's default owner)
- Incidents recorded internally (portal reports stay ownerless until triage, and go to the default owner)
- Data subject requests and requests to disclose
- DDQs
- Contract reviews and commitments
- Audit requests (imported ones go to the default owner, the lead)
- Plan activities (one-off and repeating)
- Technology, data and software assets
- Vendors
- Q&A library entries
- Risk assessments, and their follow-ups and measures
- BIA functions
- Playbook content, if it has an owner

**Existing records with no owner** aren't touched. Their actions go to the default owner (COM-1471) until someone picks one.

## Notes (technical)

- Pydantic create schemas: make `owner_id` required. The update schemas refuse `null`. This is an API change, so regenerate schema.d.ts and update MCP tool schemas (the owner argument becomes required, or defaults to the caller; say which in the tool description).
- Frontend: required owner pickers defaulting to the current user.
- Imports and generated records (discovery, scanners, portal reports, Trust Centre arrivals) are exempt. They go to the default owner.

**Chain:** on the chain (API change). Blocked by COM-1471.

**Done when:** on staging, in E2E Test Company, each form in the sweep refuses to save with the owner cleared and saves with it pre-filled. Polaris asked to raise a gap with no owner names the person it's acting for.