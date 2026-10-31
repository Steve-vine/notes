---
id: 01M68M8WEVBY9EJ4PCY7FYBV44
created: 2026-10-31T09:22:24.347781Z
updated: 2026-10-31T09:22:24.347781Z
type: task
title: Anything created by hand needs an owner — every form and API that makes trackable work requires one, pre-filled with the person creating it
label: improvement
task_status: todo
assignee: steve
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1482
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