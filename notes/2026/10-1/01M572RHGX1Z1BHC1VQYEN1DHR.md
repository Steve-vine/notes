---
id: 01M572RHGX1Z1BHC1VQYEN1DHR
created: 2026-10-18T08:41:26.813025Z
updated: 2026-10-18T12:11:24.432664Z
type: task
title: A personal data breach is assessed on the incident — what data and whose, how many people, the UK GDPR risk to them and the HIPAA four-factor assessment — and the conclusion is recorded with who reached it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1070
sprint: serbigk
blocked_by:
- 01M572R2V4X8RKBMXYFRQJ4E4B
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 76, Incidents - Register (ADR in COM-1063). Builds on COM-1069 (data assets on the incident). It answers HIPAA 164.402 and 164.414(b), UK GDPR Art 33(5), IMA.17 and PDH.16.

## What people see

**Personal data breach** section, shown when a category brings it (Privacy):

- **What data:**
  - the data assets involved, from the Involved card;
  - their **data types** pre-filled from Inventory, with a flag on any that are personal, special-category or health data;
  - handlers can add a type the asset doesn't list.
- **Whose:** customers, employees, patients, children, other.
- **How many people**: an **estimate** at first, then **validated**. Both are kept, with when each was set.
- **What happened to it**: disclosed, accessed, altered, lost, destroyed, unavailable. Several can apply.
- **UK GDPR risk to people**: Unlikely to result in a risk / A risk / A high risk, with the reasoning. This decides which UK GDPR obligations are required (notifications task).
- **HIPAA**, shown when the data includes health data:
  - **"Protected health information involved?"**;
  - the **four-factor risk assessment**, a short answer to each:
    1. the nature and extent of the information;
    2. who used or received it;
    3. whether it was actually acquired or viewed;
    4. how far the risk was mitigated;
  - a conclusion of **Low probability of compromise** (no notification) or **Breach: notify**.
- **Assessed by / on.** A change to the conclusion is allowed while the incident is open, needs a reason, and keeps the earlier one visible.

## Rules

- **A Privacy incident can't close without a recorded conclusion** (closure task). HIPAA puts the burden of proof on the company, so "no notification" must be argued, not assumed.
- Restricted incidents (later task) hide this section like everything else.

## Notes (technical)

- Data-type sensitivity comes from `DataTypeControlledCategory` (pii, special_category_pii, health_data).

**Done when:** the section records data, people, risk and the HIPAA assessment; conclusions keep their history; health data brings up the HIPAA part.