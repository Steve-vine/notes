---
id: 01M7FM37RNKW81E5SQ1QDQA2MN
created: 2026-11-15T12:49:42.165246Z
updated: 2026-11-15T15:50:47.646467Z
type: task
title: 'ADR: Automation — Evidence Collection only collects evidence, every piece of evidence on a control carries its own Compliant / Non-compliant / Unchecked status, and Workflows (a trigger, conditions and actions) replace pass/fail rules'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1848
sprint: s7nqsy0
comments:
- id: 01M7FYEQA6XR8XQ0RFYNQD3Y0W
  author: Steve Vine
  at: 2026-11-15T15:50:44.293666Z
  text: |-
    Done — PR #1844 merged (ADR 0155, decisions/0155-automation-workflows.md). Written as this task says, with ADR 0142 amended (rules give way to workflows; COM-1628's "nothing found" carries into the captured-items condition) and ADR 0152 amended (ten groups: Automation after Assurance, before Admin, foot line "What Compass does for you", robot icon). IA brief: Posture loses Checks; Automation ▸ Evidence Collection and Automation ▸ Workflows rows added. CLAUDE.md's ADR list gains 0155.

    For Steve to accept or overturn: built-in Compass checks unchanged this sprint; workflows per company; conflicting verdicts → Non-compliant; Polaris may disable but never enable; where Automation sits in the menu. No changes were needed to the sprint's other tasks.
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint "Automation - Workflows". Steve's decision, 2026-11-15, while testing.

## Why

Steve asked Polaris for a rule that compares a list of standard changes against the approved standard changes in a Content document. Polaris said it couldn't, and it was right. A pass/fail rule (ADR 0142, COM-1606) can only judge what the check collected, against values typed into the rule. It can't look at anything else in Compass, which blocks automating controls about document management, vulnerabilities, assets and secrets.

The competitor comparison ("Compass comparison / Summary and priorities", items 5, 16 and 21) already pointed at configurable workflows. Steve chose to build workflows now and have them replace rules, rather than widen rules: "this feels like an inevitable route and building the groundwork for it now will pay off in the long run."

## The decision (write it as `decisions/NNNN-automation-workflows.md`)

1. **A new Automation group in the menu**, the tenth (amends ADR 0152's nine groups; needs a foot line and an icon). Posture ▸ Checks moves there and is renamed **Evidence Collection**. A **Workflows** page sits beside it.
2. **Evidence Collection only collects.** It gathers evidence through integrations on its schedule and attaches it to controls. It no longer judges. Its Review queue still approves what a check reads (a person approves the first capture, as ADR 0142).
3. **Every piece of evidence on a control has a status**: **Compliant**, **Non-compliant** or **Unchecked**. That covers collected captures *and* evidence uploaded to Assurance ▸ Evidence (Steve chose all evidence).
   - The status belongs to **that piece of evidence** and means "within its own context, this evidence shows the control working, or not".
   - **Unchecked**: no workflow judged it. A person may set it to Compliant or Non-compliant.
   - **Compliant / Non-compliant set by a workflow**: a person may override it, and must give a reason.
   - A person's choice is **never carried to the next capture**. The next capture starts again, judged by workflows or Unchecked.
   - Every change (workflow or person, with the reason) is in the evidence's history and the activity log.
   - A control's assessed status stays a person's call (unchanged from ADR 0132/0142). Evidence status informs it but doesn't set it.
4. **Workflows replace pass/fail rules.** A workflow is a **trigger**, then **conditions**, then **actions**. It is configuration Compass runs itself, never code (the spirit of ADR 0147 §9).
   - **Triggers now**: *evidence collected* (a new capture or a new upload) and *evidence status changed*.
   - **What conditions can read now**: the evidence itself (the captured items, as rules can today: every, none, at most N), plus **Content** (a published document's list, latest published version), **Vulnerabilities**, **Inventory** and **Secrets**.
   - **Actions now**: set this evidence's status, **raise a gap** on the control, **close the gap** this workflow raised.
   - **Later** (designed for, not built): triggers from other events (a vulnerability past its due date, a document review overdue, a schedule), decisions across several records, several actions in a row, notifications and ticketing (comparison items 5 and 16).
5. **Gaps come from workflow actions, not from the status itself** (Steve). One workflow can cover all evidence, e.g. *[On evidence status change] → [Control = Any] → [Status = Non-compliant] → [Raise a gap]*, with its partner *[Status = Compliant] → [Close the gap]*. A status a person sets therefore raises a gap too, if such a workflow is enabled.
6. **Enabled or disabled; tested before it acts.** A workflow can be tested against real evidence to show what each step would do, without changing anything. Only an enabled workflow acts.
7. **Who**: a new permission, *Manage workflows*, to create, change, enable and disable. **Polaris** can draft, change and test a workflow, and explain what it does, but **never enables one**. A person does (in line with ADR 0142: Polaris proposes, a person approves).
8. **Versions**: saving a change to a workflow makes a new version. Every run records the workflow version, its inputs (the evidence and, for example, the document version it compared against) and its outcome. An auditor can see why a piece of evidence was judged the way it was.
9. **Switch-over**: every approved rule becomes an enabled workflow that judges exactly as before. Each company also gets an enabled "Gaps from evidence" workflow (the pair in 5), so no gap opens or closes because of the change. Rule screens and rule tools retire.
10. **Unchanged this sprint** (my call, for Steve to overturn): Compass's own built-in checks (MFA, dormant accounts, public storage, overdue vulnerabilities) keep working as they do today and raising their own gaps. They're listed under Evidence Collection. Turning them into evidence plus workflows is a later step.
11. **Scope** (my call): a workflow belongs to one company, like checks. "Copy to another company" is later.

Supersedes the pass/fail rule parts of ADR 0142 (and its COM-1628 / COM-1817 amendments): amend 0142 to point here, never rewrite it. Amend ADR 0152 for the tenth group. Add Automation ▸ Evidence Collection and Automation ▸ Workflows to `brief/information-architecture.md`.

## Done when

- The ADR is written and accepted by Steve, with ADR 0142 and ADR 0152 amended and the IA brief updated.
- The sprint's other tasks match it (amend them if the ADR changes anything).

**Independent** (documents only).