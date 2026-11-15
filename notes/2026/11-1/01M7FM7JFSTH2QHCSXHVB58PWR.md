---
id: 01M7FM7JFSTH2QHCSXHVB58PWR
created: 2026-11-15T12:52:04.217013Z
updated: 2026-11-15T20:25:30.393151Z
type: task
title: Polaris builds workflows — in the builder and in chat it drafts, changes, explains and tests a workflow from plain words, but never enables one; its rule tools give way to workflow tools
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1857
sprint: s7nqsy0
blocked_by:
- 01M7FM6K5GE4Q0KEK0RT1PVE79
comments:
- id: 01M7GE5TQ36Z6CYXCQAC6PV2YS
  author: Steve Vine
  at: 2026-11-15T20:25:30.08242Z
  text: |-
    Built and merged (PR #1852).

    What people get:
    - In chat (staging, production and the Posture Copilot address), Polaris can:
      - list a company's workflows with their last runs;
      - read one as sentences, including earlier versions;
      - explain why a piece of evidence has its status ("“Standard changes are approved” v1 set it Non-compliant: CHG-2231 isn't on Approved standard changes v7");
      - create a workflow, always saved disabled;
      - change one: a new version, which stays enabled or disabled as it was, and Polaris says which;
      - test one, saved or draft, changing nothing;
      - disable one.
    - Polaris never enables a workflow. Asked to, it says a person enables it on Automation ▸ Workflows and gives the link. Compass also refuses an enable made through Polaris, even when the person it acts for could enable it.
    - When the building blocks can't express what was asked (an email, or a trigger that doesn't exist yet), Polaris says what's missing rather than building something close. A workflow containing anything missing can't be saved.
    - In the builder, Ask Polaris takes follow-ups that redraft the canvas, lists anything the blocks can't do yet, and offers "Test it", which runs the Test on the unsaved canvas. Nothing is saved until the person saves.
    - Polaris's rule tools are retired; asking for "a rule" builds a workflow. Polaris's instructions now describe Evidence Collection and Workflows.

    Checks: CI fully green. Tests cover each tool, the refusal to enable (including Polaris acting for an admin), and Steve's standard-changes case end to end in chat.

    For Steve on staging (needs Polaris's AI provider):
    1. In the builder, Ask Polaris "fail when a standard change isn't on the approved list", send a follow-up, then press Test it.
    2. In chat, have Polaris create it (it should come back disabled), test it, and ask it to enable it (it should refuse and link). Once you've enabled it, ask why the check is Non-compliant.
    3. Ask for something it can't do (an email) and for "a rule".
assignee: steve
label:
- feature
priority: medium
task_status: review
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