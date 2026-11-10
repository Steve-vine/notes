---
id: 01M70VECM5TSGFBD7JJQ91QPRC
created: 2026-11-09T19:09:31.14104Z
updated: 2026-11-10T08:56:48.765897Z
type: task
title: One address per area — each Compass area is its own MCP address with only its tools, so a Copilot agent stays under its tool limit
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1651
sprint: sr3v2fq
blocked_by:
- 01M70VE3SJ98XQ2WX0XNV7Y1BK
comments:
- id: 01M72AS059N9R3A4X32W0W1W54
  author: Steve Vine
  at: 2026-11-10T08:56:41.897262Z
  text: |-
    **Confirmed by ADR 0144 (COM-1650, 2026-11-10):**
    - **The limit:** 128 tools per Copilot Studio agent under generative orchestration, counted across all its MCP servers.
    - **Transport:** Streamable HTTP only, which Compass already serves.
    - **The areas** follow the tool-name prefixes; the ADR lists nineteen. Counts on staging today: access 102, vendors 76, inventory 72, dsr 70, incidents 55, posture 54, playbook 54, trust_centre 45, ddq 36, risk_assessments 34, vulnerabilities 27, audit 25, sap 24, initiatives 15, attestations 14, secrets 14, contracts 11, security_feed 8, overview 6, plus 3 shared.
    - **`resource`:** may name any address in the family, or be left out.
assignee: steve
label:
- feature
priority: medium
task_status: active
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