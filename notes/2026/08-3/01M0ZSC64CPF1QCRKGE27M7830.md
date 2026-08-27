---
id: 01M0ZSC64CPF1QCRKGE27M7830
created: 2026-08-26T19:39:56.428121Z
updated: 2026-08-27T18:35:41.35215Z
type: task
title: Four rubric tabs become one Rubrics tab, each rubric in its own box
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 440
sprint: smnkt3k
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: todo
---
Admin spends four of its ten tabs on rubrics — Maturity, Risk, Data, Criticality. They are the same kind of thing, edited in the same way, usually looked at together when someone is deciding how the company scores things, and they crowd out the tabs that are genuinely separate jobs.

## What changes for the reader

**One Rubrics tab.** All four scales on a single page, each in its own bordered box with its name on it, one under another. You can read the maturity scale and the risk scale without changing tabs, and Admin drops from ten tabs to seven.

## Scope

Replace the four tabs on `pages/AdminPage.tsx` with a single **Rubrics** tab that stacks `MaturityRubricSection`, `RiskRubricSection`, `DataRubricSection` and `CriticalityRubricSection`, each in its own card with a heading. Keep that order — maturity is the one people come for.

Each rubric keeps its own editing and saving exactly as it works today; nothing is merged beyond the layout.

The tab sits where **Maturity rubric** sits now, so the ordering of the remaining tabs is unchanged.

`?tab=rubric`, `?tab=risk-rubric`, `?tab=data-rubric` and `?tab=criticality-rubric` are live URLs people may have bookmarked — decide whether they redirect to the new tab or simply fall back to it, and say which in the PR.

Stacks on COM-439, which reworks the same screen's layout.

## Tests

`AdminPage.test.tsx` asserts on the tab list; the four section tests should carry over untouched. Add one that the Rubrics tab renders all four sections.