---
id: 01M73QF7RZH67VATW4T71Y1MTH
created: 2026-11-10T21:57:47.935202Z
updated: 2026-11-11T17:31:38.503911Z
type: task
title: 'Target: Aikido recreated as configuration — its repositories, containers and clouds as parts for several companies, issues with ignored and snoozed coming in as Accepted by Aikido, within raised limits'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1715
sprint: sj4f1kj
blocked_by:
- 01M73QCWRE14AT6SKFVHMRFSHK
- 01M73QD7FW4QGMCMGM1R24RAG9
- 01M73Q911761481VZ9JRJ6MHJ1
- 01M73E2RXRGT5CX8YEARWTC8TF
comments:
- id: 01M749A782QPGWD24D91X8Q8CX
  author: Steve Vine
  at: 2026-11-11T03:09:37.92235Z
  text: |-
    Staging is ready (74c7156f). **Couldn't check**: this needs Aikido's API client entered on screen. Steps for Steve:
    1. Add an Aikido Collection integration (OAuth client credentials).
    2. Add an account ticked "Serves several companies".
    3. Feed into Vulnerabilities from the issues export, with raised limits (timeout 300 s, retry), parts by repository, container or cloud, and status mapped so ignored and snoozed come in as Accepted.
    4. Give each part its company on the Parts tab, run the feed, and compare with the coded Aikido tile.
- id: 01M74TZ87GTJ3ME6RKWSQ1PSSF
  author: Steve Vine
  at: 2026-11-11T08:18:12.847811Z
  text: |-
    Set up on staging 2026-11-11: a new Collection integration, **Aikido** (OAuth client credentials at https://app.aikido.dev/api/oauth/token, test read /api/public/v1/workspace). Three feeds into Vulnerabilities wait for approval: **Issues in code repositories**, **Issues in containers** and **Issues in clouds**.

    Each feed:
    - reads the full issues export (filter_status=all) with raised limits: 300 s, retry once, up to 250,000 items and 100 MB;
    - keeps only its own kind of issue;
    - treats each repository, container or cloud as a part;
    - maps ignored and snoozed to Accepted, with the reason and snooze end, and closed, solved, fixed or resolved to solved, closing by what the source says.

    Steve, next:
    1. Add an account with the Aikido client ID and secret, and tick "Serves several companies".
    2. Preview the feeds, approve them, then give each part its company on the Parts tab. The coded tile has 130 repositories, 75 containers and 29 clouds to compare with.
- id: 01M74YVRG6XNZY1GG8PC7VCYPZ
  author: Steve Vine
  at: 2026-11-11T09:26:12.742586Z
  text: |-
    Steve added the Aikido account (2026-11-11). Previews, all reading cleanly with every issue mapped:
    - code repositories: 7,462 issues;
    - containers: 27,920;
    - clouds: 21,500.

    Changes made while previewing:
    - **Narrower read.** The full export with closed issues is over Compass's 100 MB ceiling for one read. Each feed now reads the open, ignored and snoozed exports and closes by "missing": an issue Aikido closes drops out of those lists and closes, only within a part that was read.
    - **Titles.** Issues with no title (leaked secrets, mostly) read "A leaked secret in <file>", from the issue type and file.
    - **No CVSS score.** Aikido scores out of 100 and mappings can't do arithmetic (they never run code), so it's left out. Severity still comes through. "Scale a number" is a missing capability worth noting.

    Nothing comes in until each repository, container and cloud has its company on the Parts tab. Steve: approve the three feeds. The first run lists the parts; then assign them.
- id: 01M75EK1KVE7YA2JG8X8WVMNCZ
  author: Steve Vine
  at: 2026-11-11T14:01:04.379037Z
  text: |-
    Where this stands (2026-11-11 14:00, staging bb59b9a2). The configuration is done (see the comment above). What's left needs Steve:
    1. **Assign the parts.** The Aikido integration needs attention: "213 parts not assigned to a company yet". Nothing comes in from a part until it has a company. Give each repository, container and cloud its company on the Parts tab, or Don't read.
    2. **The coded Aikido reader is failing on staging.** Its last read at 12:10 said "Aikido refused the client ID and secret". That's the coded tile's own key, not the configured integration's, which signs in fine. Its key needs replacing before there's anything to compare against.
    3. **Compare** the two side by side for two days: vulnerabilities, sightings, targets, acceptances and closures.

    I'll export the configuration as JSON onto this task once the comparison is agreed.
assignee: steve
label:
- feature
priority: high
task_status: done
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