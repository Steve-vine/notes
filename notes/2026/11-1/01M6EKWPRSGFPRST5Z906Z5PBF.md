---
id: 01M6EKWPRSGFPRST5Z906Z5PBF
created: 2026-11-02T17:11:11.897832Z
updated: 2026-11-02T19:53:16.683805Z
type: task
title: Polaris and the Security Feed — search the feed, explain an item and whether it affects us, list what's waiting, and confirm, mark not relevant or raise as the person's role allows; never changes watch lists, sources or product links
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1526
sprint: s6xh9g1
blocked_by:
- 01M6EKT5J234PTM7M7D02CGS6B
- 01M6EKW2GXSF3TJDYAKWX14ZFP
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 102, Security Feed (ADR 0139, COM-1510). Builds on ADR 0109 (Polaris works as the person) and the MCP sprints (70–74).

## What people see

In Polaris, inside Compass and over MCP, someone with *View security feed* can ask:
- "Anything new this week that affects us?" and get the company's new matches, most urgent first;
- "Is CVE-2026-1234 a problem for us?" and get the item, whether it matches, which systems, our versions against the affected and fixed versions, and the fix;
- "Search the feed for SSL-VPN issues in the last 6 months that are known exploited", using the same filters as the Feed tab, over the whole unfiltered feed;
- "What's waiting for review?" and get matches still Possibly affects us or Versions not stated, with their actions.

Someone with *Manage security feed* can also, as themselves:
- **confirm** an item, or mark it **not relevant** with a reason;
- **raise a vulnerability** on named systems or **raise a risk** from an item. These are marked destructive: Polaris says what will be created before it calls them.

Polaris **doesn't** add or change watch lists, sources or product links. Those stay on screen.

## My calls

- Text from a source comes back under `from_the_source`, and Polaris treats it as data, never instructions (ADR 0099).
- Raising follows the same rules as the screen: the person needs both permissions, and no duplicates.

## Notes (technical)

- Tools under `security_feed_`, auto-discovered like the other modules:
  - `security_feed_search`, `security_feed_get_item`, `security_feed_list_matches`, `security_feed_whats_new`;
  - `security_feed_confirm`, `security_feed_not_relevant`, `security_feed_raise_vulnerability`, `security_feed_raise_risk`.
- Each calls the public API as the person. Tool docstrings say what changes. Update the MCP server instructions with a Security Feed paragraph.
- Tool count and name tests: add to the expected sets.

**Chain:** on the chain (API).

**Done when:** on staging, Polaris over MCP:
- answers "Is CVE-… a problem for us?" for a known match in E2E Test Company with the systems and versions;
- finds SSL-VPN known-exploited items by search;
- marks one not relevant as the test manager, and the activity log shows it as via Polaris.

(Pre-UAT: in-app Polaris may be "Couldn't check" without the AI provider.)