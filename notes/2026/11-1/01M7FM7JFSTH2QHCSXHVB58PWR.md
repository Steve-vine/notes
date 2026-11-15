---
id: 01M7FM7JFSTH2QHCSXHVB58PWR
created: 2026-11-15T12:52:04.217013Z
updated: 2026-11-15T22:08:50.447538Z
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
- id: 01M7GM31RFTTW1P1MAMB2BCD17
  author: Steve Vine
  at: 2026-11-15T22:08:50.447292Z
  text: |-
    Passed (pre-UAT, 2026-11-15, build f8665615, E2E Test Company). Polaris's AI provider was working on staging, so I could check this one. Steve's exact standard-changes case can't be built in E2E (no change check, no list).

    In the builder (Ask Polaris, E2E Admin A):
    - The panel opens beside the canvas: "Say what the workflow should do… It never saves or enables it."
    - I asked "fail when a standard change isn't on the approved list". Polaris didn't build something close. It said it can't yet and why: no check collects changes (CHK-2 collects something else and is broken), and no published approved list exists. It said how to get there and asked which to start.
    - Follow-up: "set the capture Non-compliant if any repository is archived, otherwise Compliant". It redrew the canvas (unsaved), stated its assumption ("A capture with no repositories counts as Compliant, and the gap step is gone"), and offered "Test it" and "Put back what was there". "Test it" opened the Test panel for the unsaved draft, and Run test showed "All 8 repositories judged meet it · Would set Compliant".
    - I asked it to enable the workflow and to email me when it fails. It refused both: "only a person can switch a workflow on… on Automation ▸ Workflows", and "workflows can't send emails or notifications yet", offering a gap step instead. "Put back what was there" restored the saved version exactly.

    In chat (the Polaris panel):
    - It explained the ACC.3 link's status correctly: the workflow set it Compliant, the person overrode it with the quoted reason, and Gaps from evidence then did nothing.
    - It listed the company's workflows with state, version, trigger and last run.
    - Asked to enable a workflow, it refused ("Only a person can, on Automation ▸ Workflows").
    - Asked to "write a rule" for CHK-2 failing on forks, it built a workflow instead: "E2E UAT 20261115 Polaris rule", saved Disabled. It tested it ("The test changed nothing… 4 captures would be judged Non-compliant… boysenberry-repo-1 and linguist") and told me to enable it myself.

    Small points, not filed:
    - A step label "A collected check by its ID" shows in the replies as a progress line. It reads like a tool name.
    - In the builder, Polaris said "I can ask Polaris to design a check", referring to itself in the third person.

    Not checked:
    - The production MCP server and the Posture Copilot address. They need a real Copilot / production connection.
    - Building Steve's case from one sentence in chat. That needs a change check and a published list; it's worth Steve trying in Test Company once the list is published.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1857/
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