---
id: 01KZM1JJ4WPRMW82T4CM17WS8B
created: 2026-08-09T19:56:38.940788Z
updated: 2026-08-10T20:16:38.452371Z
type: task
title: Assist has no playbook tool — it cannot see playbooks at all
project: 01KX671DATY39VW6GWK3M2T3DN
number: 631
sprint: s1rgnyx
assignee: steve
label:
- bug
priority: high
task_status: active
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