---
id: 01KZVC99FJPV1T3TK3FQPC9XNY
created: 2026-08-12T16:18:30.514801Z
updated: 2026-08-12T17:11:04.877958Z
type: task
title: A dashboard tile can roll up a Business Application
project: 01KX671DATY39VW6GWK3M2T3DN
number: 673
sprint: sdshnf8
blocked_by:
- 01KZVC8SMABF2R8C1VTQ2SMDAM
comments:
- id: 01KZVF9HXD3YWV261FCH6XZZ20
  author: Steve Vine
  at: 2026-08-12T17:11:04.877746Z
  text: |-
    Done — PR #624 merged to main as 9ed12cd. Full CI green.

    Resolution now dispatches on the source's own entity.type. A group resolves to its part-of children as before; a Business Application resolves to its members AND its derived dependencies, and both feed the unchanged rule language as ONE evaluated set.

    One refactor worth knowing about: `included_entities` became a thin wrapper over a new `blast_radius`, which returns the same two sets plus the fault counts that resolving the rules already produced (faulty_rule_count, rule_count, unbound_environment). Deriving those outside would have resolved every rule a second time — and ISE-676 now has exactly one function to memoise.

    All three traps in the brief were real and are handled:
    - retired rows: `included_entities` flags retirement rather than filtering, so the dashboard layer drops them itself. Test: a retired host reached by runs-on contributes nothing.
    - de-dup: membership wins over dependency, so a tile pointed at a Business Application AND a group holding one of its dependencies counts that entity once, as a member.
    - the group/identity-group exclusion stays by TARGET TYPE.

    The unknown reasons came out as five distinct sentences, one more than the brief listed — the unbound Environment role is its own case, because "your rules match nothing" and "ISE does not know which key means environment" send the operator to different screens.

    Counts: `dependency_count` beside `member_count`; the tile reads "18 member assets · 6 dependencies".

    UI: the Groups picker is now Sources, grouped by kind, Business Applications named by display_name. Each tile carries source badges with the kind ("Business Application · chinwag-v2.prod.uk").

    New test file `test_dashboard_sources.py` (6 tests here, 4 more added by ISE-674). The one that matters most: every member healthy, the database beneath dead, tile red — a members-only tile would have read green through exactly that.

    One CI lesson: a sed that removed an unused `# type: ignore` shortened a line below the wrap point, so the file needed reformatting and `Ruff format check` caught it. Running the exact CI command after the LAST edit, not before it.
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The sprint's first user-facing capability: an operator puts `chinwag-v2.prod.uk` on a board exactly the way they put a group there today, and the tile is red when anything it is made of **or rests on** is in trouble.

Stacks on the sources rename.

**Resolution** — `dashboards.py` `service_member_ids` dispatches on `entity.type`:
- `group` → `group_members` (`api/v1/entities.py:658-672`), unchanged
- `business-application` → `business_applications.included_entities` (`business_applications.py:828`), taking **both** returned sets, direct and inferred

Traps to handle, not discover:
- `included_entities` can return **retired** rows (it carries a `retired` flag rather than filtering). The dashboard layer must keep dropping them — a retired asset is gone from the world (ADR 0039) and must not pad a count or hold a tile red.
- The existing `OrderedDict` de-dup must stay: one entity reachable twice (two sources, or a member that is also another member's dependency) counts once. `included_entities` already excludes a member from its own dependency set.
- `included_entities` excludes `group` and `identity-group` **by target type**, which is what keeps the walk bounded — do not re-filter by edge key.
- The signal query, webhook-System exclusion and rule evaluation are unchanged. Dependencies enter as ordinary members of the evaluated set.

**Say which emptiness it is** — replace the single `"no live members resolve — check the service's groups"` (`dashboards.py:161-166`) with a reason per cause: no sources at all; a group with no live members; a Business Application whose rules all resolve to nothing (name its faulty-rule count — `faulty_rule_count` already exists on the read model); a mixed service where every source is empty. A tile that says "check the service's groups" about a Business Application sends the operator to the wrong screen.

**Counts** — `member_count` keeps meaning "what it is made of"; add `dependency_count`. The tile subtitle "18 member assets" becomes honest about the split.

**UI (this is the checklist, not the flavour text)**
- `ServiceModal` (`DashboardsPage.tsx:191-200`): the "Groups" MultiSelect becomes **"Sources"**, options grouped by kind (Mantine MultiSelect supports option groups), fed by the existing `useGroups()` plus `GET /api/v1/business-applications`. Label a Business Application by its `display_name` (`app_name.environment.region`, ADR 0097 §1) — never bare `app_name`, or two regions look like one thing.
- The API's accepted-source-type set widens to include `business-application`; the 422 keeps naming the offending type.
- `ServiceTile`: show each source with its kind, so a tile fronted by a Business Application is not mistaken for a group.
- Description text on the picker explains that a Business Application brings what it rests on with it — the colour rule is not guessable from the UI otherwise.

**Tests** — a BA-backed service whose only failing entity is an *inferred* cluster goes red; a retired dependency does not; the `unknown` reasons each come from their own cause; the picker offers Business Applications and posts their entity ids.