---
id: 01M73QF7RZH67VATW4T71Y1MTH
created: 2026-11-10T21:57:47.935202Z
updated: 2026-11-10T21:57:47.935202Z
type: task
title: 'Target: Aikido recreated as configuration — its repositories, containers and clouds as parts for several companies, issues with ignored and snoozed coming in as Accepted by Aikido, within raised limits'
priority: high
label: feature
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1715
---
One of the sprint's three targets (ADR 0146, COM-1705). Aikido is coded today (ADR 0128/0129, COM-1359/1377) and has never completed a read on staging (COM-1693). So there's no history to carry across.

**Chain:** independent (configuration and comparison on staging)

## What gets set up

- An **Aikido** Collection integration: the workspace's region address, OAuth client-credentials sign-in (already supported) and page-number paging.
- **Parts** (COM-1708): code repositories, containers and clouds, each from its own list, assigned to companies. That matches today's Aikido tile assignments, which are carried over by hand or by an assistant.
- One feed into Vulnerabilities:
  - the issues list with a raised timeout and caps (COM-1709). Where Aikido allows, read **incrementally** with a weekly full read; otherwise one full read with the limits it needs;
  - targets are the repository, image or cloud; the issue is the CVE, or `check:<integration>:<rule>`;
  - **closing:** the source says so. Solved closes it, open reopens it;
  - **accepted in the source:** ignored comes in as Accepted by Aikido with its reason, and snoozed comes in Accepted until the snooze ends (ADR 0129 §4a).
- Check whether Aikido honours `per_page` on containers and clouds (both came back at exactly 20, COM-1693). If it doesn't, describe its paging correctly in the configuration.

## Done when

- Side by side with the coded Aikido reader on staging (once COM-1693 has made it work) for at least two days. The comparison lists vulnerabilities, sightings, targets, acceptances and closures from each, and they match, or every difference is explained or fixed as a capability.
- The configuration is exported as JSON on this task.
- No code change for Aikido (COM-1696).

## Notes

- COM-1693 (sprint 0) fixes the coded reader's timeout first, so there's something to compare against. If Steve would rather skip that and go straight to configuration, compare against Aikido's own screen instead.