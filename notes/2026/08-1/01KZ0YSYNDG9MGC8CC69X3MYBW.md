---
id: 01KZ0YSYNDG9MGC8CC69X3MYBW
created: 2026-08-02T10:02:41.197719Z
updated: 2026-08-02T13:09:22.764879Z
type: task
title: An unknown tag key raises a proposal
project: 01KX671DATY39VW6GWK3M2T3DN
number: 474
sprint: s7j0986
blocked_by:
- 01KZ0YQ7TJ30GJKTE928QNPR98
assignee: steve
label: null
priority: medium
task_status: backlog
---
Nothing unlisted maps silently — but today that principle is only enforced for tag *values*.

The existing candidate detector proposes mappings for values against governed keys. An unrecognised **key** appears to have no equivalent: it shows up as missing coverage and nothing asks about it. So `platform:env-staging-uk` arriving in an estate whose Platform role is bound to `project` is invisible as a *question*, even though one confirmation would resolve every resource carrying it.

- An unrecognised canonical key raises a **proposal** into the existing queue: "17 resources carry `platform:` — is this an alias of `project`?"
- Confirming adds the alias and re-resolves deterministically.
- Rejection is remembered, so a genuinely unrelated key isn't re-asked every sync.
- Fingerprint on the key itself so the same question strengthens one queue item rather than opening one per resource.

**Acceptance**: a tag key ISE has never seen produces exactly one proposal with the affected resource count; confirming it maps the key and re-derives; rejecting it is durable.

Verified 2026-08-02 as a probable gap — confirm against `proposals.detect_tag_mapping_candidates` before building.