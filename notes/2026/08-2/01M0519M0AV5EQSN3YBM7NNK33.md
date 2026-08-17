---
id: 01M0519M0AV5EQSN3YBM7NNK33
created: 2026-08-16T10:18:51.27458Z
updated: 2026-08-17T11:00:53.759922Z
type: task
title: The AI still calls an incident an "issue" — because that is what its prompts call it
project: 01KX671DATY39VW6GWK3M2T3DN
number: 740
sprint: sevhjex
comments:
- id: 01M056R01CY38G7WV197TN6M8N
  author: Steve Vine
  at: 2026-08-16T11:54:05.228261Z
  text: |-
    BUILT 2026-08-16 — PR #688 (feature/ise-740-incident-vocabulary), ADR 0103.

    Both halves of the report were ISE's own doing, and the second one mattered more than the wording:

    - **The word.** `INCIDENT_VOCABULARY` now lives beside `incident_label` in `issue_labels.py` — one shared constant appended to every prose-producing agent's system prompt (assist, issue-chat, diagnose, propose-remediation, analyse-issue, execution-followup, and BOTH playbook interpreters, whose summary becomes the resolution note that closes an incident). A new agent inherits the rule instead of restating and eventually forgetting it. The prose itself was rewritten across system prompts, tool docstrings, tool parameter descriptions, output-schema field descriptions, the HTTP details that surface as UI toasts, the AI-config setting descriptions, the M365 summary card ("1 issue" → "1 signal") and the Datadog cleanup script's output.

    - **The name — this was the real fault.** `get_issue`, `list_issues`, `get_issue_under_diagnosis`, `list_system_issues` and `search_incident_history` all returned a UUID and no `IN-nnnn`. The model was not choosing the UUID; it was the only name it had. `incident` now rides in each of those payloads. The MCP surface had been re-querying for the numbers and labelling its rows itself, which is exactly why the label never reached the in-app chat — that patch-up is gone, the retrieval layer labels its own rows, and both surfaces read the same thing.

    - **One spelling.** The MCP surface built `f"IN-{number}"` — `IN-21` where the screen says `IN-0021`. Everything goes through `incident_label` now. `parse_incident_number` eats leading zeros, so an old transcript holding `IN-21` still resolves.

    **Decided on tool names, per the task's ask:** they keep the old word. `get_issue` and `trigger_diagnose` appear in evidence-pull traces and on the timeline, so they are semi-visible — but renaming breaks the MCP contract for saved Claude Code usage, and a tool name reads as a symbol rather than a sentence. Same ruling for the `issue-chat` task type and the two AI-config labels that name it: the label names the identifier, the description says "incident". Recorded as ADR 0103 — *the domain object may keep its old name; nothing a human reads may*.

    **Tests.** `tests/test_incident_vocabulary.py`: the constant reaches each prose agent; no prompt calls an incident an "issue" once identifiers are stripped (proven non-vacuous by running the regex over the OLD prompt text — three offenders); a guard that fails when a new incident-scoped agent is added without joining the list, with a sanity assertion so it cannot pass by selecting nothing. An integration test asserts both incident payloads carry the label. Three existing tests asserted the old strings and were updated.
assignee: steve
label:
- improvement
priority: medium
task_status: done
tech: null
---
Incidents were called Issues early on. The UI was renamed; the AI was not. Reported 2026-08-16, from a chat turn:

> *"the ISE **issue** record (8a0a1062-…) is still showing acknowledged… worth explicitly resolving that **issue** or waiting for the next sync"*

Note it also quoted a raw UUID where `IN-1360` was the operator-readable name — a second symptom of the same surface not having been given the vocabulary.

**Cause — it is doing what it was told.** `issue_chat.py` opens:

> *"You are ISE's **issue** assistant. An infrastructure operator is working ONE specific **issue** and is talking to you about it… The **issue** in scope is named at the top of the conversation."*

Counts of `issue` in AI-facing files: `agents.py` **99**, `issue_chat.py` **49**, `tools.py` **43**, `assist_tools.py` **43**. Some of those are code identifiers, but the system prompts and tool descriptions are prose the model reads and mirrors.

**The infrastructure for getting this right already exists and is half-used.** `issue_labels.incident_label()` produces `IN-<nnnn>`, and its docstring states the contract: *"an operator reading 'IN-1042' on screen and the AI writing 'IN-1042' in a chat turn have to be naming the same incident."* `issue_chat.py` already imports it. So the intent was there; the prompt vocabulary was never brought along.

**Scope**
- Rewrite the AI-facing prose — system prompts, tool descriptions, tool parameter descriptions, and any output the model is told to produce — to say **incident** throughout. Cover `issue_chat.py`, `agents.py`, `tools.py`, `assist_tools.py`, and the MCP surface (`mcp_server/`), whose tool descriptions are read by Claude Code too.
- Instruct the model to name an incident by its **`IN-nnnn` label**, never a raw UUID. `incident_label` is already imported where it matters; the prompt has to say to use it.
- **Do NOT rename the model, table or API paths.** `Issue`, `issue`, `/api/v1/issues`, `issue_id`, `issue-chat` are internal identifiers with no user-facing value, and renaming them means a migration touching every consumer for zero operator benefit. The rule worth writing down: *the domain object may keep its old name; nothing a human reads may.*
- Sweep the other prose surfaces for the same leak — notification bodies (Teams cards), FreshService ticket subjects/descriptions from `create_ticket`, report text and any error message that reaches a screen.
- Tool *names* (`get_issue`, `trigger_diagnose`) are a judgement call: they appear in evidence-pull traces and on the timeline, so they are semi-visible. Renaming breaks the MCP contract for anyone with saved usage, so probably leave them and let the descriptions carry the vocabulary. Decide once and note it.

**Why it matters now.** Other people are about to start testing (ISE-731). A product that calls the same object two names in two places reads as unfinished, and the AI is the surface where the inconsistency is most visible — it writes prose, so it says the wrong word in full sentences rather than tucking it in a URL.