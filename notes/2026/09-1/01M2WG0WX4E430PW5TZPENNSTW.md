---
id: 01M2WG0WX4E430PW5TZPENNSTW
created: 2026-09-19T09:30:09.700712Z
updated: 2026-09-19T09:30:09.700712Z
type: task
title: The key that decrypts production's stored credentials cannot be lost by accident
task_status: todo
priority: medium
assignee: steve
label: chore
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 721
---
`SESSION_SECRET_KEY` in AWS Secrets Manager `production-uk-compass-creds` is the only copy of the key that decrypts everything an administrator has entered into production Compass: the M365, Entra and SSO client secrets and the SendGrid transport (all configured 2026-09-19). Lose or change it and every one of them silently reads "not configured" and must be re-entered. The same secret holds `DB_PASSWORD`, which the database and the app both read.

Today nothing stops someone tidying up, rotating, or recreating that secret.

**Do**
- A second copy of the key somewhere that is not the same AWS account (the team password manager), recorded with what it is for.
- A resource policy on the secret denying `secretsmanager:DeleteSecret` and `PutSecretValue` to everything except a named break-glass principal — or at minimum the 30-day recovery window confirmed, and a tag/description on the secret saying "do not rotate: see devops.application.compass readme".
- One paragraph in the devops repo readme: what the key protects, where the second copy lives, and that rotating it is a planned event (re-enter every integration credential afterwards), not housekeeping.

**Acceptance**: the key exists in two places; an accidental delete or overwrite of the secret is refused or recoverable; the readme says so.