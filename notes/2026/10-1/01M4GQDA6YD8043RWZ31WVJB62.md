---
id: 01M4GQDA6YD8043RWZ31WVJB62
created: 2026-10-09T16:19:47.038285Z
updated: 2026-10-10T15:10:49.844403Z
type: task
title: What Compass reads is checked — an unencrypted, public or unbacked-up resource, or one that has vanished, is a finding on its technology asset and an action for the owner
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 888
sprint: svsqcj9
blocked_by:
- 01M4GQBSJMKTPGQGYTCVW22ENQ
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Part of sprint 67, Inventory expansion (ADR in COM-881). Risks and decisions stay on the technology asset; what rolls up from its resources is findings. This task is that roll-up, with a small fixed set of checks.

## What people see

- **A technology asset's page gains "Findings".** Each one names the resource, says what is wrong in a sentence, and when it was first seen. For example:
  - "Database kora-prod is not encrypted at rest."
  - "Bucket kora-exports does not block public access."
  - "Database kora-prod is reachable from the internet."
  - "Backups are switched off on kora-prod."
  - "Every resource behind this asset has gone from AWS, but the asset is still Live."
  - "This asset is Decommissioned, but kora-prod still exists."
- **The asset's highest data classification is shown beside its findings**, so "not encrypted" on something holding Confidential data reads as what it is.
- **A finding closes by itself** when the next read shows the fact has changed.
- **The owner can do two things with an open finding:**
  - **Raise a risk.** The risk form opens filled in, linked to the technology asset and naming the resource.
  - **Accept it**, with a reason, optionally linking a decision. It stays listed as accepted, with who and why.
- **Open findings are an action for the asset's owner**, in the same place overdue reviews appear.
- **The Technology register can be filtered to assets with open findings**, and the Inventory summary counts them.
- **Only resources beneath a technology asset are checked.** Anything awaiting a decision or discarded raises nothing.

The set of checks is fixed in this sprint. It is not configurable and is not yet tied to control assessments; both are for later.

## Notes (technical)

- **Checks are declared beside the readers**, each `check(facts) -> finding | None` with a stable key such as `aws.rds.not_encrypted`, a sentence template and the kinds it applies to. Adding a check is one entry.
- **The two lifecycle checks** read the asset and its attachments, not one resource's facts: every attached resource has `gone_at` while the asset is `live`; an attached resource has no `gone_at` while the asset is `decommissioned`. An asset with no discovered resources at all raises neither.
- **`resource_findings`**: `container_id`, `discovered_resource_id` (null for the asset-level check), `key`, `opened_at`, `closed_at`, `accepted_at` / `accepted_by` / `accepted_reason`, an optional decision link, an optional risk link. One open row per (asset, resource, key).
- **Evaluated at the end of each read**, after rules have filed, and again when a resource is attached or detached. Idempotent: an unchanged fact changes nothing; a cleared fact sets `closed_at`; a recurrence opens a new row and does not reopen an accepted one silently, it opens fresh.
- **A shared component's finding** appears on every asset it serves: one row per asset, so each owner accepts or raises a risk for their own asset.
- **The owner action** is a declared action source in `core/actions/inventory.py` (ADR 0055), routed the way the overdue-review action is. Accepted and closed findings are not actions. Do not write a notify().
- **Raise a risk** goes through the existing risk create and `InventoryRiskLink`; the finding keeps the link so the page can show "risk R-14 raised".
- **Sentence templates** take the resource name through the normal escaping; a name or tag is untrusted text.
- **Reads.** Findings on the container detail read and the portal read; the open count on the register list and in `api/v1/inventory_summary.py`. Accept and raise-a-risk from the Portal are new portal write routes, so add them to the exact-set allowlist test in `tests/test_portal.py`.
- **API.** Regenerate `schema.d.ts` and run the drift script.
- **Tests.** Integration: each check opens and closes on a fact change, accepted stays accepted, the two lifecycle checks, a shared component yields one finding per asset, nothing for unattached resources, the action appears for the owner and goes when accepted. Vitest for the section and both dialogs.

**Done when:** on staging, a technology asset backed by an unencrypted or public test resource shows the finding and its owner has the action; accepting it with a reason clears the action; fixing the resource in AWS closes the finding on the next read.