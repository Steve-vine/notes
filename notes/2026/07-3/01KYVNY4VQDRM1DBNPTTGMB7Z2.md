---
id: 01KYVNY4VQDRM1DBNPTTGMB7Z2
created: 2026-07-31T08:51:29.27108Z
updated: 2026-08-07T10:38:07.466885Z
type: task
title: EntraID evidence — on-demand identity queries
project: 01KX671DATY39VW6GWK3M2T3DN
number: 390
order: 1.125
sprint: setdxf2
blocked_by:
- 01KYVNXP4JNJZX38JKK1VZM9EF
comments:
- id: 01KYVT2D7705J0DD5C2S52CJ18
  author: Steve Vine
  at: 2026-07-31T10:03:43.207014Z
  text: |-
    Built and pushed — PR #367 (feature/ise-390-entraid-evidence, stacked on #366).

    Delivered: all seven planned queries (user_sign_ins, directory_audit_log, risk_detections, user_detail incl. MFA registration state, group_members, ca_policy_detail, app_credential_expiry with soonest-first sorting and an expired count). Unknown queries refused; Graph failures degrade to ok=False; the MFA slice inside user_detail degrades independently so a Reports.Read.All refusal costs only that slice.

    Tests: 11 new incl. assertions that the sign-in read is windowed AND user-scoped at the Graph call (never an unbounded log walk). ruff + mypy strict green.
assignee: steve
label: null
priority: medium
task_status: done
---
`evidence_catalogue()` + `fetch_evidence()` dispatch (Azure/Cloudflare pattern; errors degrade to ok=False, never raise). Seven queries: `user_sign_ins` (/auditLogs/signIns by userId, bounded window), `directory_audit_log`, `risk_detections` (the detail behind a risky-user alert), `user_detail` (rich $select incl. licences + MFA registration state via userRegistrationDetails — needs Reports.Read.All on the read SP), `group_members` (covers the no-edges decision), `ca_policy_detail`, `app_credential_expiry` (sweep /applications passwordCredentials/keyCredentials, days-to-expiry ascending — the stale-creds detection from the brief). Flat JSON Schemas. Tests: dispatch, schema validation, degrade-on-error per query.