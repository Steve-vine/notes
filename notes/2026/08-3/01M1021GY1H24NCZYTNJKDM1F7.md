---
id: 01M1021GY1H24NCZYTNJKDM1F7
created: 2026-08-26T22:11:24.225957Z
updated: 2026-08-28T01:20:20.423107Z
type: task
title: Write the obvious business roles before launch — a handful, not 1,500 mappings
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 455
sprint: snq23hz
comments:
- id: 01M12Z86E7V81P3VZS3PF227YJ
  author: Steve Vine
  at: 2026-08-28T01:20:20.422916Z
  text: |-
    Merged to main as 6ca4739 (PR #471) — `brief/access-starter-roles.md`. **Read the caveat: the roles themselves are not written yet, and could not be from here.**

    **What landed.** The instruction for the pass: which roles qualify, when it runs, what it must not do, and how anyone knows it worked.

    Three tests, all of which must hold — somebody can name the job without looking anything up; the groups are obvious from their *names*, not inferred from who is in them; two different people would write it the same way. Plus the stopping rule at around ten, framed as a ceiling rather than a target. A role that needs an argument is not obvious, and is left for the coverage tool to propose from evidence.

    **One deliberate change of method, and I want you to sanity-check it.** The task says write the roles from memory. COM-454 landed in the same sprint, so the brief instead says: deploy, let one sync run, open Access ▸ Coverage, and *accept* the handful of real clusters that pass the three tests, amending each name to the job it actually is. The reason is the sprint's own: every proposal is grounded in what people genuinely hold, so a starter role written that way cannot be wrong about the tenant — which is the failure §7 is arranged to avoid. Writing one by hand stays available for a cluster the tool won't propose (fewer than three people, or slightly different group sets); that is the exception, not the method.

    **What is still outstanding, and why.** The actual matrix entries need three things I do not have: Moneypenny's real Entra group names, your read of which jobs are obvious there, and the sprint deployed — the task's own sequencing is "after COM-447 and COM-448", meaning deployed rather than merged. I tried to read the tenant's groups from the cluster database to at least draft the list; the sandbox classifier blocked the `kubectl exec … psql` and I did not work around it. Writing ten guessed role names into the brief would have produced exactly the invented roles COM-446 argued against, so I did not.

    **So: this task is not finished in substance.** Moving it to review with the rest of the sprint because the artifact is reviewable and the sprint is deployable, but the pass itself is yours to run after staging is up — and the third done-when check (explained membership above zero) is the one that will say it worked.
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