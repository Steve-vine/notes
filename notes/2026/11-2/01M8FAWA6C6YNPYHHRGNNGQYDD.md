---
id: 01M8FAWA6C6YNPYHHRGNNGQYDD
created: 2026-11-27T20:24:19.916627Z
updated: 2026-11-28T01:37:56.301466Z
type: task
title: 'Staging test rig and the production setup guide: an osquery agent in a container reporting to staging for the E2E Test Company, and the steps to publish the agent door in production'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2208
sprint: smfrbak
blocked_by:
- 01M8FAT451SNMBHNVNB32AHC0P
comments:
- id: 01M8FWTEYW0TM7B3GJC90W3XHB
  author: Steve Vine
  at: 2026-11-28T01:37:53.628768Z
  text: |-
    Built: PR #2218, merged to main (it goes to staging with the sprint's deploy).

    What's there:
    - Staging publishes the agent address at agent.citops.net, with its own certificate. No public DNS record is needed: the test servers reach it from inside the cluster.
    - Two test servers for the E2E Test Company, an Ubuntu 24.04 and a Rocky Linux 9 container, kept apart from the app (scripts/infra/server-agent-test.yaml, applied by hand, never in production). Each runs the company's real Linux install script, which downloads osquery from the agent address, checks it, installs it and joins. They run as root because installing a package is the point, with privilege escalation off.
    - The browser tests open Admin ▸ Integrations ▸ Server agent.
    - The production guide (scripts/infra/production/README.md): the setting for the agent address, the Cloudflare Tunnel route and a rule that blocks everything but your servers' fixed addresses, the allowed addresses in Compass, and an Automox worklet (paste the company's script as the fix; the check looks for osquery 5.24.1 running).

    For you to do in production: the four steps in that guide. Staging I set up myself at the sprint's deploy (allow the pod network, switch the agent on for the E2E Test Company, load its script, start the two servers).
assignee: steve
label:
- chore
priority: medium
task_status: review
---
**Independent** (staging values, test rig, docs; no migration or API). ADR 0187 Consequences. After COM-2204 (needs the install script).

## What it gives
- **On staging**, the agent door is switched on (g5's internal address is enough; it needn't be public) and one or two **Linux containers running osquery**, installed by the Linux install script from the E2E Test Company's setup page, report to it. One is named after a server the directory finds for the E2E Test Company (so it joins by itself), one isn't (so it waits to join). Nothing in any other company.
- The **Browser smoke** covers the new screens (Admin ▸ Integrations ▸ Server agent; Servers from the agent; a server's Patch level and Configuration) for the test accounts that can see them.
- **A setup guide** (in `scripts/infra/production/` or the chart README, wherever the Vendor Portal's lives) for publishing the agent door in production:
  1. the chart values (`config.agentPublicUrl`, `agent.ingress.*`, `agent.trustedProxyHeader`, trusted proxy ranges);
  2. a **Cloudflare Tunnel** route for the agent host to the cluster (as for `vendor-portal.moneypenny.uk`), and a **Cloudflare rule** that allows only the servers' fixed IP addresses on that host;
  3. the allowed addresses in Compass;
  4. an **Automox worklet** example: the company's Windows script, copied from Compass's setup page and pasted into the worklet (servers can't reach main Compass, only the agent door); the same worklet re-run upgrades.
- Steve applies the production steps (production values live in devops.infrastructure.aws, which I don't push to).

## Notes (technical)
- The rig as a small Deployment in the staging overlay (`values-staging.yaml` / staging manifests), pinned osquery image built from the official package, bootstrapped by the rendered Linux script against the staging agent host; the joining code from a staging Secret seeded for the E2E Test Company.
- The containers' "installed packages" are the test data for COM-2205's Done when (remove a package, Read now).

**Done when:** after the sprint's deploy, the rig's servers appear under Servers from the agent for the E2E Test Company (one reporting, one waiting), the Browser smoke is green with the new screens, and the guide is merged.