---
id: 01KXP536TQVH3VD3B14SNQ7KJZ
created: 2026-07-16T19:05:15.351521993Z
updated: 2026-07-21T16:49:42.031086Z
type: task
title: Issue-chat agent loop-driver tools (non-executing)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 93
sprint: s0v93ii
blocked_by:
- 01KXP51V7CR9VDWE6Z4T9WEV1F
- 01KXP52NRFDXD3Z6KTDXGFS1G0
assignee: steve
label: null
priority: high
task_status: done
---
Give the issue-chat agent (ISE-91) the tools to drive the loop from a natural-language prompt — the "or by prompt" half of ISE-88 — staying strictly inside the ADR (ISE-89) boundary: **the agent drives the non-executing steps; it never approves and never executes.**

**Add tools:**
- `trigger_diagnose` — kicks the existing single-shot structured `diagnose` agent for this issue (same path as `POST /issues/{id}/diagnose` → `ai/diagnosis.py`). Result lands as `issue.evidence["diagnosis"]` + an `AgentRun`, exactly as the button does.
- `trigger_propose` — kicks `propose-remediation` (`ai/remediation.py`); each draft funnels through `changes.create_proposal` with `proposed_by="ai:..."` so SoD never auto-satisfies and tier/policy are unchanged.
- `trigger_analyse` — the new per-issue analyse (ISE-94).
- Each returns a **compact confirmation** the agent narrates ("diagnosis started", "proposal drafted — awaiting approval"); the heavy artefacts render from the timeline (ISE-92), not from the prose.

**Hard boundary — NO `approve`, NO `execute` tool.** Approve is a human act (ADR 0017 SoD); execute is the deterministic connector step. 

**Exit test (mirrors the ISE-54 / propose-remediation boundary tests the team writes):** assert the issue-chat agent's tool allow-list contains no execute/approve/mutating capability, and that `trigger_propose` cannot bypass `create_proposal`'s tier/policy/SoD gates. Preserve the `sequential=True` wrapper (ISE-60).

Blocked by the ADR (ISE-89) and the agent it extends (ISE-91). Label: feature.