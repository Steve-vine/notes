---
id: 01M0BB33CF214VMJHJ6C3JCB9V
created: 2026-08-18T21:05:29.99926Z
updated: 2026-09-01T13:55:50.433316Z
type: task
title: 'sso.md: capture the Entra setup steps that smoke testing actually required'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 269
sprint: s5thbzy
comments:
- id: 01M0BBA681SNH92HXMMBR21RMF
  author: Steve Vine
  at: 2026-08-18T21:09:22.304937Z
  text: 'Merged to main (PR #254, docs-only). `scripts/entra/sso.md` now documents the three tenant-side steps the first real sign-in actually required: explicit delegated `openid`/`profile`/`email` + **Grant admin consent** (user consent is disabled tenant-wide), **"Assignment required" = No** on the Enterprise App (Compass''s mapped-group membership is the gate; Yes throws AADSTS50105) with the defence-in-depth alternative noted, and the **break-glass conversion warning** (a first Microsoft sign-in with a matching email converts the local account to derived-only — keep a dedicated local admin off SSO). Docs only — not deployed; the running app is unaffected.'
assignee: steve
label:
- chore
priority: medium
task_status: done
---
Three gaps found while Steve set up the tenant (2026-08-18), each of which blocked sign-in until resolved:

1. **Admin consent**: the tenant disables user consent, so the registration needs explicit delegated `openid`, `profile`, `email` (Microsoft Graph → OpenId permissions) **plus "Grant admin consent"** — a bare registration has no permissions at all and the sign-in interrupts with "needs permission to access resources".
2. **"Assignment required" = No** on the Enterprise App (Properties): Compass is the gate now (mapped-group membership); leaving it Yes throws AADSTS50105 for everyone not manually assigned. Alternative (defence-in-depth): keep Yes and assign the mapped groups — but then every new mapping needs a matching app assignment.
3. **Break-glass conversion warning**: the first SSO sign-in with an email matching an existing local account converts it to Entra derived-only (password path closed). Keep a dedicated local admin that never signs in with Microsoft.