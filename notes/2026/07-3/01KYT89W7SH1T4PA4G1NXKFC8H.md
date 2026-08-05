---
id: 01KYT89W7SH1T4PA4G1NXKFC8H
created: 2026-07-30T19:33:59.161068Z
updated: 2026-08-05T19:29:28.38927Z
type: task
title: S3 bucket tags via the Resource Groups Tagging API
project: 01KX671DATY39VW6GWK3M2T3DN
number: 380
sprint: sv6hnwj
comments:
- id: 01KYTEE0H8NJ2B57R3GJBVV0AH
  author: Steve Vine
  at: 2026-07-30T21:21:06.088649Z
  text: |-
    Built on feature/ise-380-s3-bucket-tags, PR #355 → main; merged to staging (56e0e73), deploy running.

    - _discover_s3 now joins bucket tags by ARN from a per-configured-region resourcegroupstaggingapi.get_resources sweep (paginated, ResourceTypeFilters=["s3:bucket"]) — one call per region instead of one GetBucketTagging per bucket. tag:GetResources was already in the read-only scopes: no IAM change, no migration, backend-only.
    - Honest semantics: bucket seen in the sweep → tags_known=True with real tags (empty list = genuinely now-untagged, correctly withdraws); NOT seen → stays tag-blind (the tagging API only reports tagged-or-previously-tagged resources in swept regions, so absence ≠ no tags — could be never-tagged or homed outside the configured list); whole sweep failed → all buckets tag-blind (a failure to read tags never withdraws them); stale mapping for a deleted bucket mints nothing.
    - Knock-on live now: bucket tags feed the pool/groups/compliance, and non-compliant bucket tags are correctable from Tag detail via set_resource_tag (ISE-375 fix-at-source).
    - Tests: 3 new + 1 reworked in test_aws_discovery.py (paginated sweep, unavailable API, empty sweep, stale ARN). Full suite 1628 passed; ruff/format/mypy clean.

    Smoke: after the next AWS sync on staging, kora-assets-style buckets should show their tags on entity detail / in the Tag Cloud.
assignee: steve
priority: medium
task_status: done
---
Buckets are the only discovered AWS type emitted tag-blind (`tags_known=False` in `_discover_s3`, ISE-359): S3 offers no bulk tag listing, and one `GetBucketTagging` call per bucket per sync cycle was a fan-out the sync loop must not pay.

ISE-375 removed the objection: the Resource Groups Tagging API's read half — `tag:GetResources`, already in the connector's `read_only_scopes` — returns tags for all taggable resources in a region in one paginated sweep, buckets included.

- In `_discover_s3` (or a shared per-region tag sweep), bulk-fetch bucket tags via `resourcegroupstaggingapi.get_resources` (filter `ResourceTypeFilters=["s3:bucket"]`), join by ARN, emit real `tags` and drop `tags_known=False`. Contain failures per the existing per-slice pattern — a tagging-API error degrades back to tag-blind, never crashes discovery.
- Note: buckets are global-namespace but region-homed; the tagging API is regional, so sweep the configured regions (a bucket outside the configured list stays tag-blind — acceptable, same rule as discovery itself).
- Knock-on for free: bucket tags feed the unified tag pool / groups / compliance, and since `aws` is in the ADR 0043 fix-at-source map, a non-compliant bucket tag becomes correctable from the Tag detail page via `set_resource_tag`.
- Tests: stubbed tagging-API fixture in `test_aws_discovery.py` (tags land on the bucket entity; API failure → tag-blind, discovery still returns the bucket). No migration, read-side only.