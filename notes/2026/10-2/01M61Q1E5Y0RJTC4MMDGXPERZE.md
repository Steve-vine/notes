---
id: 01M61Q1E5Y0RJTC4MMDGXPERZE
created: 2026-10-28T16:56:05.054054Z
updated: 2026-10-28T19:14:14.189834Z
type: task
title: The AWS security read no longer runs the worker out of memory — Security Hub findings are read and recorded a page at a time, so a large account's read finishes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1396
sprint: svnkdj7
comments:
- id: 01M61YYC8VF0M9VMVRNH06X50K
  author: Steve Vine
  at: 2026-10-28T19:14:13.403308Z
  text: |-
    Done — PR #1414, merged to main as 4141e938.

    Cause confirmed on staging, counting page by page inside the worker: the staging account (463040245339) holds 30,705 Security Hub findings in eu-west-2 (199 MB of JSON), 1,499 in us-east-1 and about 47 in each other region. Inspector lists 41,077 more, but Security Hub already gathers those, so they aren't read twice. The reader kept every raw page until all regions were read, and as Python objects that came to about 2.2× the JSON size, on top of the worker's ~440 MiB idle in a 1 GiB container.

    Fix: each page is turned into findings before the next is fetched, and the raw page is dropped. Repeated issues merge as they arrive, and repeated text (one CVE's description across many resources) is kept once. Google Cloud read the same way and is fixed alike. Azure already read item by item and now uses the same collector.

    Measured on a synthetic 30,000-finding listing shaped like staging's: reading went from +438 MiB to +42 MiB. Recording 30,000 findings peaks at 7 MiB, because it saves target by target. So the worker's limit stays at 1 GiB; no values-staging change.

    My call: a region that fails partway now keeps what it did read. It still closes nothing, because it isn't counted as covered.

    Tests: weak references prove each page is gone two pages later (AWS and GCP), and 5,000 findings over 50 pages are recorded end to end.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Sprint 93, Vulnerabilities - Cloud sources. Builds on COM-1383 (AWS). Found on staging, 2026-10-28, while Steve was testing sprints 90–93.

## What happened

Once the staging AWS account (463040245339) had the new policy, Steve pressed Read now:

- **16:26–16:31:** the discovery read finished in 5 minutes.
- **16:31:** the security read started (Security Hub and Inspector).
- **16:37:02:** the `worker` container hit its 1 GiB limit and Kubernetes killed it (`OOMKilled`, exit 137, restart 1). The read died with it. Nothing was recorded, so the tile still shows the 13:02 result from before the policy was fixed.

A read at 13:10 vanished the same way. That pod was replaced by the 15:00 deploy, so it can't be proven, but it fits.

So with the permissions in place, a real account's security read never finishes, and Steve sees no findings.

## Likely cause (to confirm first)

The reader collects every finding from every region into one list, as full Security Hub JSON, before recording any of them. An account with Security Hub's standards on holds thousands of control findings, each several KB of JSON, which becomes far more as Python objects. On top of that the worker's own baseline is already around 500–900 MiB.

Inspector findings (packages, layers, file paths) are bulky too.

## What should happen

- A read of an account with thousands of findings finishes within the worker's memory. Record a page or a region at a time, keeping only the fields Compass uses (title, severity, resource, CVEs, recommendation, link, status), and drop the raw JSON as each page is done.
- Measure before and after: peak memory of a read against the staging account, and how many findings it has. Add a test that reads a large fake listing (e.g. 5,000 findings over several pages) and records them all.
- Check whether Azure (Defender for Cloud sub-assessments) and Google Cloud (Security Command Center) read the same way. Fix them alike if so.
- If the worker's limit still needs raising after this, raise it in `values-staging.yaml` and the size presets (see the staging-overlay memory note). Check `kubectl top` and restarts after the deploy.

## Notes

- Celery acknowledges a task when it's received, so a task killed mid-run isn't retried; it's just gone. The companion task makes such a read visible on screen.