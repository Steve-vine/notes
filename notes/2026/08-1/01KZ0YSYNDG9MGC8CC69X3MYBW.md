---
id: 01KZ0YSYNDG9MGC8CC69X3MYBW
created: 2026-08-02T10:02:41.197719Z
updated: 2026-08-13T19:00:27.87864Z
type: task
title: An unknown tag key raises a proposal
project: 01KX671DATY39VW6GWK3M2T3DN
number: 474
sprint: s7j0986
blocked_by:
- 01KZ0YQ7TJ30GJKTE928QNPR98
comments:
- id: 01KZ1E31SPF8496QPBG0A9VS1E
  author: Steve Vine
  at: 2026-08-02T14:29:47.958663Z
  text: |-
    Built and up for review — PR #413 (feature/ise-474-unknown-key-proposals), merged to staging. No migration, no new UI (rides the existing tag-mapping kind and queue).

    - Gap confirmed as described: detect_tag_mapping_candidates only proposed VALUE mappings. New key pass: every canonical-resolving-to-nothing key carried by live entities raises one proposal fingerprinted on the key ("3 resources carry platform:…") with its distinct-carrier count, biggest carriers first under the shared per-run cap.
    - Two deterministic confirm outcomes, stated in the evidence before the click: a spelling variant of a governed key/alias (Owning-Team → owning_team → team) confirms as an ALIAS; a genuinely new key confirms as an ADOPTED governed open key. Both re-resolve through the existing confirm path. Rejection durable.
    - 3 new integration tests; existing detector tests unchanged; 37-test regression green.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Nothing unlisted maps silently — but today that principle is only enforced for tag *values*.

The existing candidate detector proposes mappings for values against governed keys. An unrecognised **key** appears to have no equivalent: it shows up as missing coverage and nothing asks about it. So `platform:env-staging-uk` arriving in an estate whose Platform role is bound to `project` is invisible as a *question*, even though one confirmation would resolve every resource carrying it.

- An unrecognised canonical key raises a **proposal** into the existing queue: "17 resources carry `platform:` — is this an alias of `project`?"
- Confirming adds the alias and re-resolves deterministically.
- Rejection is remembered, so a genuinely unrelated key isn't re-asked every sync.
- Fingerprint on the key itself so the same question strengthens one queue item rather than opening one per resource.

**Acceptance**: a tag key ISE has never seen produces exactly one proposal with the affected resource count; confirming it maps the key and re-derives; rejecting it is durable.

Verified 2026-08-02 as a probable gap — confirm against `proposals.detect_tag_mapping_candidates` before building.