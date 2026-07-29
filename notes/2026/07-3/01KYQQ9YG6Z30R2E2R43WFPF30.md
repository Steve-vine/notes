---
id: 01KYQQ9YG6Z30R2E2R43WFPF30
created: 2026-07-29T19:58:26.822264Z
updated: 2026-07-29T22:02:49.699793Z
type: task
title: Azure connector foundation — add an Azure subscription to ISE
project: 01KX671DATY39VW6GWK3M2T3DN
number: 364
sprint: shjh4zz
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
New `azure` integration type, mirroring the AWS foundation (ISE-358, ADR 0058). One integration instance per **subscription**. Auth: service principal + **client secret** — `tenant_id` / `client_id` / `client_secret` / `subscription_id` in the existing credential store (static-credential pattern, as chosen for AWS). Connector skeleton with declared capabilities (ADR 0031); credential validation on add (e.g. read the subscription); instance appears on Systems with graceful degradation. ADR: Azure integration (companion to ADR 0058; number at build time, likely 0059).