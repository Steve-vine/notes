---
id: 01KXBHTFPBS03TV3ZQPNWCVBJ4
created: 2026-07-12T16:16:02.251557401Z
updated: 2026-07-23T18:32:58.941404Z
type: task
title: propose-remediation agent — drafts changes, cannot fire them
project: 01KX671DATY39VW6GWK3M2T3DN
number: 50
sprint: sdcd2jr
blocked_by:
- 01KXBHSXM6Q078HBK00GJ5SGC4
assignee: steve
label: null
priority: medium
task_status: done
---
The fourth agent task type (ai-engine brief). Add `propose-remediation` to AI_TASK_TYPES (models.py:30) + migration for the ai_model_config.task_type CHECK constraint and a seeded config row (top-tier model, per ADR 0020).

New AgentDefinition in ai/agents.py: read-only tools PLUS a get_action_catalogue tool that returns action DESCRIPTIONS AND PARAMETER SCHEMAS ONLY — never execution. The agent drafts valid parameters because it can see the schema; it has no tool that could apply them.

Output: draft ProposedChange(s) — operation, parameters, rationale, expected effect, rollback note. Persisted with proposed_by="ai:propose-remediation" and agent_run_id, entering the SAME state machine as a human proposal (so under the default-deny policy it waits for an approver like everything else).

POST /issues/{id}/propose-remediation (operator-triggered), mirroring the ISE-38 diagnose trigger.

THE BOUNDARY TEST THAT MATTERS: assert the agent's tool allow-list contains no execution capability — same shape as test_diagnosis_tools_are_read_only (ISE-38). This is the hard line from the ai-engine brief: "No agent ever executes a mutation." The model proposes; deterministic code executes (ADR 0014, ADR 0017).