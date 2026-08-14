---
id: 01KZZKZEX38ATAVXHDVYZ7DD9D
created: 2026-08-14T07:49:54.723254Z
updated: 2026-08-14T07:58:32.500669Z
type: task
title: 'Impact panel follow-ups: an un-removable duplicate row, and a search you have to already know the answer to'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 698
sprint: sevhjex
assignee: steve
label:
- bug
priority: high
task_status: backlog
tech: null
---
Four smoke findings against ISE-691, reported from staging 2026-08-14. Two are defects in the panel; two are consequences of the label format chosen in ISE-696. One PR's worth, all in `components/ImpactPanel.tsx` plus one backend ordering change.

## 1. The first "Directly affected" row cannot be removed

**Not the API.** Verified against staging: three adds and three removes all succeeded (`issue_affected_entity_added` / `_removed` in `audit_event`, 07:20–07:31), and the table is now empty. Add and remove both work.

**Cause — stated impact is not de-duplicated against derived dependents.** The section renders `direct.map(DependentRow)` and then `stated.map(StatedRow)` with no filtering between them (`ImpactPanel.tsx:389-406`). If an operator states an entity that the graph *already* derives as a depth-1 dependent, it renders **twice**: the derived copy first, with no Remove (correctly — a derived dependent is a fact about the graph, not this endpoint's to delete), and the stated copy second, with one. Which reads exactly as "the first one cannot be removed".

- De-duplicate: an entity present in both is one row. Show it as derived (the graph knows it independently) but keep the Remove, because the operator's statement is still a thing they made and can withdraw.
- Or refuse the add when the entity is already a derived dependent, saying so — but that is worse: the operator learns nothing and the button just fails.

**Second, smaller defect in the same area.** `removing={remove.isPending}` is shared across every row (line 399), so removing one row shows a spinner on *all* of them and Mantine disables them all. Key the pending state to the row being removed.

## 2. Search cannot find the thing you searched for

Typing `cluster-envstaginguk` returns releases, cnpg secrets and so on — not `cluster-envstaginguk-ekscluster`. You have to type the full name.

**Cause, reproduced on staging.** `GET /api/v1/entities` defaults to `sort=first_seen` **descending** (`entities.py:706`) and the pickers pass only `q` and `limit: 20`. 55 entities match `cluster-envstaginguk`; the newest are the secrets (created 2026-08-04), and the cluster itself is older, so it never reaches the first 20. The picker is sorted by *when ISE first saw it*, which has nothing to do with what was typed.

- Rank by match quality for a typeahead: exact, then prefix, then contains — then whatever tiebreak. `first_seen desc` is right for the estate list and wrong for a search box.
- Either a `sort=relevance` the endpoint understands, or a dedicated typeahead ordering. Note ISE-523 already established that these pickers must not silently truncate — `truncationNote` says "showing 20 of 55", so the honesty is there; the ordering is what makes 20 the wrong 20.
- Applies to all four pickers, not just this one.

## 3. Dropdown rows wrap over two or three lines

**Self-inflicted, by ISE-696.** The label became `name (type) · in kube-system on cluster-envstaginguk-ekscluster`, and the `Select` is `w={340}` — so most rows wrap. It fixed ambiguity and cost legibility.

One line per item. Widening alone will not do it; the label has to get shorter, which is what #4 does.

## 4. Read it as `Type - Integration - Entity Name`

As specified. This replaces ISE-696's scope-first format, and is the right call — shorter, so it fits one line, and the integration still separates the case ISE-696 was written for (`aws-node` in six clusters).

**One consequence, checked rather than assumed:** dropping the containment scope loses the namespace, so two same-named workloads in *different namespaces of the same cluster* would read identically again. **No such case exists on staging today** (zero workload names appear more than once within one integration across namespaces), so this costs nothing now — but it is the reason ISE-471 built `scope`, and if it ever bites, the answer is to append the namespace rather than to revert the order.

Leading with the type also changes what the eye scans first, which is worth a look on a real list before it is called done: a column of `workload - env-staging-uk - …` reads as repetitive where the name was previously distinctive.
