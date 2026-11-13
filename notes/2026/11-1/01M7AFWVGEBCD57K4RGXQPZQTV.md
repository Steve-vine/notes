---
id: 01M7AFWVGEBCD57K4RGXQPZQTV
created: 2026-11-13T13:00:06.542405Z
updated: 2026-11-13T17:55:38.91282Z
type: task
title: After a Collection integration's test passes, Compass says what to do next, shows a design batch's progress wherever you look, and tells you when it's done
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1794
sprint: spsp226
assignee: steve
label:
- feature
priority: high
task_status: active
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