---
id: 01M7AFWVGEBCD57K4RGXQPZQTV
created: 2026-11-13T13:00:06.542405Z
updated: 2026-11-14T10:26:49.619327Z
type: task
title: After a Collection integration's test passes, Compass says what to do next, shows a design batch's progress wherever you look, and tells you when it's done
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1794
sprint: spsp226
comments:
- id: 01M7B6Z3TWP1BW80KGRG8G65M2
  author: Steve Vine
  at: 2026-11-13T19:43:17.852284Z
  text: |-
    Built — PR #1796 (feature/com-1794-batch-progress), auto-merge set. No migration; API changes; ADR 0142 amended.

    What you'll see:
    1. Next step after a passing test: on a Collection integration's Accounts tab, once an account tests green and no check reads the service yet, a panel says "Next: collect evidence from <service>". Polaris lists the applicable controls the service can probably evidence, ticked, each with why, with a framework filter. "Design checks for these (n)" opens the same preview as the Checks batch and starts it; "Ask Polaris again" re-chooses. Once checks read the service, the panel links to them instead.
    2. Progress wherever you look: the same banner on every Checks tab and on each service page the batch reads — "Polaris is designing checks for 16 controls: 6 done · now on CHM.7 · 10 to go · started 12:33" — naming the step ("Trying reads in <service>", "Taking Compass's sample"), adding "<service> is limiting requests, so this is slower than usual." on 429s, with Stop and a link to what's proposed so far. Polaris in chat uses the same words.
    3. Review follows the batch: "From this batch: 14 so far" with the control it's on, a "Show only this batch" link, and the controls still to come listed as waiting; it refreshes as proposals arrive.
    4. The integration shows when it's busy: its page and tile say "Being read now: designing checks" (or scheduled capture, collecting now, running a feed, testing an account, taking a sample), with the time of the last request, and warn while it answers 429.
    5. The starter gets one Actions item when it ends, e.g. "Polaris finished designing checks for 16 controls: 22 checks and 2 can't-be-automated answers are waiting for your review", linking to the batch. A failed batch, or one stopped by a limit, says so ("Polaris couldn't finish … it stopped after 6 of 16 …"). A batch you stopped yourself with nothing waiting raises nothing.

    Choices:
    - The first passing test starts Polaris choosing controls on its own (a small Polaris cost, no extra click). Skipped if you can't design checks, Polaris is off, or a suggestion already exists.
    - "Being read now" and the 429 warning last 2 minutes after the last request.
    - A failed batch with nothing waiting still gets an Actions item; it clears when its starter starts another batch for that company, or after a week.
    - A design batch shows on the page of every service the company has an account on (it may read any); a re-check or re-create shows only on the services its checks read.

    For you to check with FreshService (tests can't reach it): the controls Polaris picks after a passing test look sensible; the banner moves on every Checks tab and the FreshService page; the "limiting requests" line appears on a 429.

    Checks: ruff/mypy clean, unit 2251 passed, integration (new batch-progress tests, batch, review, key headers) passed, affected vitest 127 passed, drift clean. I rebased it over COM-1792 (two import lines) and re-ran these.
- id: 01M7BJBTE2ZCWQX4XPPDDJMDTX
  author: Steve Vine
  at: 2026-11-13T23:02:28.546354Z
  text: |-
    Pre-UAT: Couldn't check most of this. What could be seen was right (staging build 2f72416b, E2E Test Company, as E2E Admin A).

    To check most of this, E2E Test Company would need an account on a Collection integration whose test passes, plus Polaris's AI to choose controls and run a design batch. It has neither: every Collection account on staging belongs to "Test Company", and adding one is out of bounds.

    What I saw:
    - Admin ▸ Integrations ▸ Nessus and ▸ Datadog, with E2E Test Company chosen: the Accounts tab says "This company has no account on … yet". As it should, there is no "Next: collect evidence from …" panel, since the company has no account that has passed a test. No errors.
    - No batch is running, and none of the integrations is busy. Checks ▸ Overview, Review and All checks, the two integration pages and the integration tiles show no progress banner and no "Being read now" line.

    Couldn't check — Steve, on Moneypenny with FreshService (or SentinelOne):
    1. After a passing test, the Accounts tab shows "Next: collect evidence from FreshService": a ticked list of sensible controls, a framework filter, and "Design checks for these (n)" opening the batch preview.
    2. While the batch runs, the same banner appears on every Checks tab and on the FreshService page. Its counts move ("6 done · now on CHM.7 · 10 to go"), it names the step, and it shows the "is limiting requests" line when FreshService returns 429s.
    3. Review shows "From this batch: n so far" and the controls still waiting.
    4. The FreshService page and tile say "Being read now: designing checks".
    5. An Actions item arrives when the batch ends (or fails, or is stopped by a limit).

    Screenshots: ~/compass-uat/spsp226/COM-1794/
assignee: steve
label:
- feature
priority: high
task_status: done
---
## What happened

On 2026-11-13 Steve set up FreshService as a Collection integration, added the account and clicked Test, which passed. Nothing told him what to do next. A design batch for 16 controls was then started (from chat). On the Checks page he could see proposals arriving on the Review tab, but nothing said that anything was still happening, how far it had got, or that FreshService was rate-limiting it (COM-1793). The only progress shown is a single spinner line with Stop (`BatchBar` → `JobProgress`) on the Overview tab, with no count. The integration page shows nothing, and nothing announces when the batch finishes.

## What people see

1. **Next step after a passed test.** On the integration's page, once an account's test passes (and on any account that has never fed a check), a panel says: "Next: collect evidence from <service>". It lists the controls this service can probably evidence, chosen by Polaris from what the integration says it reads and the company's applicable controls, each one ticked, with a framework filter (e.g. SOC 2). A button, **Design checks for these**, opens the same preview as the Checks batch (how many controls, what's left out and why, whether today's limit holds it) and starts it. If checks already read this integration, the panel links to them instead.
2. **Progress wherever you look.** While a design, revalidate or recreate batch runs, the same banner shows at the top of every Checks tab (Overview, Review, All checks) and on the integration page of each service it reads:
   - "Polaris is designing checks for 16 controls: 6 done · now on CHM.7 · 10 to go · started 12:33"
   - It names the step it's on ("trying reads in FreshService", "taking Compass's sample").
   - If the service is refusing requests for being over its limit, it says so in words: "FreshService is limiting requests, so this is slower than usual."
   - It has a **Stop** button, as today.
3. **The Review tab follows the batch.** Proposals from the running batch are grouped under it as they arrive ("from this batch: 14 so far"), and controls still to come are listed as waiting.
4. **The integration shows when it's busy.** Its page and its tile say "Being read now: designing checks" or "Being read now: scheduled capture", with the time of the last request. They also show a warning while the service is answering 429s.
5. **You're told when it finishes.** The person who started the batch gets an item in their Actions (ADR 0055), like "Polaris finished designing checks for 16 controls: 22 checks and 2 can't-be-automated answers are waiting for your review". It links to the batch on the Review tab. A batch that fails or is stopped says so the same way.

## Rules

- Same words whether the batch was started on screen or through Polaris in chat (MCP).
- Service-agnostic: no code that knows a particular integration (ADR 0147 §9).
- Polaris cost is never shown outside Admin.

## Done when

- A fresh integration with a passing test shows the next-step panel, and starting from it runs a batch.
- During a batch, the banner's counts move on every Checks tab and on the integration page, and the throttling message appears when the service returns 429s.
- The person who started the batch gets an Actions item when it ends.
- There are tests for the banner's words, the grouping by batch, and the Actions item.

**On the chain** if the batch needs new progress fields or a new Actions source (an API change).