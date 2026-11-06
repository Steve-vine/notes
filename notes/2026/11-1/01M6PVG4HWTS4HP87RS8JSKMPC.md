---
id: 01M6PVG4HWTS4HP87RS8JSKMPC
created: 2026-11-05T21:58:04.092184Z
updated: 2026-11-06T11:55:41.735905Z
type: task
title: Polaris jobs — Polaris can work in the background on a job a person starts (no chat window), within the spend limits, reading web pages and trying reads; it shows progress and returns proposals, and nothing it proposes takes effect until a person approves it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1599
sprint: s1jcke1
blocked_by:
- 01M6PVF1Q2SGPBX7ECYY802X1X
- 01M6PVFJGX9GKMR8GVDZZG7YYH
comments:
- id: 01M6Q3R48ZTFXD4PMMBPTEXE5R
  author: Steve Vine
  at: 2026-11-06T00:22:14.559294Z
  text: |-
    Done: PR #1615 merged. This one is on the chain: migration 0786.

    What's there:
    - **Polaris jobs:** a person starts one ("Ask Polaris to…") and it runs on the worker, as Compass, on the organisation's provider and model, within the same hour and day spend limits as chat.
    - **What a job can do** depends on its kind: reading a public web page, trying a read against the accounts it was given, and filling in its form. Its tools are Compass's own functions, not the MCP tools, so a job can't change anything in Compass.
    - **Outside material** (pages, API answers) reaches Polaris marked as outside material, with the instruction not to follow anything written in it.
    - **Before a job starts,** it says what it usually costs. It refuses in words when Polaris is off or paused, or when Polaris is already working on the same thing.
    - **While it runs:** a progress line on the page that started it, and **Stop**.
    - **How it ends:**
      - **proposals** that wait for a person;
      - or **Couldn't**, with why: the form never came, it ran out of steps, the provider failed, or it went quiet and has stopped unexpectedly.
    - **Spend:** recorded against the person who started it, as "<name> · Polaris job: <kind>", so it shows in Admin ▸ Polaris with chat spend.
    - **Actions:** **Polaris · Review** on the starter's queue while a finished job has proposals waiting. It clears when they're decided.
    - **Activity log:** starting a job is logged as that person; discarding a proposal is that person's act; approving is each feature's own route.
    - **Reading web pages:** https only, every address the site resolves to must be public, the connection pinned to the checked address, redirects checked by hand, 3 MB cap, scripts and styles dropped, links listed.

    My calls:
    - **The polling page, not a stream.** A job's progress is checked every two seconds while it works. The chat's live stream isn't needed for a background job.
    - **The general worker lane.** Jobs can run for minutes and mustn't hold up the Test buttons.
    - **A new "Polaris" action module,** whose module-wide audience is whoever manages Polaris.

    Tested: 4 integration tests with a fake provider (page read as data, script stripped, a failing tool passed back to Polaris as an error, spend recorded against the starter, the review action appearing and clearing, refused while off or already working, Stop, an unfilled form), and 4 Vitest.

    Couldn't check: a real job needs Polaris's AI provider key on staging.
- id: 01M6RBDW971JAD85XQBCV0NSWF
  author: Steve Vine
  at: 2026-11-06T11:55:41.735619Z
  text: |-
    Pre-UAT, against staging's real AI provider: Passed, except the spend-limit refusal, which is Couldn't check.

    Seen:
    - **Jobs ran in the background.** Eight Polaris jobs: reading SendGrid's docs, three designs, a rule, a re-check, a batch of two, and an audit look-over. Each finished in 10–40 seconds, with the provider calls in the worker log.
    - **Readings.** They read web pages and tried real reads.
    - **Proposals wait.** Each came back as proposals that took effect only when approved.
    - **Starter's actions.** The starter (E2E Admin A) got "Review" actions on Actions for the SendGrid docs job and the ACC.13 design.
    - **Cost.** It shows before each start ("Usually costs about $0.60"), and the batch preview shows the day's allowance ($49.34 left).
    - **Stop.** Ending a design on INS.2 left it "stopped".

    Couldn't check:
    - a job over the spend limit refusing to start. It would mean spending the day's allowance; the tests cover it.

    Screenshots: under COM-1600, 1601 and 1604.
assignee: steve
label:
- feature
priority: high
task_status: review
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