---
id: 01KYVNYNC6J0GHPF0F3XH8DZKQ
created: 2026-07-31T08:51:46.182667Z
updated: 2026-08-07T11:55:13.68075Z
type: task
title: 'EntraID actions: groups, CA policy + self-escalation guard'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 392
order: 1.0
sprint: setdxf2
blocked_by:
- 01KYVNYDJEHB3N1DW6V3N5VVGY
comments:
- id: 01KYVTG8V98BTXVW3DVN69EER6
  author: Steve Vine
  at: 2026-07-31T10:11:17.481466Z
  text: |-
    Built and pushed — PR #369 (feature/ise-392-entraid-actions-groups-ca, stacked on #368).

    Delivered: membership add/remove ($ref writes, prior-membership before-capture) + CA state toggle (report-only first-class, prior state + displayName in before), and the self-escalation guard exactly as designed: deny set = entra_group_roles ∪ new entra_protected_group_ids setting, read live from settings at execution time; transitiveMemberOf closure check; fails closed; refusals are failed changes on the audit trail before any Graph mutation. Both membership ids are protected-target surfaces.

    Tests: 14 new — the whole guard matrix (direct hit, transitive hit, operator widening, fail-closed, empty-set self-closure, user actions bypass) plus round-trips and schema refusals. ruff + mypy strict green.
assignee: steve
priority: medium
task_status: done
---
`add_group_member`/`remove_group_member` (POST/DELETE /groups/{id}/members/$ref; before = membership-presence check) and `set_ca_policy_state` (PATCH state enum enabled|disabled|enabledForReportingButNotEnforced; description steers approvers to report-only-first when enabling; before = prior state + displayName). **Self-escalation guard** (ISE's RBAC derives from Entra groups, ADR 0015; the loop ADR 0060 §4/0061 §4 refused): structural, in-connector, not operator-configurable — in `_execute` before dispatch, refuse group actions whose group_id ∈ frozenset(settings.entra_group_roles) ∪ new optional settings.entra_protected_group_ids, as ActionResult(failed) with explicit message; PLUS transitive-closure check (GET /groups/{id}/transitiveMemberOf must not intersect the deny set — token group claims are transitive, a child group escalates); fail closed if the check errors. Never auto-seed protected_targets (ISE-54 lesson) — it stays the operator-curated layer (break-glass exclusion CA policy, VIP users). No role-lookup guard on privileged users in v1: Graph's own walls (role-assignable groups need RoleManagement.ReadWrite.Directory — never granted; sensitive-action protection) do that job, and revoke/disable on a compromised admin is the flagship use. Tests: guard both paths (roles-derived + env-derived), transitive hit, empty mapping, fail-closed on check error, non-group actions unaffected, check_target_allowed with lowercase GUID deny entries, report-only round-trip.