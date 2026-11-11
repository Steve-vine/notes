---
id: 01M73QEXQJ7PQ42KXMQAXYGC3X
created: 2026-11-10T21:57:37.650764Z
updated: 2026-11-11T17:31:38.492935Z
type: task
title: 'Target: Nessus Expert''s API reads recreated as configuration — scans as parts, the newest finished run of each, its hosts and their findings through follow-on reads, closing only on hosts the run covered (needs internal addresses)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1714
sprint: sj4f1kj
blocked_by:
- 01M73QC5JFEQX7MZGKRC9RF4N6
- 01M73QCWRE14AT6SKFVHMRFSHK
- 01M73QD7FW4QGMCMGM1R24RAG9
- 01M73QDH6S86WH4VMHAXD2DJ98
- 01M73QDZ1J73H29KX8BJ5VZGVN
- 01M73Q911761481VZ9JRJ6MHJ1
comments:
- id: 01M73SCQRXVXZA07ZYHTYJDDQW
  author: Steve Vine
  at: 2026-11-10T22:31:23.165658Z
  text: Steve agreed to named internal addresses on 2026-11-10 (COM-1711 goes ahead), so this task stays in the sprint. Ignore the "if he doesn't, cancel" line in the body.
- id: 01M749A4TJW94PQF0K928CA5QV
  author: Steve Vine
  at: 2026-11-11T03:09:35.442486Z
  text: |-
    Staging is ready (74c7156f). **Couldn't check**: this needs Nessus's internal address approved and its API keys entered on screen. Steps for Steve:
    1. Admin ▸ Integrations ▸ Internal addresses: approve the scanner's host and port (needs Manage configuration).
    2. Add the Nessus Collection integration at that address, sign-in "API key in a header" (X-ApiKeys), with Nessus's CA certificate pasted in Settings.
    3. Feed into Vulnerabilities: /scans as parts; then /scans/{id} with items "history", choosing status in [completed], newest by last_modification_date; then the run's hosts; then each host's findings. Closing "missing" with scope target ← hostname.
    4. Compare with the coded Nessus tile.
    Optional for staging: set config.collection.refusedRanges to the cluster's pod and service CIDRs. Without it, Compass still refuses its own database, cache and Kubernetes API.
- id: 01M74TZADB7MY2WP8P37FXTGFV
  author: Steve Vine
  at: 2026-11-11T08:18:15.083051Z
  text: Blocked by COM-1720. Nessus (nessus.moneypenny.local:8834) is only reachable through the worker's Twingate connector. The website's API pod, where saving a service, Test and Preview run, can't resolve it. So the Nessus Collection integration can't be saved yet, even with its address approved. The service and feed settings to add once COM-1720 lands are written out in COM-1720. The address approval is still yours to make, under Admin ▸ Integrations ▸ Internal addresses.
- id: 01M74ZXH6N54BBWP9XAFVWHAEH
  author: Steve Vine
  at: 2026-11-11T09:44:39.380953Z
  text: |-
    Steve approved nessus.moneypenny.local:8834 (2026-11-11). Set up on staging:
    - A new Collection integration, **Nessus**: https://nessus.moneypenny.local:8834, sign-in "API key in a header" (X-ApiKeys), test read /scans. It saved without the website reaching the address (COM-1720).
    - Feed **Findings** into Vulnerabilities, daily, waiting for approval:
      - reads every scan, then each scan's newest finished run, then that run's hosts, then each host's findings;
      - closes by "missing", only on hosts the run listed;
      - each scan is a part.

    Still to do (Steve):
    1. Paste the CA certificate into Settings ▸ "CA certificate (optional)". It's the one the coded Nessus tile uses, a copy is at ~/compass-uat/nessus-ca.pem on g5, and the chat tools have no field for it.
    2. Add the account: "accessKey=…; secretKey=…" as the key, with "Serves several companies" ticked.
    3. Test it, preview the feed and approve it.
    4. Give each scan its company on the Parts tab. The coded tile has 69 scans, 2 assigned.
- id: 01M75EJXF1MYM1CY4BYJKKH690
  author: Steve Vine
  at: 2026-11-11T14:01:00.128903Z
  text: |-
    Where this stands (2026-11-11 14:00, staging bb59b9a2):
    - **Key:** Nessus's key format is set (COM-1722). Its account still signs in with the existing key.
    - **Findings feed** updated (waiting for approval):
      - each finding looks up its plugin once a run (COM-1727);
      - CVEs, CVSS (v3, else v2), description and solution are picked from the plugin's attributes;
      - each scan is a part (COM-1724).
      - The preview reads a sample within the request and shows descriptions and solutions from the plugins.
    - **Fix before approval:** a host in two scans would flap between runs (3 of the 212 hosts). COM-1729 fixes it (PR #1725). I'll deploy it before the feed is approved.

    Steve, next:
    1. Re-enter the Nessus account as two keys (Access key, Secret key) on its Accounts tab.
    2. Approve Nessus ▸ Feeds ▸ Findings. Its run lists the scans on the Parts tab; set the ones you don't want to Don't read.
    3. Compare two runs with the coded Nessus tile and a .nessus export of the same scan: counts, severities and CVEs.

    Measured for the Notes: the last full run made 267 follow-on reads for 14,291 findings. Plugin look-ups add one read per distinct plugin, which is well within the 20,000 cap.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
One of the sprint's three targets (ADR 0146, COM-1705). **It depends on Steve agreeing to named internal addresses (COM-1711).** If he doesn't, cancel this task and Nessus stays coded.

**Chain:** independent (configuration and comparison on staging)

## What gets set up

- A **Nessus** Collection integration at its approved internal address (COM-1711), with its own CA certificate, signing in with the access and secret keys in Nessus's header.
- One feed into Vulnerabilities, using only reads (no "prepare an export"):
  - the **scans** list, each scan a **part** assigned to a company (COM-1708);
  - each scan's **newest finished run** (COM-1710);
  - that run's **hosts**, then each host's findings, then each plugin's details for its CVEs, with repeated plugins read once (COM-1706);
  - a target is a host (its name and address). The issue is the CVE, or `check:<integration>:<plugin>`, as ADR 0129 §3c;
  - closing is *missing from a complete read*, scoped to the run's hosts (COM-1710), so a host absent from the run closes nothing.
- Limits raised as a large scan needs (COM-1709).

## Done when

- Side by side with the coded Nessus reader on staging for at least two runs of the same scans. The comparison lists vulnerabilities, sightings, targets and closures from each, and they match, or every difference is explained or fixed as a capability.
- Uploaded .nessus files and pen-test reports keep working through their existing paths. They are not integrations.
- The configuration is exported as JSON on this task.
- No code change for Nessus (COM-1696).

## Notes

- How many follow-on reads a large scan needs (hosts × plugins) decides whether the per-run cap in COM-1706 is enough. Measure it on staging's real scan and record it here.