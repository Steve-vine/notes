---
id: 01M70VECM5TSGFBD7JJQ91QPRC
created: 2026-11-09T19:09:31.14104Z
updated: 2026-11-10T11:40:49.43156Z
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
- id: 01M72C5C0MJRFKR8MDDQ1HDGXK
  author: Steve Vine
  at: 2026-11-10T09:20:55.828569Z
  text: |-
    **Done: merged to main in PR #1675.**

    **What it does:**
    - **Every Compass area has its own assistant address.** `…/api/mcp/access`, `…/api/mcp/vendors`, `…/api/mcp/secrets` and so on: nineteen in all, following the tool names. Each offers only that area's tools, plus who-am-I, search and the company list. Access Control, the largest, is 105, under Copilot's 128.
    - **The area address is told only about its own area** when an assistant connects (the opening and closing rules stay).
    - **Calling another area's tool there is refused, saying where it is:** "…isn't offered at this address, which is Compass's Secrets area. It is at Compass's Vendor Management address (…/api/mcp/vendors), or at the full Compass address".
    - **Same door as the full address:** the same browser sign-in and Allow card, the person's role decides, and changes show in Activity via Polaris.
    - **One sign-in covers every address.** An assistant may name any of them when it signs in, or none.
    - **Each area has its own sign-in pointer**, and its "not signed in" answer points there. An unknown area isn't found.
    - **The full address is unchanged** for Claude and ChatGPT.
    - **The public assistant address lets the area addresses through.** The vendor-portal and trust-centre addresses still refuse them. The host-boundary check was extended and run locally (all fine).
    - **The Connect page's address answer now lists each area's address**, and whether the person's role can use it (used by COM-1653).
    - **A check fails CI if any area grows past 128 tools**, naming the area, or if a tool belongs to no area.

    **Tests:** new area tests against real Postgres:
    - an area lists only its tools and refuses another's with directions;
    - its instructions are trimmed;
    - its own sign-in pointer, and an unknown area not found;
    - a sign-in made at an area address works there and at the full address;
    - an unknown area is refused as a sign-in target;
    - the address answer follows the role.

    Plus the 128-tool check, and the existing assistant and sign-in tests. The unit suite (2068) passed locally, and CI passed.

    **To look at on staging** (after the deploy): connect an assistant to `https://compass-mcp.citops.net/api/mcp/secrets`; it should list only the Secrets tools. I'll run this in the pre-UAT.
assignee: steve
label:
- feature
priority: medium
task_status: done
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