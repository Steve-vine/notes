---
id: 01M8FJ6WWYRSH35JCPA2QYF6H3
created: 2026-11-27T22:32:26.782728Z
updated: 2026-11-28T02:51:14.773054Z
type: task
title: 'The Security Feed checks each server''s own version: "Everything we run" compares the exact version discovered on every server, and a match names each server with its version'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2212
sprint: s51yxk5
blocked_by:
- 01M8FJ6FP65A48HF2SCP8MPF4K
- 01M8FATKBRPVSNTVEM5E7C89ZT
assignee: steve
label:
- feature
priority: high
task_status: active
---
**On the chain** (API). ADR 0188 (COM-2211). First build task of the sprint.

## What people see
- On a Security Feed item that matches, **the systems it names show each server's own version**: "SRV01 — Google Chrome 129.0.6668.59 (affected; fixed in 130.0.6723.58) · SRV07 — 130.0.6723.70 (not affected)". Today it shows the one version on the Software register entry.
- A server that reports **no exact version** for that software falls back to the register's version, marked "version from the Software register".
- The **Products** tab shows, per linked product, how many servers run it and the spread of versions ("12 servers · 4 versions").
- **Not affected** servers are listed under the match but greyed, so it's clear they were checked.
- This works for every source of discovered software: the agent (ADR 0187), AWS, Azure and Google Cloud.
- Nothing else changes: these matches are still **possibly affects us** until a person confirms them (ADR 0139 §8); exact matches arrive in later tasks.

## Notes (technical)
- `core/security_feed/matching.py company_context()` today compares `SoftwareProductLink.version` for the `SoftwareAsset`, reaching systems through `ContainerSoftware`. Add the per-resource path: `SoftwareAsset.discovery_key` → `DiscoveredSoftware` rows with that key on resources under each container (`TechnologyAssetResource`) → compare each row's `version` with `core/security_feed/versions.py`. Use the register version only where no resource row has a version.
- Return per-container results (affected / not affected / can't compare / versions not stated) with the version used and where it came from.
- Watch performance: a company may have thousands of rows; batch per product, not per item.
- `raising.py raise_vulnerabilities()` raises only on the affected servers.

**Done when:** on staging, a feed item for software the test rig reports at two versions names both servers with their versions, one affected and one not; and a confirmed raise creates issues only on the affected server.