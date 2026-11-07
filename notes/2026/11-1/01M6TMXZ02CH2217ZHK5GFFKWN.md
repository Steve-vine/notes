---
id: 01M6TMXZ02CH2217ZHK5GFFKWN
created: 2026-11-07T09:20:14.850801Z
updated: 2026-11-07T10:22:34.276603Z
type: task
title: Polaris's cost is shown only in Admin ▸ Polaris — no "usually costs", "about $…", "day limit has $… left" or "Cost a few cents" anywhere else, on screen or in chat
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1627
sprint: s5khbev
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Raised by Steve while testing on staging (2026-11-07): "There seem to be references throughout the app to how much an action might take to perform, can you remove all of these, I only want AI cost information in the admin page."

## Where cost shows today, outside Admin

1. **Every "Ask Polaris to…" button** (`polaris/jobs/AskPolarisButton.tsx`): "Usually costs a few cents." This covers collecting a control, another check, a rule, re-checking or re-creating a check, defining an integration, explaining a failed test, and so on.
2. **Checks ▸ batch actions** (`checks/BatchBar.tsx`): the preview says "About $X. Polaris's day limit has $Y left".
3. **A Polaris job's progress** (`polaris/jobs/JobProgress.tsx`): "Asked by … Cost a few cents."
4. **Audit pack ▸ Polaris looks over the collected evidence** (`audit/AuditPackModal.tsx`): "…, about $X."
5. **Polaris in chat**: the `posture_preview_collection_batch` and `posture_start_collection_batch` tool descriptions (`assistant/tools/posture_collection.py`) tell Polaris to state the cost before starting, and the preview returns `cost_usd`.

## Done when

- None of the above shows a cost, an estimate or what's left of the limit. The buttons and previews still say what will happen ("Polaris will look at 20 controls…") and still refuse when Polaris is off or paused.
- **When a spend limit stops something**, the person is told without amounts: "Polaris has reached today's limit. An administrator can raise it in Admin ▸ Polaris." An administrator also gets the link.
- **Chat**: the collection tool descriptions no longer ask Polaris to state the cost, and the previews return no cost to the person's chat. Check every Polaris tool description for "cost" and "spend", not just these two.
- **Admin ▸ Polaris is unchanged**: spend so far, the hour and day limits with what's been spent, and each model's price. If a breakdown by job is wanted there, it is a separate task.
- **The API** stops returning the estimate and cost fields to non-admin endpoints: `/polaris/jobs/estimate`, the job's `cost_usd`, the batch preview's `cost_usd` and `day_left_usd`, and the look-over preview's `cost_usd`. Compass still works them out internally to enforce the limits. Regenerate schema.d.ts and remove `costWords` if nothing uses it.
- A test that cost wording doesn't come back: no non-admin screen renders "$" or "cost" from a Polaris job or estimate.
- On staging: Ask Polaris on a control, a Checks batch, an audit pack look-over and a chat batch preview show no cost. Admin ▸ Polaris still shows spend and limits.

## Not in scope

The vendor engagement "Estimated annual cost" and the software "Annual cost (£)" are business data, not AI cost. They stay.