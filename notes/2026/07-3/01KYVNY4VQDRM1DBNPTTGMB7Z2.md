---
id: 01KYVNY4VQDRM1DBNPTTGMB7Z2
created: 2026-07-31T08:51:29.27108Z
updated: 2026-07-31T08:51:29.27108Z
type: task
title: EntraID evidence — on-demand identity queries
label: feature
assignee: steve
task_status: backlog
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 390
---
`evidence_catalogue()` + `fetch_evidence()` dispatch (Azure/Cloudflare pattern; errors degrade to ok=False, never raise). Seven queries: `user_sign_ins` (/auditLogs/signIns by userId, bounded window), `directory_audit_log`, `risk_detections` (the detail behind a risky-user alert), `user_detail` (rich $select incl. licences + MFA registration state via userRegistrationDetails — needs Reports.Read.All on the read SP), `group_members` (covers the no-edges decision), `ca_policy_detail`, `app_credential_expiry` (sweep /applications passwordCredentials/keyCredentials, days-to-expiry ascending — the stale-creds detection from the brief). Flat JSON Schemas. Tests: dispatch, schema validation, degrade-on-error per query.