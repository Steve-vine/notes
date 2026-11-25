---
id: 01M89ZW7Z1KKTX2P5RE4TB5GTV
created: 2026-11-25T18:35:51.137415Z
updated: 2026-11-25T18:35:54.934775Z
type: task
title: Access request screens name a review's removals properly, never offer to raise one, and don't tell an Access Admin they're submitting for approval
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2171
sprint: s4qjpqd
assignee: steve
label:
- bug
priority: high
task_status: active
---
Sprint "Access Control Review". Fix-forward from the pre-UAT pass on staging 2016209cf (COM-2166, COM-2167).

## What was wrong
1. A Recertification removals request's page is headed **"Recert removal"**, and its trail says "Request: recert removal".
2. **New request** offers "Recertification removals". Only Compass raises one, and the form has nothing to fill in.
3. On the Requests list, a review's removals show **"—"** under Requester.
4. An Access Admin's raise form says "This goes through as soon as you submit", but the button still reads **"Submit for approval"**.

## Done when
1. The page and the trail say "Recertification removals" (every kind uses the list's own names).
2. New request lists only the six kinds a person raises.
3. Requester reads **Compass** for a review's removals.
4. For someone holding Approve their own requests, the button reads **Submit**. Everyone else still sees "Submit for approval".
- Vitest covers each one. Checked on staging as E2E Admin A.
- **Independent** (screens only).