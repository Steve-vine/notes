---
id: 01KYVNYDJEHB3N1DW6V3N5VVGY
created: 2026-07-31T08:51:38.190704Z
updated: 2026-08-07T10:57:07.269798Z
type: task
title: 'EntraID actions: user lifecycle + write foundation, ADR 0064'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 391
order: 2.0
sprint: setdxf2
blocked_by:
- 01KYVNXP4JNJZX38JKK1VZM9EF
- 01KYVNXV67JWEJ5P3SP2893CTS
comments:
- id: 01KYVTAPX3E577EDXKY24GBXV2
  author: Steve Vine
  at: 2026-07-31T10:08:15.267587Z
  text: |-
    Built and pushed — PR #368 (feature/ise-391-entraid-actions-users, stacked on #367).

    Delivered: three T3 ActionSpecs (revoke_user_sessions reversible=False with acceptance-not-effect detail; disable/enable_user with before-capture and the propagation-gap wording), lowercase-GUID schema enforcement (mixed case and UPNs refused at proposal time — the protected_targets exact-match rationale), GraphClient write verbs with the bounded 429 contract, and ADR 0064 in full (all six ops incl. ISE-392's, guard design, forbidden-permission invariant for both SPs, truthful-completion table, standing risks + AU revisit trigger).

    Tests: 9 new, all through the real act() gates incl. protected_targets enforcement and Graph-refusal containment. ruff + mypy strict green. Zero platform change — the Grant-write flow and executor were already generic.
assignee: steve
label: null
priority: medium
task_status: done
---
Write path per ADR 0060/0061 §1: second write service principal on System.write_credential_ref via existing Grant-write flow — zero platform change. Three T3 ActionSpecs (flat schemas → generic ActionsPanel, no frontend work): `revoke_user_sessions` (POST revokeSignInSessions; reversible=False, no rollback substrate — the one v1 action without one), `disable_user`/`enable_user` (PATCH accountEnabled; before = prior value read under the write credential). Targets are lowercase object-id GUIDs, schema-enforced via regex pattern (exact-string protected_targets matching must not miss on case); UPNs rejected (mutable/case-ambiguous); target_fields [user_id]. Truthful completion per ADR 0061 §5: detail names the propagation gap ("accountEnabled set; existing tokens persist until expiry unless sessions also revoked"). Errors contained into ActionResult(failed). Write **ADR 0064**: catalogue table (all six ops T3, quoting ADR 0017), target convention, self-escalation guard section, forbidden-permission invariant (RoleManagement.ReadWrite.Directory, AppRoleAssignment.ReadWrite.All, Application.ReadWrite.All, DelegatedPermissionGrant.ReadWrite.All, Directory/Group/User.ReadWrite.All — to NEITHER SP; no directory roles; no app/group ownership), truthful-completion table, security-model standing-risk entries (GroupMember.ReadWrite.All + Policy.ReadWrite.ConditionalAccess are tenant-wide; AU-scoped revisit trigger). Write-SP minimum: User.RevokeSessions.All, User.EnableDisableAccount.All + User.Read.All, GroupMember.ReadWrite.All, Policy.ReadWrite.ConditionalAccess (verify granular strings live; fallback = standing-risk entry). Tests: test_entraid_actions.py — happy paths, before-capture, error containment, write-credential plumbing.