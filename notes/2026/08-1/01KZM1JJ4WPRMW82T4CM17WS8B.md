---
id: 01KZM1JJ4WPRMW82T4CM17WS8B
created: 2026-08-09T19:56:38.940788Z
updated: 2026-08-13T19:00:18.012398Z
type: task
title: Assist has no playbook tool — it cannot see playbooks at all
project: 01KX671DATY39VW6GWK3M2T3DN
number: 631
sprint: s1rgnyx
comments:
- id: 01KZPV9AWEW83SWJFH4P3E27TE
  author: Steve Vine
  at: 2026-08-10T22:04:28.430305Z
  text: |-
    Built and merged to main 2026-08-10 — `9ff85e6` (PR #586).

    Two tools on the chat surfaces, where the wrong answer was given:

    - **`find_playbooks(issue_id)`** — the playbooks that apply to an incident, in the same shape the MCP brief returns so the two surfaces cannot drift. Carries the [ISE-634] reason when nothing matches.
    - **`get_playbook_by_name(name)`** — because *"is there a playbook called X"* is literally the question that was asked and answered wrongly. A playbook can exist and not apply here; those are different answers, and `found: false` is now a fact about PLAYBOOKS rather than about the document register.

    Both prompts (assist + issue-chat) say the distinction out loud. A tool the model does not reach for is barely better than no tool — the failure was never an absent answer, it was reaching confidently for the wrong register.

    **A design correction the build forced.** I first added both tools to `DIAGNOSIS_TOOLS`, which is shared by analyse-issue and propose-remediation. Two toolset-guard tests (`test_ai_diagnose`, `test_ai_propose`) failed — and they were right. ISE-154 keeps those sets deliberately tight because a wider toolset spends the per-run tool-iteration budget, which surfaces to the operator as "Budget Exceeded". The reported fault was a chat answer; widening propose-remediation to fix it would have traded one silent failure for another. The tools are chat-surface only. Whether the single-shot agents should reach further is [ISE-643]'s question, with its own evidence.

    `MCP_READ_PARITY` gains both entries — that map exists to stop exactly this drift and it caught it in the opposite direction: MCP has had `find_playbooks` since ISE-135 while the in-app half never got it. `get_playbook_by_name` maps to None deliberately (Claude Code reaches a playbook by name through its own authoring tools).

    Tests: 5, including one asserting BOTH chat surfaces carry both tools and the parity entry exists — the drift, not just the symptom.

    Note on CI: this PR's first backend run reported a failure that was 3227 passed / 0 failed / 66 Docker read-timeouts. Pure contention — three stacked PRs each spinning up testcontainers against one Docker daemon. Re-run alone: green in 10m22s versus 20m55s.
assignee: steve
label:
- bug
priority: high
task_status: done
tech: null
---
Found 2026-08-09 trying to use `reboot_server` through a playbook. Steve asked the assistant about a playbook he had just created; it answered that no such thing existed and that it had searched "the document register".

**It was not wrong, and that is the problem.** The AI agent's entire toolset is:

```
get_state_slices, get_slice_payload, list_open_findings, get_issue_under_diagnosis,
list_system_issues, get_affected_entity_context, search_repo_knowledge,
search_documents, read_repo_file, list_evidence_sources, list_evidence_queries,
pull_evidence, list_webhook_events, get_action_catalogue
```

**There is no playbook tool.** So when asked about a playbook it reached for the only search it has — `search_documents` — correctly reported that no *document* by that name exists, and had no way to know it had looked in the wrong place. Playbooks are not documents.

This is the root cause of the whole episode. Everything else compounds it: the operator is told a thing does not exist when it does, and the answer sounds authoritative because the search genuinely ran.

**The machinery already exists.** `playbooks.match_playbooks(db, issue)` is the matcher, and the **MCP surface already exposes it** (`mcp_server/tools_read.py:412`, and `mcp_server/briefs.py` uses it for the incident brief). Claude Code can see playbooks for an incident; the in-app assistant cannot. One rule, two surfaces (ADR 0055) — and the in-app half never got it.

**Scope**
- A tool that lists the playbooks matching the issue under diagnosis, with name, kind, desk state and efficacy — the same shape the MCP brief already returns, so the two surfaces cannot drift.
- Probably a second tool to look a playbook up **by name**, because that is literally what the operator asked and the failure mode is answering "it doesn't exist" about something that does.
- The prompt needs to know playbooks are a distinct thing from documents. A tool the model does not reach for is not much better than no tool.

**Acceptance**: asking Assist "are there any playbooks for this incident" returns the matching ones; asking about a playbook by name finds it or says truthfully that no playbook of that name exists (as distinct from "no document").