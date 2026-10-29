---
id: 01M64CPN1BW06KQZCJKD9SJ3WZ
created: 2026-10-29T17:53:09.163208Z
updated: 2026-10-29T19:08:56.831693Z
type: task
title: 'Operators Manual: Getting started — first sign-in, adding a company, adding users'
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 15
sprint: sstqjgj
blocked_by:
- 01M64CNWM12FKRY4C9ZPVKB4XW
comments:
- id: 01M64H1E3Z4DGYZETK7A2AZ1YB
  author: Steve Vine
  at: 2026-10-29T19:08:56.831558Z
  text: |-
    Pushed to staging (dad329f): a new "Getting started" group in the docs sidebar with five pages. Each was checked against the v0.16.0 code (screens, wording, API rules):
    - Sign in: local accounts, Microsoft sign-in and what its error messages mean, forgotten passwords, signing out.
    - Find your way round: the six menu sections and what each item is for, which records are shared and which belong to one company, and the top bar.
    - See what needs doing: the Dashboard figures and panels, Actions and its filters, notifications, email preferences.
    - Add and manage companies: shared versus per-company records, switching, creating, the default company, archiving, restoring, deleting.
    - Add users and give them roles: the nine built-in roles, creating local users, editing roles, Entra group mappings, disable, reset password, delete.

    Also added scripts/screenshots.mjs, which retakes the docs screenshots from a running Compass in light and dark. package-lock.json changed, so run npm install after pulling.

    No screenshots on these pages yet. Staging is ahead of the release, so its screens don't match what a reader installs.

    Two findings from writing the pages:
    - The released app has no screen for changing your own password. A user can only choose their own through "Forgot password?", which needs email. The pages say so plainly. This may be worth a COM task.
    - The app's accent colour is violet since its redesign (ADR 0085), while the website still uses the old blue (#1772a8) taken from the app at 0.6.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
The pages a new user needs on day one: signing in (local account, or Microsoft Entra ID single sign-on if set up), finding their way round the six sections, the Dashboard and Actions, switching company, adding a company, adding users. One task per page, in the words on the app's screens, checked against the released version. This task also adds the new section to the docs sidebar.