---
id: 01M658JWXTPCESW8D54G1ZTC1E
created: 2026-10-30T02:00:26.298656Z
updated: 2026-10-30T17:40:13.662061Z
type: task
title: A client's page counts its reviews but doesn't list them — and after a merge the trail still runs through the merged-away client
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1459
sprint: s2v7d6y
comments:
- id: 01M66YBJY73Q3E76XT1WP8W8E1
  author: Steve Vine
  at: 2026-10-30T17:40:09.799434Z
  text: |-
    Done — PR #1482 merged.

    - A client's page now has a **Reviews** card. It lists every review of the client, signed or not: CR-n · title, the kind and last activity, and a status dot. Each links to its review. It replaces "Contracts signed", and the signed count stays under On record.
    - After **Merge into…**, the kept client's page takes the merged one's place, so the trail reads Contracts › ACME Ltd and Back doesn't return to the client that's gone.

    To test on staging: open Contracts ▸ Clients ▸ E2E 20261030 ACME Ltd to see its reviews listed. Merge a duplicate into it, and the trail ends at ACME.
assignee: steve
label:
- bug
priority: low
task_status: review
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