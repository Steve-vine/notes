---
id: 01KYT89W7SH1T4PA4G1NXKFC8H
created: 2026-07-30T19:33:59.161068Z
updated: 2026-07-30T21:12:44.35265Z
type: task
title: S3 bucket tags via the Resource Groups Tagging API
project: 01KX671DATY39VW6GWK3M2T3DN
number: 380
sprint: sv6hnwj
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Buckets are the only discovered AWS type emitted tag-blind (`tags_known=False` in `_discover_s3`, ISE-359): S3 offers no bulk tag listing, and one `GetBucketTagging` call per bucket per sync cycle was a fan-out the sync loop must not pay.

ISE-375 removed the objection: the Resource Groups Tagging API's read half — `tag:GetResources`, already in the connector's `read_only_scopes` — returns tags for all taggable resources in a region in one paginated sweep, buckets included.

- In `_discover_s3` (or a shared per-region tag sweep), bulk-fetch bucket tags via `resourcegroupstaggingapi.get_resources` (filter `ResourceTypeFilters=["s3:bucket"]`), join by ARN, emit real `tags` and drop `tags_known=False`. Contain failures per the existing per-slice pattern — a tagging-API error degrades back to tag-blind, never crashes discovery.
- Note: buckets are global-namespace but region-homed; the tagging API is regional, so sweep the configured regions (a bucket outside the configured list stays tag-blind — acceptable, same rule as discovery itself).
- Knock-on for free: bucket tags feed the unified tag pool / groups / compliance, and since `aws` is in the ADR 0043 fix-at-source map, a non-compliant bucket tag becomes correctable from the Tag detail page via `set_resource_tag`.
- Tests: stubbed tagging-API fixture in `test_aws_discovery.py` (tags land on the bucket entity; API failure → tag-blind, discovery still returns the bucket). No migration, read-side only.