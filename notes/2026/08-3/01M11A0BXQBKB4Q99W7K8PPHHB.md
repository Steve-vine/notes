---
id: 01M11A0BXQBKB4Q99W7K8PPHHB
created: 2026-08-27T09:49:49.367983Z
updated: 2026-08-27T09:49:49.367983Z
type: task
title: A superseded framework version reads as superseded everywhere, not just on its header
task_status: active
company: moneypenny
label: bug
priority: high
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 459
---
Found smoke-testing sprint 42. ADR 0058 gave a framework a version chain, and the detail page header shows a "Superseded" badge — but nothing else in the product knows. Three symptoms, one cause.

**The versions tab lies on the superseded version.** Open CIS v8 and it says "This is the only version of CIS Controls Compass holds. Its 153 requirements have no earlier version to compare against." There is another version. `_predecessor()` looks only backwards — the row whose `superseded_by` points at me — so from v8.1 it finds v8, and from v8 it finds nothing. The panel then treats "no predecessor" as "only version", which conflates the two ends of the chain.

**The list does not distinguish them.** CIS v8 and v8.1 both appear, both reading Active, identical rows. Same for Cyber Essentials 3.2 and 3.3. Nothing says which one you would actually be assessed against, and the framework count includes both.

**Delete is offered where it cannot work.** Every row has a delete button, but `DELETE /frameworks/{slug}` returns 409 "Framework still has requirements — disable it instead of deleting" for anything with requirements, which is every real framework. The affordance can only produce an error.

## What to change

- `_predecessor` gains a successor counterpart, and the versions panel handles all four states: no chain at all, has a predecessor, is superseded, or both (a middle link).
- `FrameworkOut` carries the successor's slug and version so the list and the panel can name it — "Superseded by v8.1" rather than a bare badge.
- The list hides superseded versions by default behind a toggle, the same shape as "Show disabled". **Assumption made:** hiding by default is what Steve wanted when he asked whether he could delete them; it is a one-line flip if the opposite reads better.
- The delete action is hidden where the API would refuse it, so the only visible path is the one that works.

## Not in scope

The two superseded rows stay. 184 `carried_from` links point at them — every v8 safeguard and every Willow question — with `ondelete="SET NULL"`, so deleting would silently blank the provenance that carry-forward and the version diff depend on.
