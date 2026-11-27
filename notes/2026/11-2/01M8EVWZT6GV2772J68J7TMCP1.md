---
id: 01M8EVWZT6GV2772J68J7TMCP1
created: 2026-11-27T16:02:33.414673Z
updated: 2026-11-27T16:02:33.414673Z
type: task
title: 'Running a script: Run now (for real, after confirming), a time limit, outputs read back, and every run recorded with its inputs, outputs and error'
priority: high
task_status: todo
assignee: steve
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2196
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
- **Sensitive inputs**: an input can be marked *Sensitive* (e.g. a temporary password). Its value is passed to the script but never stored or shown: the run records "(hidden)".
- **Failure raises an Action** for the script's owner, "Script failed: Create CRM user, for Ada Lovelace", with **Retry**, which runs the same version with the same inputs and records it as a retry of the first. Compass never retries by itself. Scripts should be written so running them twice is harmless; the screen says so where you write one.
- **Retry of a run started by a workflow** carries on that workflow from there (COM-2198 says how).
- **If the integration is switched off or can't be reached**, the run fails saying so, with the Action. Nothing is queued to try later.
- Runs are kept like activity-log entries (no separate clean-up this sprint).

## Notes (technical)
- `ScriptRun` (script version id, trigger source: manual / workflow run + step / retry-of, inputs JSONB with sensitive inputs removed, outputs, outcome, error, rows affected, started/finished). Celery task on the execution queue, IDs only, idempotent per run id (a duplicate delivery doesn't run twice: claim the run row first).
- SQL runner: one connection per run, parameters bound by the driver, `SET XACT_ABORT ON`, explicit transaction, commit at the end, statement timeout = the script's limit, read the last result set's first row.
- New Celery task needs a TASK_LABELS entry (memory). Action source registered per ADR 0055 (actions queue memory).
- Structured logging: never log input values; the redaction list covers sensitive ones.
- Integration tests against a real SQL Server (testcontainers `mcr.microsoft.com/mssql/server`, amd64) for parameter binding, rollback on error, timeout and outputs. **Staging needs a test SQL Server** for the E2E Test Company (a small mssql container in the staging namespace, or Azure SQL Edge). Add it to the chart's staging overlay, never to production values.

**Done when:** on staging, a Script Manager runs a published script against the test database and sees its output; a script that breaks a unique key fails with the database's message and leaves no row behind; a script that sleeps past its limit times out; a sensitive input shows "(hidden)" in the run; and a failure puts an Action with a working Retry on the owner.