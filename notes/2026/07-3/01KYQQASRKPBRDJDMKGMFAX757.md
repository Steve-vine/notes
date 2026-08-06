---
id: 01KYQQASRKPBRDJDMKGMFAX757
created: 2026-07-29T19:58:54.739214Z
updated: 2026-08-06T08:34:47.089286Z
type: task
title: Azure Service Health → Alert signals
project: 01KX671DATY39VW6GWK3M2T3DN
number: 367
sprint: s0d5f5q
blocked_by:
- 01KYQQAJXZVXDTHJMA56VWBNPD
comments:
- id: 01KYQZPYKXTCEH6SE5YM96YRNG
  author: Steve Vine
  at: 2026-07-29T22:25:21.533834Z
  text: |-
    Built and in review — PR #340 (feature/ise-367-azure-service-health, stacked on #339), merged to staging.

    Active Service Health events (Resource Health events API, 2022-10-01) ride the same detect() sweep as the Monitor alerts; Resolved events are not sightings, so recovery derives from absence like every other presence-based source. Severity by category: ServiceIssue → high (Azure saying "broken", auto-opens at the default threshold), SecurityAdvisory → medium, PlannedMaintenance → low, HealthAdvisory → info.

    One planned delta, in the sprint's favour: the task asked for filtering to services/regions in use — that comes FREE from the subscription-scoped events feed, which Azure already tailors to what the subscription's resources use, so there is no curated service list to maintain (unlike the Status Page register). A named impacted resource attributes onto the lower-cased ISE-365 key via the impactedResources sub-call; region-wide events stay unattributed rather than guessed. A Resource Health outage degrades to a warning and never takes the alerts sweep down (tested). 5 new tests; ruff/mypy clean.
assignee: steve
label: null
priority: medium
task_status: done
---
Mirror of ISE-361 (AWS Health). Ingest Azure Service Health events for the subscription — service issues, planned maintenance, health advisories — as Alert signals. Filter/scope to services and regions actually in use, derived from discovered resources, so unused-service noise is not alerted on (Status Page sprint precedent for relevance filtering).