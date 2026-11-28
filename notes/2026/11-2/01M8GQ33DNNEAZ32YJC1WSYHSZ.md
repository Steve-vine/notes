---
id: 01M8GQ33DNNEAZ32YJC1WSYHSZ
created: 2026-11-28T09:16:59.701926Z
updated: 2026-11-28T09:16:59.701926Z
type: task
title: 'PowerShell scripts: written in Automation ▸ Scripts, run in the sealed-off runner against a Web/API or Server integration, inputs as variables and outputs read back'
assignee: steve
priority: high
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2231
---
**On the chain.** After the sealed-off runner and the Web/API action integration. Where it runs (in the runner, or on a Windows server through remoting) follows the ADR.

## What people see
- **A new script's language can be PowerShell**, with PowerShell highlighting in the editor.
- **Inputs** arrive as PowerShell variables (`$SignInName`), set before the script runs, never pasted into its text. Hidden inputs are passed the same way and never stored.
- **The integration's credential** is handed to the script as a variable, never written in the script. For a Web/API integration it's the base address and an authorisation header ready to use (`Invoke-RestMethod -Uri "$BaseUrl/zones" -Headers $Auth`).
- **Outputs**: the script returns an object, and its properties are read back by the declared output names. A declared output that's missing fails the run.
- **A script fails** when it throws or writes an error ($ErrorActionPreference Stop). The run shows the message.
- **Preview** shows the script and each value it would be given, without running anything.
- Saving checks that every `$Name` the script reads is an input, the credential variable, or set by the script itself, as SQL does with @names.
- Everything else works as for SQL: draft and publish, Run now, the time limit, Retry, workflows, the run history and Actions.

**Done when:** on staging, a PowerShell script against a test Web/API integration creates a record with an input value and hands back its ID; a failing one shows its error; and Retry carries a workflow on.