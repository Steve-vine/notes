---
id: 01M4GQDA6YD8043RWZ31WVJB62
created: 2026-10-09T16:19:47.038285Z
updated: 2026-10-10T15:51:58.58585Z
type: task
title: What Compass reads is checked — an unencrypted, public or unbacked-up resource, or one that has vanished, is a finding on its technology asset and an action for the owner
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 888
sprint: svsqcj9
blocked_by:
- 01M4GQBSJMKTPGQGYTCVW22ENQ
comments:
- id: 01M4K87117GQ6J47N5AXMCXP3Y
  author: Steve Vine
  at: 2026-10-10T15:51:55.686983Z
  text: |-
    Merged to main (PR #896, 2026-10-10). On staging once all ten tasks are in Review.

    What to look at:
    - A technology asset with resources beneath it gets a Findings section when a check has something to say. Each row is a sentence naming the resource ("Database cluster kora is not encrypted at rest.") and when it was first seen. The asset's classification sits beside the heading ("Holds Confidential data").
    - Accept asks for a reason and, optionally, a decision record. The finding stays listed as accepted, with who, when and why.
    - Raise a risk opens a short window: a title taken from the finding, and likelihood and impact for you to choose. The risk is added to the register, linked to the asset, owned by the asset's owner, and the finding then shows which risk it became.
    - Findings nobody has answered are an action for the asset's owner ("AST-7 Kora has 2 findings to accept or raise as a risk"). Once each is accepted or has a risk, the action goes.
    - The Technology assets list shows a red findings badge in the Resources column and has a Findings filter. The Inventory tile on the dashboard counts assets with findings to answer.
    - In the portal an owner sees the same list and can Accept.

    The checks, fixed for this sprint:
    - not encrypted at rest (databases, buckets, file systems);
    - reachable from the internet (databases);
    - public access not blocked (buckets);
    - automated backups off (databases, file systems), point-in-time recovery off (tables);
    - a Kubernetes cluster whose control endpoint is public, or whose secrets are not encrypted;
    - every resource behind an asset has gone while the asset is still live;
    - an asset is decommissioned but a resource behind it still exists.

    Behaviour worth knowing:
    - A finding closes by itself when the next read shows the fact has changed. If the same thing comes back later it is a new finding, and an earlier acceptance does not carry over.
    - If the role loses a permission, findings neither appear nor disappear because of it. The last known fact stands until it can be read again, and the account's row says which permission is missing.
    - A shared part's finding appears on each asset it serves. Each owner answers for their own.
    - Only resources beneath a technology asset are checked.

    Two things differ from the task text, both deliberate:
    - Raising a risk is not offered from the portal, and in the app it needs the risk register's own permission as well as Inventory's. A finding should not be a way round who may write risks. An owner without that permission accepts, or asks someone who has it. Say if you want owners to be able to raise risks from the portal and I will add it as its own task.
    - "Raise a risk" opens a short window (title, likelihood, impact) rather than the full risk form. The rest is filled in on the risk afterwards.

    Technical: migration 0237 (resource_findings). Checks are in core/discovery/checks.py; one entry each. ADR 0099 §10 has an amendment saying what accepting is. One new portal write route (accept), added to the allowlist test. New action type inventory_findings.
assignee: steve
label:
- feature
priority: medium
task_status: review
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