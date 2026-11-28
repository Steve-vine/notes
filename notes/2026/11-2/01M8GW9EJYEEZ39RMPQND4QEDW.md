---
id: 01M8GW9EJYEEZ39RMPQND4QEDW
created: 2026-11-28T10:47:50.622895Z
updated: 2026-11-28T14:04:19.125695Z
type: task
title: 'Polaris helps with scripting: knows it exists, reads action integrations, drafts scripts and script workflows for a person to save, previews; never publishes or runs'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2237
sprint: s09wwd3
assignee: steve
label:
- feature
priority: medium
task_status: active
---
**On the chain** (new MCP tools). After the Scripting phase 2 ADR (COM-2225 §8, the decision ADR 0185 left for later). Raised by Steve on 28 Nov 2026: does the MCP have what Polaris needs to help with scripting? Today it can only read scripts and runs (COM-2199).

## What people see
**1. Polaris knows scripting exists.** Its instructions explain the rules:
- action integrations can change things;
- scripts are written by Script Managers, and only a published version runs;
- workflows can run scripts before and after joiners, movers and leavers;
- a failed before-script holds a person;
- **Polaris drafts, a person publishes and runs.**

**2. It reads action integrations:** each one's kind, what it connects to, its owner, whether its last Test connection passed, and the scripts that use it. Never a password or key.

**3. It drafts a script for a person to save.** "Write a script that adds a new starter to the CRM's Users table and returns their ID" gives a draft with its inputs, outputs, integration and SQL. It opens in the script editor for the person to read, change and save. The SQL is checked as on screen (an undeclared @name is refused). Polaris never saves over an existing script's draft without saying so, and never publishes.

**4. It previews.** It shows exactly what a script would send for given values, without connecting to anything (the Preview tab).

**5. It builds workflows that run scripts.**
- The workflow format explains Run script's input mapping: a trigger value, an earlier step's output, or a typed value, and never a typed value for a hidden input.
- Polaris can list what a trigger hands on and what earlier steps output, by label.
- It drafts on the builder's canvas as it does for evidence workflows; the person saves, and only a person enables.

**6. It tests an access workflow against a past person**, as the Test drawer does: what the trigger would hand on, the path, and "Would run …". Nothing runs.

**7. It explains a failed run:** what was sent, what the system said, and what to try. It can say Retry is the next step, but never retries, marks a run as dealt with, or carries on without it.

**Never through Polaris:** publishing, Run now, Retry, Mark as dealt with, Carry on without it, enabling a workflow, or anything touching an action integration's credentials. Those change other systems and stay with a person on screen.

**Phase 2 pieces**, as each lands: PowerShell and Python drafts (and Try it), List inputs and lookups, reading the Event log, and adding Log Event to a workflow. Each lands with its own task; this task covers SQL scripts today.

- New tools sit in the Automation area (posture_* beside the workflow tools), within the 128-tool limit (ADR 0144).

**Done when:** on staging, Polaris lists the action integrations, drafts a working SQL script from a description that a Script Manager saves and publishes, drafts an After a joiner workflow that runs it with its inputs mapped, tests it against a past person, and explains a failed run. It refuses to publish, run or retry, saying who can.