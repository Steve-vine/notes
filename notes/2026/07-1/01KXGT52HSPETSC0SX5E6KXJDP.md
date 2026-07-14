---
id: 01KXGT52HSPETSC0SX5E6KXJDP
created: 2026-07-14T17:17:50.009669303Z
updated: 2026-07-14T17:19:08.138523207Z
type: task
title: 'Candidate: SSO / OIDC authentication'
task_status: backlog
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 72
sprint: sevqqwb
label: null
---
**Candidate — to be scoped/decided in M17 (not yet a committed brief).**

Add federated **SSO (OIDC, possibly SAML)** alongside the existing password + reset + API-token auth, so an internal org can use its IdP (Google/Entra/Okta). Considerations: provider config, JIT user provisioning + role mapping, session integration with the existing Redis-backed sessions, fallback/local-admin path, and keeping API tokens for programmatic access. Expected for an internal tool but not blocking launch.

Decide in M17 whether to commit, and if so split into auth-backend + login-UI briefs.

---
*Migrated from Linear [DEV-501](https://linear.app/stevevine/issue/DEV-501/candidate-sso-oidc-authentication) · created 2026-06-19*