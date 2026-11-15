---
id: 01M7FM7JFSTH2QHCSXHVB58PWR
created: 2026-11-15T12:52:04.217013Z
updated: 2026-11-15T12:52:27.591715Z
type: task
title: Polaris builds workflows — in the builder and in chat it drafts, changes, explains and tests a workflow from plain words, but never enables one; its rule tools give way to workflow tools
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1857
sprint: s7nqsy0
blocked_by:
- 01M7FM6K5GE4Q0KEK0RT1PVE79
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint "Automation - Workflows" (ADR in COM-1848 §7). Builds on COM-1851, COM-1853, COM-1854 and COM-1855. Retiring the rule tools lands with COM-1856.

## What people see

- **In the builder** (the Ask Polaris panel, COM-1854): "fail when a standard change isn't on the approved list" → Polaris lays out the blocks on the canvas, says in a sentence what it built and anything it assumed ("I matched on the *template* field against the list's *reference* column"), and offers to test it. Follow-ups change the canvas ("also ignore changes before 1 January"). Nothing is saved until the person saves.
- **In chat (MCP, staging and production servers)**: Polaris can list a company's workflows and their last runs, read one as sentences, explain why a piece of evidence got its status ("Workflow X v3 set it Non-compliant: CHG-2231 isn't on the list"), draft a new workflow (saved **disabled**), change one (a new version, which stays enabled or disabled as it was, and it says so), and test one.
- **It never enables a workflow.** Asked to, it says a person enables it on Automation ▸ Workflows and links there. It can disable one when asked, because stopping is safe; that's my call, for Steve to overturn.
- **When the building blocks can't express the ask** (e.g. a trigger that doesn't exist yet), it says what's missing in plain words rather than building something close, so the gap is visible (the lesson from this session).
- **Rule tools go**: proposing and approving rules through Polaris retires with COM-1856. Asking for "a rule" is understood as a workflow.
- The Copilot area servers (ADR 0144) get the workflow tools under the posture area, within its tool limit.

## Notes for the builder

- Tools name workflows by name and checks by CHK ID, never internal identifiers.
- Update the MCP server instructions (both servers) to describe Evidence Collection and Workflows in place of rules.
- Polaris costs show only in Admin (COM-1627).

## Done when

- From the builder and from chat, Polaris can build Steve's standard-changes workflow from one sentence, test it, and explain a result. It refuses to enable, and says something can't be expressed when it can't.
- Rule tools are gone after the switch-over, and the server instructions are updated.
- Tests for each tool, including the refusal to enable.

**On the chain** (MCP tools + API).