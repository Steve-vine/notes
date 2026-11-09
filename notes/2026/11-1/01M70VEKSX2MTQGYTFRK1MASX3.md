---
id: 01M70VEKSX2MTQGYTFRK1MASX3
created: 2026-11-09T19:09:38.493847Z
updated: 2026-11-09T19:09:38.493847Z
type: task
title: Sign-in takes Copilot as it is — accepts its sign-in requests as sent, and an administrator can register Copilot by hand if it can't register itself
task_status: todo
assignee: steve
label: feature
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1652
---
**Wanted behaviour:**
- Copilot's sign-in works even though it reportedly leaves out which Compass address it is signing in for. Compass then takes it to mean the address the agent was set up with.
- If the ADR finds Copilot can register itself, nothing more is needed.
- If Copilot needs a client ID and secret entered by hand: an administrator, in Admin ▸ Connected assistants, clicks **Register an assistant**, gives it a name (e.g. "Copilot – Access Control") and pastes the return address Copilot Studio shows. Compass shows a client ID and secret **once**, to paste into Copilot Studio. The registration is listed with who made it and when it was last used. Removing it disconnects everyone signed in through it. Hand registrations are never tidied away automatically; self-registered ones that were never used still are.
- Everything else is as for Claude and ChatGPT: each person still signs in themselves and sees the Allow card, which names the registration.
- Only administrators who manage accounts can register or remove one. It is recorded in Activity.

**Done when:** a stand-in client with Copilot's quirks completes a sign-in on staging. If a hand registration is needed, it is made on screen and used by a stand-in, and removing it ends that stand-in's connection.

**Implementation:** follow what the ADR records. A hand registration needs a marker on the client so the unused-client clean-up skips it (a migration), and the admin API. Both are on the chain.

**On the chain:** migration and API change. After the area addresses.