---
id: 01M0BB33CF214VMJHJ6C3JCB9V
created: 2026-08-18T21:05:29.99926Z
updated: 2026-08-18T21:05:33.838449Z
type: task
title: 'sso.md: capture the Entra setup steps that smoke testing actually required'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 269
sprint: s5thbzy
assignee: steve
label:
- chore
priority: medium
task_status: active
---
Three gaps found while Steve set up the tenant (2026-08-18), each of which blocked sign-in until resolved:

1. **Admin consent**: the tenant disables user consent, so the registration needs explicit delegated `openid`, `profile`, `email` (Microsoft Graph → OpenId permissions) **plus "Grant admin consent"** — a bare registration has no permissions at all and the sign-in interrupts with "needs permission to access resources".
2. **"Assignment required" = No** on the Enterprise App (Properties): Compass is the gate now (mapped-group membership); leaving it Yes throws AADSTS50105 for everyone not manually assigned. Alternative (defence-in-depth): keep Yes and assign the mapped groups — but then every new mapping needs a matching app assignment.
3. **Break-glass conversion warning**: the first SSO sign-in with an email matching an existing local account converts it to Entra derived-only (password path closed). Keep a dedicated local admin that never signs in with Microsoft.