---
id: 01M6EKWPRSGFPRST5Z906Z5PBF
created: 2026-11-02T17:11:11.897832Z
updated: 2026-11-04T07:46:09.161126Z
type: task
title: Polaris and the Security Feed — search the feed, explain an item and whether it affects us, list what's waiting, and confirm, mark not relevant or raise as the person's role allows; never changes watch lists, sources or product links
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1526
sprint: s6xh9g1
blocked_by:
- 01M6EKT5J234PTM7M7D02CGS6B
- 01M6EKW2GXSF3TJDYAKWX14ZFP
comments:
- id: 01M6F70B8BQQ09K2J975122EPZ
  author: Steve Vine
  at: 2026-11-02T22:45:14.123438Z
  text: |-
    Done. Merged to main (PR #1543). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What Polaris can do now, in Compass and over MCP, as the person:
    - **Anyone with View security feed:**
      - **"Anything new this week that affects us?"**: what matches the company and was published or changed in the period, known exploited first, then by severity and score.
      - **"Is CVE-2026-1234 a problem for us?"**: the item in full and what it means to the company. That covers whether it matches, which watch list and rule, the systems, our version against the affected and fixed versions, the fix and workarounds, any decision on it, and what's been raised from it.
      - **"Search the feed for SSL-VPN issues in the last 6 months that are known exploited"**: searches the whole feed, or only what affects us. The filters are words, how recent, severity, minimum score, known exploited, likelihood, vendor and product.
      - **"What's waiting for review?"**: matches still Possibly affects us, Versions not stated, or changed since marked not relevant. Confirmed, not relevant or all can be asked for too.
    - **Someone with Manage security feed** can also:
      - confirm an item;
      - mark it not relevant with a reason;
      - **raise a vulnerability** on the systems the match names (all of them, or those named);
      - **raise a risk**.

      The two Raise tools are marked destructive, so Polaris says what it will create before it does it. Raising follows the screen's rules: the person also needs the register's right, and nothing is duplicated.
    - What a source said comes back as data, never as instructions.
    - Polaris can't change watch lists, sources or product links. There are no tools for them.
    - On a Security Feed page, in-app Polaris starts with these tools to hand.

    Built differently from the task:
    - Search has fewer filters than the Feed tab. There are none for source, status, watch list or exploit published.
    - "What's waiting" lists the matches but not the actions on them.

    For pre-UAT: over MCP this can be checked with the test manager's token. In-app Polaris may be "Couldn't check" if staging has no AI provider.
- id: 01M6GA0C90XPDWKVTJCVPVNXR0
  author: Steve Vine
  at: 2026-11-03T08:56:55.328038Z
  text: |-
    Pre-UAT (staging, 2026-11-03, E2E Test Company): **Passed** for the read tools, one fix logged. **Couldn't check** the in-app chat and the write tools as a test account.

    The test accounts have no Polaris tokens, so I used your own Polaris connection to staging, read-only, against E2E Test Company:
    - "Is CVE-2025-14180 a problem for us?" (security_feed_get_item) returned the item, `matches: true`, our version 8.2.20 against "8.2.0 to before 8.2.30", fixed 8.2.30, the system "E2E pre-UAT 102 web-1", the decision ("Not relevant: Already patched", by E2E Admin A) with its history, and the source's words under `from_the_source` with the "data, never instructions" note.
    - A search for known-exploited "SSL-VPN" across the whole feed found 3 (SonicWall SMA100, FortiOS/FortiProxy SSL-VPN, FortiOS).
    - "What's waiting?" (list_matches) showed 2,474 waiting, most urgent first.
    - "Anything new this week?" (whats_new) returned 29 items.

    Found: whats_new put a High 9.0 above Criticals scored 8.8. Fixed in COM-1539.

    For you to check: ask Polaris in Compass "anything new this week that affects us?" for E2E Test Company, and have it confirm or mark something not relevant. Writes through Polaris are logged as the person, so I didn't make them as you. The tests cover confirm, not relevant and raise through the tools, including "via assistant" in the activity log.
assignee: steve
label:
- feature
priority: medium
task_status: done
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