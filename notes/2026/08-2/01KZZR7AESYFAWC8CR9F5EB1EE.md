---
id: 01KZZR7AESYFAWC8CR9F5EB1EE
created: 2026-08-14T09:04:06.617711Z
updated: 2026-08-14T09:04:32.388089Z
type: task
title: Related incidents absorbs the child and children panels — one section for every merge relationship
project: 01KX671DATY39VW6GWK3M2T3DN
number: 702
sprint: sevhjex
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
tech: null
---
Three separate boxes currently answer one question — "how does this incident relate to others?" — and which you get depends on where the incident sits in a merge.

**Today** (verified against `origin/main` @ 75c57f6):

| Panel | Renders when | Card | Says |
|---|---|---|---|
| `MergePanel` (`MergePanel.tsx:123`) | there are candidates or dismissed ones | **grape** | "Looks related to N other incidents" — proposals to merge in |
| `ChildPanel` (`IssueDetailPage.tsx`) | `issue.master_id` is set (a child) | **grape** | which master it was merged into, plus detach/promote |
| `ChildrenPanel` | `child_count > 0` and children load | plain `Card withBorder` | the incidents merged into this one, each detachable or promotable |

Two of the three are already grape, so they read as almost-the-same-thing while sitting in different boxes with different headings and different empty behaviour.

**Wanted: one "Related incidents" section, whose contents depend on the incident's role.**

- **On a master (or a standalone incident):** the "Looks related to" candidate list, and below it an **"Incidents merged in"** section listing the children.
- **On a child:** the same Related incidents section, showing the **"merged into"** information — which master it belongs to and the way out.

**Scope**
- Fold `ChildPanel` and `ChildrenPanel` into `MergePanel` as sub-sections of one card. Grape, per the ISE-699 allocation.
- Adopt the ISE-699 shell: fixed title, top-right collapse, single-line collapsed state, present on every incident even when there is nothing to show.
- **Preserve the actions exactly.** Detach and promote (`useMasterChildActions`) are the only controls a child has — its lifecycle is suspended while attached (ISE-178, ADR 0035 §4), so ordinary controls are refused and detaching is the way back. Losing them in the merge would strand every child.
- **Preserve ISE-689's dismissal.** Merge-candidate dismissals are written symmetrically and served behind a "show" affordance with a Restore; that behaviour belongs to the candidate sub-section and must survive.
- A child cannot be merged anywhere without detaching first, so the candidate list stays absent (not empty-with-a-picker) in the child view — `propose_merges` already returns nothing for a child, and the section should say why rather than showing a bare empty list.

**Collapsed one-liner** needs to cover three shapes: N candidates, N merged in, or "merged into IN-xxxx". Decide the wording with ISE-699's other one-liners so they read as a set.

Depends on ISE-699 for the shell. Part of the same reshaping as ISE-700 and ISE-701.