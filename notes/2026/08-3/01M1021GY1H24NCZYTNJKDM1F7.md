---
id: 01M1021GY1H24NCZYTNJKDM1F7
created: 2026-08-26T22:11:24.225957Z
updated: 2026-08-28T01:07:22.987661Z
type: task
title: Write the obvious business roles before launch — a handful, not 1,500 mappings
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 455
sprint: snq23hz
assignee: steve
company:
- moneypenny
label:
- chore
priority: medium
task_status: active
---
Not code. The small upfront pass that COM-446 keeps in place after rejecting the large one.

The model says unattributed is a legitimate launch state and the coverage tool drains it over time. That is right for the long tail — but a handful of clusters are obvious without any tooling, and writing them before launch means the common case is covered from day one rather than waiting for someone to accept a proposal about it.

## What to do

Write the business roles nobody needs an algorithm to spot — everyone in Finance, all Contact Centre agents, the standard starter set every new joiner gets. Map each to its groups in the matrix.

**A handful, deliberately.** Ten or so roles covering the most common jobs, not an attempt at completeness. The moment this starts feeling like the 1,500-user exercise the model rejected, stop — the rest is the coverage tool's job, done with evidence, and doing it here by hand produces exactly the guessed roles COM-446 argued against.

## When

After COM-447 and COM-448, so assignments carry provenance and are not immediately swept by a mover. Before the model is announced to anyone who will use it.

## Done when

The starter roles exist in the matrix, a new joiner can be raised against them without inventing anything, and the explained-membership number on the dashboard starts above zero.