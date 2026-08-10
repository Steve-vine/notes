---
id: 01KZP7YQ970B9JG1RH1Y2FZX62
created: 2026-08-10T16:26:37.735386Z
updated: 2026-08-10T16:26:37.735386Z
type: task
title: Only Diagnose can probe the estate — Analyse and Propose are blind, and nothing says so
label: improvement
assignee: steve
priority: high
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 643
---
Found 2026-08-10 reading the actual transcript of the mpwxscript incident (`342d70d6`, 2026-08-09) — the episode behind [ISE-633].

**What ran on that incident**: `analyse-issue` (18:18) → `propose-remediation` (18:21) → `issue-chat` ×2 (18:23, 18:25). **No `diagnose` run — ever.** (Only five diagnose runs exist in the whole system, the last on 2026-08-06.)

**Tool calls in the propose-remediation transcript**: `get_issue_under_diagnosis`, `get_affected_entity_context`, `get_state_slices` ×2, `get_slice_payload` ×2, `list_system_issues` ×2, `list_open_findings`, `list_webhook_events`, `search_documents`, `search_repo_knowledge`, `get_action_catalogue`. **No evidence tools.** It concluded: *"every corroborating source I queried came back empty or unresolved"* — true of what it queried, and it never asked the machine.

**It could not have.** `ai/tools.py:646` — the Evidence tools are added **only** to the diagnose agent and kept off analyse-issue and propose-remediation on purpose (ISE-154): a live evidence hunt drove those runs past their tool-iteration budget and surfaced as "Budget Exceeded". A deliberate, documented trade.

The consequence is that the two runs the operator actually triggered were structurally incapable of checking the one thing in question — and the servers connector offers exactly the query for it: `server_full_facts`, `server_service_status`, plus two more (`servers_evidence.py:36`), reaching the host over Ansible. The chats *did* have evidence tools (`CHAT_EVIDENCE_TOOLS`) and called only `search_documents` ×6, `get_issue`, `cite` — that is the [ISE-631] failure in the same session.

**The UI gives no way to know any of this.** Analyse / Diagnose / Propose sit as three sibling buttons with tooltips that describe intent, not capability: "Run an AI analysis…", "Run an AI root-cause diagnosis (lands on the timeline)", "Ask the AI to propose a fix for approval" (`IssueDetailPage.tsx:100-102`). Nothing says only the middle one can look at the live estate, and nothing suggests running it first.

**The budget reason has weakened since ISE-154.** ISE-560 (2026-08-05) made an iteration-capped run answer from the evidence it had rather than dying empty, and the per-run caps are admin-tunable (`spend_policy.ai_run_max_tool_iterations`, currently NULL → env default 12). The trade was made when overrunning meant losing the whole run.

**Scope** — settle which, not all:
- Revisit ISE-154 now that an overrun degrades gracefully: does propose-remediation get evidence, a *narrowed* evidence set (the affected entity's own source only), or a raised iteration budget?
- Failing that, make the dependency explicit: a proposal built without live evidence should say so, and Propose on an incident with no diagnosis should offer to diagnose first.
- A proposal that says "I could not corroborate" should name **what it could not reach** — evidence unavailable / no state slice / entity unresolved — rather than listing empty sources. Same principle as [ISE-634].

**Acceptance**: an operator asking for a fix on an unresponsive server gets one grounded in a live probe, or is told plainly that no live probe was available and why.