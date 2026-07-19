---
id: 01KXP51V7CR9VDWE6Z4T9WEV1F
created: 2026-07-16T19:04:30.700473451Z
updated: 2026-07-19T11:52:31.886600517Z
type: task
title: 'ADR: in-issue conversation surface & chat-driven remediation loop'
priority: high
assignee: steve
task_status: done
label:
- brief
project: 01KX671DATY39VW6GWK3M2T3DN
number: 89
sprint: s0v93ii
tech: null
---
The Issue Loop redesign (ISE-88) introduces a genuinely new architectural surface that **no existing ADR or brief describes**, and CLAUDE.md forbids recording a new architecture decision without an ADR. Write `docs/decisions/0024-*.md` (next free number; 0023 is the last accepted — append-only, supersede-never). This ADR is the anchor for the whole sprint; everything else is blocked on it.

**Decisions to record:**

1. **A second SSE streaming surface — the per-issue conversation.** ADR 0022 deliberately left this open: *"a second streaming surface is a decision, not a precedent."* This ADR takes that decision. The in-issue chat streams over SSE, reusing `sse.py` (`format_event`, `with_heartbeat`, `sse_response`, `StreamLimiter`/429) and the `ai/chat.py` runner pattern (event union `start`/`delta`/`tool_start`/`tool_end`/`provider_fallback`/`done`/`error`, `StreamScrubber` redaction, first-token rule, cancel-shielded persistence). Runs in the **API process, not the `ai` Celery queue** — same rationale as 0022 (the turn dies with the watching human; must not queue behind a scheduled analyse).

2. **The issue-chat agent boundary — drives the loop, never executes.** Unlike assist (ADR 0023: read-only, no action catalogue, links-only), the issue-chat agent MAY drive the **non-executing** loop steps — `analyse`, `diagnose`, `propose` — from natural-language prompts, via tools. It produces read-only results or a `ProposedChange` record; it **never approves and never executes**. Approve stays a human act (ADR 0017 separation-of-duties); execute stays the deterministic connector step in `tasks/actions/execute.py` ("no model in the loop"). The agent's tool set is structurally: read-only estate tools + `trigger_analyse`/`trigger_diagnose`/`trigger_propose`; `approve`/`execute` are absent by construction, not by prompt.

3. **Structured artefacts preserved (ADR 0013).** `diagnose`/`propose` still return validated Pydantic schemas and create `ProposedChange` rows through `changes.create_proposal` (tier/policy/SoD unchanged) — never prose parsed into a mutation. The conversational prose is a separate channel from the structured loop artefacts.

4. **The per-issue timeline is merge-on-read, not a new table.** An ordered, typed feed unifying: conversation messages, issue status transitions (from the append-only `AuditEvent`, `entity_id`-filtered), `ProposedChange`s, `AgentRun`s, and execution results. No new denormalised event table — the audit log + existing entities remain the source of truth.

5. **Relationship to ADR 0023's read-only guard.** 0023's Postgres `READ ONLY` transaction guard is scoped to *assist* tools. The issue-chat agent's loop-driver tools are non-executing but DO cause an indirect write (a `ProposedChange` row via the governed `create_proposal` path). Record explicitly why that is safe (same tier → policy → approval → deterministic-executor pipeline as the buttons) and whether the read tools here should carry the same structural read-only guard.

May split into two ADRs (surface + agent boundary; timeline model) if it runs long — decide while drafting. Label: brief.