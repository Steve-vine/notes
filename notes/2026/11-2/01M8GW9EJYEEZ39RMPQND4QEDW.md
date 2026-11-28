---
id: 01M8GW9EJYEEZ39RMPQND4QEDW
created: 2026-11-28T10:47:50.622895Z
updated: 2026-11-28T14:46:37.402152Z
type: task
title: 'Polaris helps with scripting: knows it exists, reads action integrations, drafts scripts and script workflows for a person to save, previews; never publishes or runs'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2237
sprint: s09wwd3
comments:
- id: 01M8H9YME9KTCK6SM2QB3N05E1
  author: Steve Vine
  at: 2026-11-28T14:46:36.233232Z
  text: |-
    Done in PR #2245 (merged). Polaris can now help with scripting. What it does:
    - Lists the action integrations: each one's kind, where it connects, its owner, its last Test and the scripts that use it. Never a password or key.
    - Drafts a script (SQL, PowerShell or Python) from a description. The draft is checked as the script editor checks it (an undeclared @name is refused), then held for a week behind a link. The link opens New script already filled in, with a note "Drafted by Polaris… nothing is saved until you do". A Script Manager reads it, changes it, saves it and publishes it.
    - Previews exactly what a script would send for given values.
    - Tries a PowerShell or Python script (Script Managers only): it shows what it would send or hand back, and sends nothing.
    - Explains a failed run: what was sent, what the system answered, and that a Script Manager can Retry it or mark it dealt with.
    - Reads the Event log ("what alerts were logged this week?").
    - Helps draft an After a joiner workflow that runs a script: it lists what the trigger hands on and what earlier steps output, so the inputs can be mapped (including lists and lookups), and knows Log Event.
    - Tests an access workflow against someone a past request was for. Nothing runs.
    What it refuses: publishing, Run now, Retry, marking a run dealt with, carrying on without a held before-script, enabling a workflow, and adding or changing an action integration. Compass itself refuses each of these when the request comes through Polaris, so it can't be talked round. Polaris says who does it, on which page.
    Checked in a test through Polaris: the list, a draft (and a refused one), opening and saving the draft, the preview, the Event log, and every refusal.
assignee: steve
label:
- feature
priority: medium
task_status: review
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