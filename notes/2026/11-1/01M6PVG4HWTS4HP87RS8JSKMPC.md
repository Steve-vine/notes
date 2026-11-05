---
id: 01M6PVG4HWTS4HP87RS8JSKMPC
created: 2026-11-05T21:58:04.092184Z
updated: 2026-11-05T22:03:17.971551Z
type: task
title: Polaris jobs — Polaris can work in the background on a job a person starts (no chat window), within the spend limits, reading web pages and trying reads; it shows progress and returns proposals, and nothing it proposes takes effect until a person approves it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1599
sprint: s1jcke1
blocked_by:
- 01M6PVF1Q2SGPBX7ECYY802X1X
- 01M6PVFJGX9GKMR8GVDZZG7YYH
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint "Evidence Collection - Integrations" (ADR 0142, COM-1595). Builds on COM-1596 and COM-1598. This is the engine behind the wizard and plan design (next tasks) and the batches in the following sprint. Its only screen is a job's progress and result.

## What people see

- **Starting a job.** Wherever a later task offers "Ask Polaris to…", pressing it starts a job.
  - The job says what it will do and roughly what it will cost ("about $0.40") before it starts.
  - It refuses in words if Polaris is off, has no key, or is paused by a spend limit.
- **While it runs:** a progress line on the page that started it ("Polaris is reading the SendGrid API documentation… trying a read…"). The person can leave the page and come back. **Stop** ends it.
- **When it finishes:** a result with one or more **proposals**, each marked Ready for review, or **Couldn't**, with the reason.
  - A finished job puts "Polaris · Review" on the starter's Actions.
  - The job and its proposals stay until a person approves or discards them.
- **Admin ▸ Polaris ▸ Spend** counts job spend with chat spend, labelled by job, under the same hour and day limits.
- **Activity log:** "<person>, via Polaris" for starting a job. Approving is the approver's own act.

## What Polaris can do in a job

Only what the job type allows. For this sprint:
- **read a web page** (public addresses only, text only, size-capped), for API documentation and logos;
- **try a read** through COM-1596 or COM-1598, against the accounts the job names;
- **fill in its proposal form.**

It can't change anything in Compass. It can only propose.

## Notes (technical)

- Copy the Security Feed pattern (`core/security_feed/polaris_reading.py`):
  - a Celery task;
  - gating via a `setup()` like `_plan` (enabled, missing, `spend.paused_words`, credentials, `price_of`);
  - `asyncio.run(ADAPTERS[p].call(step, …))`;
  - `spend.record(user_id=<starter>, user_name=…)`.
- Unlike the feed, a job is **multi-step**: a small loop (cap the steps, like `MAX_STEPS`) with job-local tools, ending in one form tool that has a strict schema and defensive parsing (`record_products` / `_parse`, so no JSON-schema response formats).
- No MCP and no person credential. The job's tools are Python functions, not `/api/mcp`.
- Page text and read results go into delimited blocks (`<page>`, `<read>`), with the prompt-injection note the feed uses.
- Models:
  - `polaris_jobs`: kind, starter, company, status (queued / running / done / failed / stopped), progress text, cost, heartbeat;
  - `polaris_proposals`: job, kind, payload JSONB, status (ready / approved / discarded), decided_by / at.
  - Copy pen-test proposals (`proposed_by`, `confidence`, confirm step) for the review shape.
- Progress: a polled endpoint (like `polaris_reading_progress`). The chat's Valkey stream isn't needed.
- Run on the worker (AD reads need it). New Celery task → add its TASK_LABELS entry.
- Tests use `polaris_support.fake_provider` / `FakeAdapter`, calling the job function directly, as `test_security_feed_polaris_reading.py` does.
- A new action source for "Polaris · Review" (`core/actions/`, after `actions/secrets.py`).

**Chain:** on the chain (migration and API).

**Done when:** with a fake provider in tests, a scripted job reads a page, tries a read, files a proposal and finishes, with spend recorded against its starter; a job over the spend limit refuses to start; Stop ends a running job. On staging (if Polaris has a provider key), a test job reaches Ready for review and its starter gets the action. Otherwise: Couldn't check, needs Polaris's AI provider.