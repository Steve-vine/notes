---
id: 01M4XZHNJ2CK8FYWN0XZGCFCW5
created: 2026-10-14T19:52:05.954129Z
updated: 2026-10-17T10:36:00.139475Z
type: task
title: Software added from discovery has its support dates, publisher and type filled in from a public lifecycle catalogue, and they stay current
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 962
sprint: sbkelqe
blocked_by:
- 01M4XZGT1G67Z1HYZRG8MQ07BS
comments:
- id: 01M54PXHYRTXEYSCNFRRYD8G9W
  author: Steve Vine
  at: 2026-10-17T10:35:59.320322Z
  text: |-
    Done — merged to main (PR #1034).

    What you'll see:
    - Add to Software from Discovered ▸ Software now fills in the end of mainstream and extended support, plus publisher and type, wherever Compass knows them. You can change any before saving.
    - Discovered ▸ Software shows the dates (and where they came from) on every row, so out-of-support software stands out before anyone adds it. "Known support dates only" uses them.
    - A date nobody edited follows its source: the worker refreshes daily at 03:35 and rewrites followed dates. A typed date stands, and the published date shows beside it ("endoflife.date: 11 Jan 2033").
    - The entry says "Support dates: AWS" or "Support dates: endoflife.date".
    - It is already here fills blank dates and leaves typed ones alone. Entries typed from scratch are never touched.

    Where dates come from: the provider's own first (AWS for RDS and EKS), otherwise endoflife.date. One mapping table covers Windows Server, Ubuntu, Amazon Linux, RHEL, Debian, SLES, CentOS, Rocky, Alma, Oracle Linux, EKS/AKS/GKE, Python, Node.js, .NET, .NET Framework, Ruby, PHP, Java (Corretto), and the managed database engines. Unknown software stays blank. A snapshot of all 30 products (taken today) ships in the release, so a deployment with no route out still gets dates.

    My calls (yours to overturn):
    - Two-stage products (Windows Server, RHEL, Python): mainstream = end of active support, extended = end of life. Paid extras (Microsoft ESUs, Red Hat ELS, Ubuntu Pro ESM) are NOT counted as support — same as the on-prem Windows table did. Services with paid extended support (EKS, RDS, Azure Database) do count it, as AWS's own RDS dates already did.
    - Java maps to Amazon Corretto's lifecycle.
    - New outbound call: the worker reaches endoflife.date once a day. The chart has no egress list to update.

    Smoke test: add PostgreSQL 15 from an RDS database → AWS's dates fill in; add a Windows Server or Kubernetes row → the catalogue's dates, publisher and type fill in; type over a date → it stays after the next refresh, with the published date beside it.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Part of sprint 67, Inventory discovery - Software (ADR in COM-959). Steve: "Once added it should fill in the key fields like end of support dates."

## What people see

- **Adding software from Discovered ▸ Software fills in the form.** That means the end of mainstream support, the end of extended support, the publisher and the software type, wherever Compass knows them. The person can change any of them before saving.
- **The Discovered ▸ Software view already shows the dates on each row,** so out-of-support software stands out before anyone adds it. The "known support dates only" filter (COM-960) uses them.
- **Dates stay current.** If the publisher later extends support and nobody has edited that date, the entry follows. A date someone typed stands, and the published date shows beside it ("Microsoft: 9 Jan 2029") so the difference is visible.
- **Where the dates come from** is shown on the entry ("Support dates: endoflife.date" or "AWS"), so an auditor can see the source.
- **Software Compass doesn't know** (most line-of-business applications) is added with blank dates, as today.
- This also applies to entries matched with *It is already here*: blank dates are filled in, and typed ones are left alone.

## Notes (technical)

- **Source:** endoflife.date's API (`/api/v1/products/<product>`) for operating systems, databases, Kubernetes distributions and runtimes. The provider's own dates win where they publish them (RDS `standard_support_ends` / `extended_support_ends` already read; EKS via `eks:DescribeClusterVersions`).
- **Mapping** from a discovered key to a catalogue product and cycle (`os:windows-server:2019` → `windows-server` / `2019`) lives in one table in code, pinned by a test. Unknown keys map to nothing.
- **Refresh:** a daily, idempotent worker task fetches only the products in use. A snapshot of the mapped products ships in each release, so a deployment with no outbound route to endoflife.date still gets dates. The Celery beat crontab is wall-clock (see the g5 memory).
- **Followed vs typed:** record per date whether it was filled from the source or typed. Expect a migration (two flags or a source column) and regenerating `schema.d.ts`.
- This replaces COM-936's in-code Windows Server table, if that has landed by then. COM-889's "beside, not written into" is reversed for discovered entries, per the ADR.
- The outbound call is new for the API/worker. Note it in the chart's network-policy docs, if those list egress.

**Done when:** on staging, adding PostgreSQL 15 found in AWS fills in AWS's dates; adding a Windows Server or Kubernetes version fills in the catalogue's dates, publisher and type; and a date typed over a filled one survives the next daily refresh, with the published date shown beside it.