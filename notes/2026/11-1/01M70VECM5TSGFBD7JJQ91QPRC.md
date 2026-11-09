---
id: 01M70VECM5TSGFBD7JJQ91QPRC
created: 2026-11-09T19:09:31.14104Z
updated: 2026-11-09T19:09:31.14104Z
type: task
title: One address per area — each Compass area is its own MCP address with only its tools, so a Copilot agent stays under its tool limit
assignee: steve
label: feature
priority: medium
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1651
---
**Wanted behaviour:**
- Every Compass area has its own address, for example `…/api/mcp/access` or `…/api/mcp/vendors`. It offers only that area's tools, plus who-am-I, search and the company list, and Polaris's instructions are trimmed to that area.
- An area address works exactly like the full one: the same browser sign-in, the same Allow card, the person's role decides what it can do, and changes show in Activity via Polaris. Signing in once covers that assistant's address. Signing in to one area doesn't need a separate Allow for another area the same assistant already holds.
- The full address `…/api/mcp` is unchanged, so Claude and ChatGPT keep every tool.
- Only areas the person's role can see are useful to them. An area they can't use still signs in, but its tools refuse as today. No new rules.
- Every area address is reachable on the public assistant address. The vendor-portal and trust-centre addresses still refuse them.
- A check fails CI if any area grows past 128 tools (including the shared ones), naming the area. It is cheaper to split an area than to discover the problem in Copilot.

**Done when:** on staging, an assistant signed in at an area address lists only that area's tools and runs one. The full address still lists all of them. The public address answers area addresses with a 401 and the sign-in pointer, and still returns not found for everything else.

**Implementation:** the area grouping already exists in the tool registry (the name prefixes). Each area address advertises its own protected-resource document. The token's audience covers the Compass MCP family, so `resource` may be any of the addresses. Extend `scripts/ci/check-portal-host-boundary.sh` and the chart's nginx allowlist for `/api/mcp/*`. The Connect page's address API returns the per-area list (an API change).

**On the chain:** API change. After the ADR.