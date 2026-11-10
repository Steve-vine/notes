---
id: 01M73QEXQJ7PQ42KXMQAXYGC3X
created: 2026-11-10T21:57:37.650764Z
updated: 2026-11-10T21:58:32.449174Z
type: task
title: 'Target: Nessus Expert''s API reads recreated as configuration — scans as parts, the newest finished run of each, its hosts and their findings through follow-on reads, closing only on hosts the run covered (needs internal addresses)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1714
sprint: sj4f1kj
assignee: steve
label:
- feature
priority: medium
task_status: todo
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