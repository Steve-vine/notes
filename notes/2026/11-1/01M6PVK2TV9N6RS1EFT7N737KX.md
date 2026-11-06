---
id: 01M6PVK2TV9N6RS1EFT7N737KX
created: 2026-11-05T21:59:40.63597Z
updated: 2026-11-06T00:22:16.522432Z
type: task
title: 'ADR amendment: Checks become the coverage screen — every control shows how it''s covered and how it''s doing, problems are grouped by cause with one fix each, work is done in batches, and a collected check''s pass/fail rule raises gaps once a person approves it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1605
sprint: s5khbev
blocked_by:
- 01M6PVDTTX6KZBCPXSXY1XXDW3
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint "Checks - Coverage and batch work". Amend ADR 0142 (COM-1595) and ADR 0132 (Continuous control checks) with what Steve agreed on 2026-11-05.

## Why

Evidence collection only helps if it's easy to keep on top of. Steve: "Above all, it needs to be easy to use, problems need to stand out and be easy to fix, batch processing of tests; it can't be something that requires trawling through controls and tests."

## The rules

- **One word on screen: check.** Built-in checks (ADR 0132) and collected checks (ADR 0142) are both checks, on one page, **Posture ▸ Checks**. Some only collect evidence; some also judge pass or fail.
- **Every control gets two answers:**
  - **Covered:** *Fully automated*, *Partly automated* (with what still needs a person), *Manual only* (Polaris or a person said it can't be automated, and why), or *Not yet looked at*.
  - **Doing:** *Passing*, *Failing*, *Collecting* (evidence only, no pass/fail), *Held for review*, or *Broken*.
- **Problems first, grouped by cause, one fix each.** One sign-in failure that breaks 31 checks is one problem with one fix ("Re-enter the key"), not 31 lines. When nothing is wrong, the page says so in one line.
- **The full list, filtered down.** Filter every control by framework, domain, coverage, result, integration, account and problem. Clicking any total or problem filters the list to exactly those controls.
- **Batches.** Select any number of controls or checks, or "all matching". Then **Ask Polaris to design / re-validate / re-create**, **Collect now**, or **Switch off**. A Polaris batch shows its expected cost first, stays within the spend limits, and comes back as **one review queue**:
  - "still fine" items can be approved together;
  - changes are shown side by side with a sample and sensitive fields highlighted;
  - "can't be automated" answers set Manual only.
- **A collected check can carry a pass/fail rule**, drafted by Polaris in plain words ("every policy that targets All users requires MFA"; "no more than 4 admins") and approved by a person, separately from the check. Until the rule is approved, the check only collects. Once approved, it fails, raises and closes gaps exactly like a built-in check (ADR 0132 §4–§5). It never changes a control's status.
- **Problems reach people.** A Broken check, a held capture or an account that can't sign in goes on Actions: to the integration's owner for sign-in, and to the check's approver for held captures.
- **Before an audit,** anyone preparing a pack can ask Polaris to look over the period's collected evidence for the in-scope controls, on demand (Steve: on demand, not scheduled).

## My calls (for Steve to overturn)

- Coverage is per company and control, from its checks. Fully means at least one approved check says Fully. Partly means checks exist but none says Fully. Manual only means recorded as such. Not yet looked at means nothing.
- A Collection integration gets an **owner** (its creator by default), who receives its sign-in problems. Core integrations' problems go to people with Manage integrations.
- A batch is capped at **200 controls** per job, so a spend limit can't stop one halfway. Bigger selections are split, and each part shows its cost.
- Built-in checks can't be re-created by Polaris. They're code. Only Switch off and Run now apply to them.

**Chain:** independent (an ADR only).

**Done when:** the amendments are merged into `decisions/0142-…` and `decisions/0132-…`; `brief/information-architecture.md` describes the Checks page.