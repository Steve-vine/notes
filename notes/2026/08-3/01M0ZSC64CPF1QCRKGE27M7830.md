---
id: 01M0ZSC64CPF1QCRKGE27M7830
created: 2026-08-26T19:39:56.428121Z
updated: 2026-09-01T13:55:51.640455Z
type: task
title: Four rubric tabs become one Rubrics tab, each rubric in its own box
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 440
sprint: smnkt3k
comments:
- id: 01M12HG68BHTZGGWXTXW3C0BCC
  author: Steve Vine
  at: 2026-08-27T21:20:02.315278Z
  text: |-
    Done — PR #459.

    Admin is seven tabs now instead of ten. All four scales sit on one page, each in its own bordered box with its name on it, maturity first — it is the one people come for. The tab sits where Maturity rubric sat, so the tabs either side of it have not moved.

    One decision worth recording: the box belongs to the rubric, not to the block. COM-439 gave each block its own card, which was right while the rubrics were four separate tabs — but the risk and data rubrics have three blocks each, so sharing one tab that would have made the page a wall of eight frames rather than four. Those cards came back off and the page composes the four sections instead, which also leaves each section as pure content rather than knowing how it is framed. That is why all four section test files pass untouched.

    Criticality lost its inner "Business criticality" heading — under a box headed "Criticality rubric" it was the heading restating the heading this sprint exists to remove. Risk and data keep their three inner headings each, because those distinguish blocks rather than repeat a title.

    Each rubric keeps its own editing, saving and history exactly as it worked. Nothing merged beyond the layout.

    On the bookmarked URLs, you asked me to decide and say which: the four retired ?tab= values are aliased to the Rubrics tab, and the URL is left exactly as it was sent. Falling back was not worth taking — an unknown ?tab= value goes to the first tab, so a link to the risk rubric would have quietly opened Users, which reads as a bug rather than as a move. Not a redirect either, because rewriting the URL breaks the old link's identity for no gain. The alias map went on useTabParam rather than into AdminPage, since a tab merging into another is not specific to Admin.

    Tests: the tab-list assertion now names all seven tabs exactly rather than spot-checking five — the old version would have passed with the old ten. New tests cover the four scales rendering in order, each rubric's heading sitting in a card that does not contain the next one (four boxes, not one and not eight), each retired ?tab= value selecting Rubrics, and on useTabParam itself that an alias resolves, the URL is not rewritten, and a value that is neither tab nor alias still falls back. 760 tests pass.

    CI note: deps-scan failed once on an npm registry ETIMEDOUT during npm ci — a network flake, nothing to do with the change. Reran that job and it passed.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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