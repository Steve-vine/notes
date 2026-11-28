---
id: 01M8HMW4M0F14VPJ0C7JWV5EGQ
created: 2026-11-28T17:57:28.832199Z
updated: 2026-11-28T17:57:53.667122Z
type: task
title: 'A web service that echoes its request back puts the integration''s key into the run''s stored answer: Compass hides its own credential in every answer it keeps or shows'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2240
sprint: s09wwd3
assignee: steve
label:
- bug
priority: high
task_status: active
---
**Defect from the sprint 132 pre-UAT pass (COM-2227).** Independent: no migration, no API change.

## What was seen
On staging, a Python script built an API call for a Web/API action integration pointing at an echo service (httpbin.org), and Compass sent it. The service answered with the request it received, **including the `Authorization: Bearer …` header**. Compass kept that answer on the run as it came. So the integration's token could be read by anyone who can see the run, or ask Polaris about it.

Few real services echo headers, but some echo a request in error messages, and Compass shouldn't depend on that.

## What changes
- Before an answer is kept on a run (or shown by Try it, Test connection or Polaris), Compass replaces **its own credential for that integration**, wherever it appears in the answer, with "(hidden)". That covers the key or token, each part of a sign-in, and the whole Authorization value.
- The same applies to a SQL Server error message that quotes the login's password (unlikely, but the same rule).
- Answers kept before the fix aren't rewritten. Staging's only affected run is the UAT echo test, and its key is fake.

**Done when:** on staging, the echo script's run shows the echoed Authorization header as "(hidden)", and the token appears nowhere on the run, in its export or in Polaris's answer.