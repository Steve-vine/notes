---
id: 01KYJ912KETR4XTW4B5B5GH9GF
created: 2026-07-27T17:12:43.88679Z
updated: 2026-07-28T14:54:47.396423Z
type: memo
title: ISE CI Issues
project: 01KX671DATY39VW6GWK3M2T3DN
comments:
- id: 01KYMJDYM5X87AZKR5P8KET4MD
  author: Steve Vine
  at: 2026-07-28T14:35:31.845022Z
  text: |-
    2026-07-28 ~13:59–14:45 UTC — staging CI hung/failed twice on external fetches (Playbooks V2 batch, commit 170f910). ROOT CAUSE FOUND: site DNS upstream flapping.

    Symptoms: (1) first run's combined-check sat on "Install (backend)" (uv sync) for ~29 min — cancelled; (2) the re-run then FAILED at setup-uv ("The operation was aborted due to timeout" downloading uv from GitHub releases). [Correction to the first version of this note: the re-run did NOT complete the install — it failed at an earlier step.]

    Diagnosis trail: runner pods healthy (0 restarts); egress from the ise-api pod worked at the moment of testing while runner pods timed out on both pypi.org AND github.com — then results flip-flopped between probes, kubectl on the workstation itself failed to resolve g5.citops.net once, and finally the local resolver failed 6/6 consecutive lookups while direct queries to 1.1.1.1 succeeded 3/3. Upstream = 192.168.1.1 (the router's DNS forwarder), which was answering again minutes later. Conclusion: the router's DNS is intermittently dead, site-wide — not the pipeline, not the cluster, not the code. CI runs are disproportionately exposed because a dependency install performs hundreds of lookups, so any dead window during install kills or hangs the run; a single app request rarely notices.

    Actions: run 30365901281 cancelled + re-run (again) during a working window. Network-side fix is outside ISE: the router (192.168.1.1) needs looking at, or the site/node DNS pointed at a resolver that stays up (e.g. 1.1.1.1/8.8.8.8 directly — CoreDNS forwards to the node's resolv.conf, so fixing the node fixes the cluster).

    Standing mitigations worth considering if this recurs: uv cache on a persistent runner volume (fewer fetches = smaller DNS exposure), and node-level fallback nameservers so one dead forwarder can't stall the whole site.

    Escalation rule (kept from v1): one hang → re-run; a second failure on external fetches the same day = infrastructure, not transience — diagnose the network path before re-running again. (That rule is what caught this.)
- id: 01KYMKH734HSE7TWN6Q43BD5S9
  author: Steve Vine
  at: 2026-07-28T14:54:47.396265Z
  text: '2026-07-28 ~15:00 UTC addendum: attempt 3 (re-run of 30365901281) failed at the same setup-uv external fetch; local resolver checks against 192.168.1.1 failing 4/4 at that moment. Per the escalation rule, HOLDING further re-runs until the router''s DNS is fixed — the pipeline and the commit are fine; every failure has been an external fetch crossing a DNS dead window. Staging branch now sits at fed064d (adds migration 0068); one CI run is needed once DNS is stable to test, build and deploy it. The walkthrough was unblocked without CI by hand-converging staging''s DB (constraint + run_playbook model config) with exactly what 0068 applies.'
---
The following issues were experienced during the CI process (test, build, release). These are issues with the process itself rather than code errors failing tests.

Each issue should be added as a separate comment.