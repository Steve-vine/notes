---
id: 01M8FAWA6C6YNPYHHRGNNGQYDD
created: 2026-11-27T20:24:19.916627Z
updated: 2026-11-27T20:24:34.610949Z
type: task
title: 'Staging test rig and the production setup guide: an osquery agent in a container reporting to staging for the E2E Test Company, and the steps to publish the agent door in production'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2208
assignee: steve
label:
- chore
priority: medium
task_status: todo
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