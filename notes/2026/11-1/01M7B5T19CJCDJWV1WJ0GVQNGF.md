---
id: 01M7B5T19CJCDJWV1WJ0GVQNGF
created: 2026-11-13T19:23:02.828585Z
updated: 2026-11-13T19:23:26.455228Z
type: task
title: Every collected check has an ID, and Polaris knows which check is on screen when you open it from a check under review or a check's page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1805
sprint: spsp226
blocked_by:
- 01M7AKAHNNRFAAG07ZH7278E0K
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Steve, 2026-11-13. With a proposed check open on Checks ▸ Review, Polaris didn't know which check "this one" was. There's also no ID to name a check by in conversation.

## What people see

- Every collected check has an ID, **CHK-n**, shown beside its name. A proposal gets its ID when Polaris proposes it and keeps it once approved. A recreated check gets a new ID that names the one it replaces.
- The ID shows on the Review list and card, a control's Evidence tab, Checks ▸ All checks, and in search. CHK-n finds it.
- Opening Polaris while a check is on screen (a Review card, or a check expanded on a control's Evidence tab) tells Polaris which check it is. The status bar reads "Moneypenny · Posture ▸ Checks · CHK-14". "Tighten this one to the review period" then needs no ID.
- Polaris's tools find a check, or a check under review, by its ID: what it reads, its fields, its sample, and its state.

## Decisions (made, say if wrong)

- IDs are numbered per company, and are never reused.
- The built-in Compass checks (MFA, dormant accounts) keep their names. They aren't numbered.

## Done when

- Proposals and checks carry CHK-n from creation, shown in the places above, and searchable.
- The Review card and an expanded check publish the check to Polaris, as the DDQ pages do for a question. Polaris names it in the status bar and its tools resolve "this check".
- The existing Moneypenny proposals and live checks are numbered.
- There are tests.

**On the chain** (migration: the ID; API). After COM-1795.