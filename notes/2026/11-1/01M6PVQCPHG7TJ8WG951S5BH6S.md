---
id: 01M6PVQCPHG7TJ8WG951S5BH6S
created: 2026-11-05T22:02:01.809866Z
updated: 2026-11-07T08:55:18.931367Z
type: task
title: Polaris in chat knows about collected evidence — "what's broken?", "which ISO 27001 controls aren't automated yet?", "design checks for the IDM domain" — it reads coverage, problems and the review queue, and can start a batch (asking first), but never approves anything
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1613
sprint: s5khbev
blocked_by:
- 01M6PVPJNNBNB5Y7KQY108XCHF
comments:
- id: 01M6QCKKXH87CYM57S3NYSYJTV
  author: Steve Vine
  at: 2026-11-06T02:57:03.92175Z
  text: |-
    Done — merged to main (PR #1629).

    What's there
    Polaris in chat (and through MCP) can now answer, for a company:
    - "What's broken?": problems by cause with the fix in words. One account that can't sign in is one problem, named "MongoDB · Production can't sign in".
    - "Which ISO 27001 controls aren't automated yet?": coverage by framework, domain, coverage or result, with the same totals as the Checks page.
    - "How is CRD.3 collected?" / "Show me the latest capture for…": its checks, what each shows, schedule, rule, why it's broken and what to do, and each account's latest capture (when, how many items, still true on, and a link). Never the raw data.
    - "What's waiting for review?": counts by kind and the items.
    - "Design checks for the IDM domain" / "Re-check …" / "Re-create …" / "Collect now for …": Polaris previews first (how many controls, what's left out, the cost, today's limit) and asks before it starts. Starting needs Record assessments. What Polaris then proposes waits on the Review tab.
    - "Which Collection integrations do we have?": each service, its owner, state and each account's health and last read. Never a key.

    Nothing in chat approves, confirms, discards or marks Manual only, and it can't create or change an integration or its keys. The test checks no such tool exists.

    Also: "Why is this check failing?" now gives advice for collected checks too.

    My calls
    - Controls are named by their ref (as on screen), a domain or a framework.
    - Switching checks off or on isn't offered in chat; it changes what Compass judges, like thresholds, so it stays on screen.

    Tests: test_assistant_collection.py.

    What to check on staging: through the compass MCP server or the Polaris window in E2E Test Company, ask "what's broken?" and "which controls aren't automated yet?". The chat window itself is Couldn't check here: it needs Polaris's AI provider. Through MCP it can be checked.
- id: 01M6RBG0HYN5Z0Q0W29PH8RSHZ
  author: Steve Vine
  at: 2026-11-06T11:56:51.646169Z
  text: |-
    Pre-UAT, through staging's compass MCP server, on E2E Test Company: Passed, with one fix (COM-1620).

    What I saw:
    - **"What's broken?"** listed the broken GitHub account as one item ("… can't sign in: 1 check affected"), with "Re-enter the key" and a link.
    - **Coverage for ISO 27001** matched the page: 1 / 7 / 0 / 235, and `doing=broken` returned ACC.13.
    - **The review queue** gave the same count as the Review tab, by kind.
    - **A batch.** "Design checks for ACC.1 and ACC.2" was previewed first: 2 controls, $0.48, fits today. It then started and appeared on the Review tab.
    - **Nothing approves.** The only tool that changes anything is the batch start, marked as asking first, and no tool approves.

    Fix (COM-1620): "what's broken" listed controls by internal key (`s42.ACC.4`) instead of ref (ACC.13).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint "Checks - Coverage and batch work" (COM-1605). Builds on COM-1612. The chat Polaris (ADR 0127), acting as the person and asking before each change, gains tools for this sprint's and the last one's features.

## What people see

In the Polaris window (or through MCP), a person can ask:

- **"What's broken?"** Problems grouped by cause, with the fix in words (COM-1608).
- **"Which ISO 27001 controls aren't automated yet?"** Coverage, filtered by framework, domain, Covered or Doing (COM-1607).
- **"How is CRD.3 collected?"** The control's checks, accounts, last capture, rule and state.
- **"Show me the latest capture for…"** A summary of it, with the link (never the whole raw data in chat).
- **"What's waiting for review?"** The queue's counts and items (COM-1610).
- **"Design checks for the IDM domain"** / **"Re-validate the MongoDB checks"** / **"Collect now for…"** Polaris **asks first**, saying how many controls and the expected cost, then starts the batch. It's the same job as the page's (COM-1609).
- **"Which Collection integrations do we have?"** The services, their accounts and their health, never keys.

**Polaris never approves, confirms, discards or marks Manual only from chat.** Those stay a person's decision on screen, as the first-capture check is the safety step (ADR 0142). It also can't create or change integrations or their keys from chat.

## Notes (technical)

- Tools in a new `assistant/tools/posture_collection.py` (prefix `posture_`, so they're in the Posture section's toolbox) and `integrations_…` read tools.
- Starting batches is `@compass_tool(always_ask=True)`. Reads are plain.
- Each tool calls the same core functions as the API routes.
- Update `assistant/tools/posture_checks.py`'s `_FIX` advice for collected checks' broken reasons.
- Tool counts are pinned in tests: update them. Run the drift script if route docstrings change (route docstring memory).

**Chain:** on the chain (API: MCP tool list).

**Done when:** through the compass MCP server on staging (E2E Test Company):
- "what's broken" lists the revoked-key problem as one item;
- coverage by framework matches the page;
- "design checks for <domain>" asks first, then starts a batch that appears on the page;
- there's no tool that approves anything.