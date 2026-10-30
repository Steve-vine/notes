---
id: 01M658JWXTPCESW8D54G1ZTC1E
created: 2026-10-30T02:00:26.298656Z
updated: 2026-10-30T17:20:57.38094Z
type: task
title: A client's page counts its reviews but doesn't list them — and after a merge the trail still runs through the merged-away client
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1459
sprint: s2v7d6y
assignee: steve
label:
- bug
priority: low
task_status: active
---
Defect in COM-1436, found by Claude's pre-UAT pass (COM-1452) on staging, 2026-10-30.

## What happens

- **Contracts ▸ Clients ▸ E2E 20261030 ACME Ltd** shows "On record · Reviews 2" as a plain number, with no list and no link. Signed contracts and Commitments do have list cards. The task says the page "lists its reviews, signed contracts and commitments".
- After merging "E2E 20261030 Acme Duplicate" into ACME, the breadcrumb reads "Contracts › E2E 20261030 Acme Du… › E2E 20261030 AC…". It still goes through the client that no longer exists.

## Expected

- A Reviews card listing each review (CR-n, title, status), linking to it.
- After a merge, the trail ends at the surviving client.

Screenshot: ~/compass-uat/sprint-98/COM-1436/09-after-merge.png (g5).

**Chain:** independent (screen only).