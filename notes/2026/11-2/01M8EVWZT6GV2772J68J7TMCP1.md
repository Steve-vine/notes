---
id: 01M8EVWZT6GV2772J68J7TMCP1
created: 2026-11-27T16:02:33.414673Z
updated: 2026-11-28T00:23:59.813951Z
type: task
title: 'Running a script: Run now (for real, after confirming), a time limit, outputs read back, and every run recorded with its inputs, outputs and error'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2196
sprint: snt3b17
blocked_by:
- 01M8EVWB720QQ5GJX27MZQHCJD
comments:
- id: 01M8FGPNHRKBA9R761WR1HAWVS
  author: Steve Vine
  at: 2026-11-27T22:06:06.392199Z
  text: |-
    Built: PR #2202, merged to main (not on staging yet; it goes with the sprint deploy).

    What's there:
    - **Run now** on a published script (Script Managers only). You fill in its inputs (hidden ones masked as you type) and confirm that this really changes the other system. It runs on the worker, and the result appears in the script's **Runs** tab.
    - **Each script has a time limit**: 2 minutes unless changed, at most 15. A run that goes over is stopped, and SQL Server undoes it, because the script runs as one transaction.
    - **Outputs** are read from the result's first row by name. If a declared output is missing, the run fails and says which.
    - **Every run is recorded**: when it ran, which version, who or what started it (Run now, a workflow, a retry), who it was for, the values it was given (hidden ones never recorded), what it handed back, and how it ended. If it failed, the run also shows the system's own message. The runs can be downloaded as a CSV.
    - **A failed run raises an Action** for the script's owner, "Script · Retry". **Retry** runs the same version again with the same values (re-entering any hidden ones), and **Mark as dealt with** closes it with a note.
    - Proven against a real SQL Server 2022: a success with outputs read back, a script error, a timeout, a retry and dismissing a failure.

    For you to look at:
    - These are calls I made in ADR 0185, to confirm or change: the 2-minute default and 15-minute maximum.
- id: 01M8FRK525H8MGHHR4KP758WAB
  author: Steve Vine
  at: 2026-11-28T00:23:59.813709Z
  text: |-
    Pre-UAT, staging 20261127-2345, as E2E Admin B: **Passed.**

    1. Run now on Create CRM user, after the confirmation "This runs version 1 against E2E test CRM database for real. There's no undo. Run it?" → Succeeded, "Handed back: CrmUserId: 1000". The row is in the test database exactly as given.
    2. The same sign-in name again → Failed: "SQL Server refused the script, so nothing it did was kept", then the database's own message ("That sign-in name is already in the CRM"). Retry and "Mark as dealt with" are offered. The owner's Actions show "Script failed: Create CRM user…" with Retry, linking to the run.
    3. A second script with a 5-second limit and a hidden input, waiting 10 seconds → Timed out: "It ran past its time limit of 5 seconds and was stopped. SQL Server undid what it had done". The run shows "TempPassword: (hidden)", and Retry asks for it again. I marked it as dealt with, and it records who and why.

    Findings (fix-forward task to follow):
    - The confirmation is the browser's own pop-up, not Compass's dialog.
    - The SQL driver logs every connection step on the worker.
    - Once, a run showed Running for about 30 seconds after it had finished (the server records it as done in 0.1 s). I couldn't reproduce it, and it was most likely the test browser slowing the page's timers.

    Screenshots: ~/compass-uat/scripting/COM-2196/.
assignee: steve
label:
- feature
priority: high
task_status: review
---
**On the chain** (new run table and API). After COM-2195. ADR 0185.

## What people see
- **Run now** on a published script (Script Managers only): fill in the inputs. Then a confirmation: "This runs version 3 against **CRM database (sql01)** for real. There's no undo. Run it?". It shows the run as it goes and then the outcome.
- **A run** shows:
  - **Succeeded** with its outputs ("CrmUserId: 4512"), rows affected and duration; or
  - **Failed** with the reason in plain words first, then the database's own message ("Violation of UNIQUE KEY constraint 'UQ_Users_Email'…"), with nothing half-done because the script ran in one transaction; or
  - **Timed out**.
- **Time limit**: each script has one (default 2 minutes, at most 15). A run that goes over is stopped and rolled back.
- **The Runs tab** on a script lists every run: when, which version, what started it (Run now by Steve Vine, a workflow and which one, a Retry), inputs, outputs, outcome, duration. It can be filtered and exported. **Inputs and outputs are kept with the run** as evidence of what was done.
- **Sensitive inputs**: an input can be marked *Sensitive* (e.g. a temporary password). Its value is passed to the script but **never stored or shown**: the run records "(hidden)". Because nothing hidden is kept, **Retry asks for each sensitive value again**. A workflow can't fill a sensitive input from a fixed value typed into the workflow; it must come from the trigger or an earlier step.
- **Failure raises an Action** for the script's owner, "Script failed: Create CRM user, for Ada Lovelace", with **Retry**, which runs the same version with the same inputs and records it as a retry of the first. Compass never retries by itself. Scripts should be written so running them twice is harmless; the screen says so where you write one.
- **Retry of a run started by a workflow** carries on that workflow from there (COM-2198 says how).
- **If the integration is switched off or can't be reached**, the run fails saying so, with the Action. Nothing is queued to try later.
- Runs are kept like activity-log entries (no separate clean-up this sprint).

## Notes (technical)
- `ScriptRun` (script version id, trigger source: manual / workflow run + step / retry-of, inputs JSONB with sensitive inputs removed, outputs, outcome, error, rows affected, started/finished). Celery task on the execution queue, IDs only, idempotent per run id (a duplicate delivery doesn't run twice: claim the run row first). Sensitive values reach the task without being persisted: short-lived and encrypted (secretbox) in the queue message or a TTL cache key, deleted on pickup. Decide in the PR; never in a DB column.
- SQL runner: one connection per run, parameters bound by the driver, `SET XACT_ABORT ON`, explicit transaction, commit at the end, statement timeout = the script's limit, read the last result set's first row.
- New Celery task needs a TASK_LABELS entry (memory). Action source registered per ADR 0055 (actions queue memory).
- Structured logging: never log input values; the redaction list covers sensitive ones.
- Integration tests against a real SQL Server (testcontainers `mcr.microsoft.com/mssql/server`, amd64) for parameter binding, rollback on error, timeout and outputs. **Staging needs a test SQL Server** for the E2E Test Company (a small mssql container in the staging namespace, or Azure SQL Edge). Add it to the chart's staging overlay, never to production values.

**Done when:** on staging, a Script Manager runs a published script against the test database and sees its output; a script that breaks a unique key fails with the database's message and leaves no row behind; a script that sleeps past its limit times out; a sensitive input shows "(hidden)" in the run and is asked for again on Retry; and a failure puts an Action with a working Retry on the owner.