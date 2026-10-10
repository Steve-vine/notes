---
id: 01M4GQCS04VWFMV1MPSENE087M
created: 2026-10-09T16:19:29.412496Z
updated: 2026-10-10T15:35:00.529432Z
type: task
title: A rule files new resources by itself — everything in an account, or carrying a tag, belongs to a technology asset or is discarded
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 887
sprint: svsqcj9
blocked_by:
- 01M4GQBC18SVPP9FKTMQE1TN21
comments:
- id: 01M4K77ZJ8RYCFWBMXPWMB6REZ
  author: Steve Vine
  at: 2026-10-10T15:34:58.376653Z
  text: |-
    Merged to main (PR #895, 2026-10-10). On staging once all ten tasks are in Review.

    What to look at:
    - The Discovered tab has a Rules chip. It lists the company's rules in the order they are tried, with how many resources each has filed. Up and Down change the order; Apply now, Edit and Delete are on each row.
    - New rule asks which resources match (an account, a kind, a tag and its value, in any combination) and what happens to them: add to a technology asset, or discard with a reason.
    - As soon as the form is a complete rule it shows what would be filed right now, by name, with a tick box "File these now, as well as what arrives later".
    - In the Awaiting list, tick some rows and press "Always do this for resources like these". The rule form opens with the account, kind and tag those rows have in common.
    - After the next read, anything that matches a rule is filed straight away. In the Attached and Discarded views each such row says "Filed by a rule" and which, and a "Filed by" filter separates rules from people.
    - An AWS account's row under Settings says how many resources rules filed at the last read.

    Behaviour worth knowing:
    - The first matching rule wins. A later rule gets only what earlier ones leave.
    - A rule only looks at what is awaiting a decision. It never moves something a person placed, and never brings back something a person discarded.
    - A rule never makes a technology asset. It files beneath one that exists.
    - Tags match exactly, capitals included. AWS's own tags are kept, so the tag aws:cloudformation:stack-name files everything a CloudFormation stack created.
    - Deleting a rule leaves what it filed where it is.
    - If a rule's technology asset is deleted, the rule shows "Broken", files nothing, and Inventory admins get an action. Editing the rule to point at another asset mends it.
    - What a rule files is recorded as its author's decision: one line per read on the technology asset's audit trail, naming what arrived.

    One limit: a rule being edited is not previewed, only a new one. The preview shows what a rule would get after all existing rules, and an existing rule is already one of them.

    Technical: migration 0236 (discovery_rules; which rule filed what; what the rules did at the last read). core/discovery/rules.py has one function used by the read, by Apply now and by the preview. New action type inventory_rule_broken.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Part of sprint 67, Inventory expansion (ADR in COM-881). Without rules every new resource is a decision for a person. With them, a person decides once and later arrivals follow.

## What people see

- **The Discovered tab gains "Rules".** A rule says which resources it matches and what happens to them.
  - **Matches on** any combination of: the AWS account, a tag and its value, and the kind of resource.
  - **Outcome:** add to a named technology asset, or discard with a reason.
- **Making a rule shows what it would match right now**, and offers to apply it to those still awaiting a decision.
- **From a selection in the Discovered list, "Always do this for resources like these"** opens a rule already filled in from the account and tags the selection has in common.
- **Later reads file matching resources straight away.** They never appear as awaiting a decision. A "Filed by a rule" filter shows what was filed and by which rule.
- **Rules are ordered and the first match wins.**
- **What a rule never does:**
  - make a new technology asset;
  - move a resource a person has already placed or discarded;
  - put a resource that holds data beneath a second technology asset.
- **Deleting a rule leaves what it filed where it is.**
- **If a rule's technology asset is deleted, the rule is marked broken** and stops filing, and Inventory admins get an action to fix or delete it.
- **Who:** anyone who can manage the register.

A whole CloudFormation stack can be filed with one rule, because AWS tags everything a stack creates with the stack's name.

## Notes (technical)

- **`discovery_rules`**, company-scoped: `position`, `match` (JSONB with a validated schema: `connection_id`, `tag_key` + `tag_value`, `kind`, all optional but at least one required), `outcome` (`attach` | `discard`), `container_id`, `discard_reason`, a `broken` flag, the usual mixins.
- **Applied at the end of each read**, in the same transaction as the upserts, to resources in state `new` only. Idempotent: running twice files nothing twice.
- **Provenance.** `filed_by_rule_id` on the attachment row and on the discard, so "Filed by a rule" is a filter and the audit trail can name the rule. Nulled when the rule is deleted.
- **The one-home rule still holds.** A `datastore` resource that already has an attachment is skipped by an `attach` rule, and the skip is counted on the read's status.
- **Preview** is the same match query run without writing; share the code path so the preview cannot disagree with the result.
- **Tag match is exact**, on key and value, case-sensitive as AWS is. No wildcards in this task.
- **The broken-rule action** is a declared action source in `core/actions/inventory.py` (ADR 0055). Do not write a notify().
- **API.** `/api/v1/inventory/discovery-rules`: list, create, update, delete, reorder, preview, apply. `inventory.manage_register`. Regenerate `schema.d.ts` and run the drift script.
- **Activity log** entries for create, change, delete, and one summary line per read that filed something.
- **Tests.** Integration: first match wins, a placed resource is not moved, a discarded one is not revived, the datastore skip, deletion keeps filings, the broken flag on asset delete, preview equals result. Vitest for the rule dialog and the "resources like these" prefill.

**Done when:** on staging, a rule for one tag files every matching resource beneath a technology asset; a new matching resource created in AWS is filed on the next read without appearing as awaiting a decision.