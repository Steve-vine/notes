---
id: 01M6PVQCPHG7TJ8WG951S5BH6S
created: 2026-11-05T22:02:01.809866Z
updated: 2026-11-05T22:03:04.418232Z
type: task
title: Polaris in chat knows about collected evidence — "what's broken?", "which ISO 27001 controls aren't automated yet?", "design checks for the IDM domain" — it reads coverage, problems and the review queue, and can start a batch (asking first), but never approves anything
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1613
sprint: s5khbev
assignee: steve
label:
- feature
priority: medium
task_status: todo
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