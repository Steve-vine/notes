---
id: 01M8FJ7TFNQFWW8YNYWRTBFJFY
created: 2026-11-27T22:32:57.077322Z
updated: 2026-11-28T07:51:39.787056Z
type: task
title: 'A new Security Feed source, Linux distributions (OSV.dev): Ubuntu, Debian, Red Hat, Rocky and Alma security data, with each distribution''s fixed package versions and Debian/RPM version rules'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2214
sprint: s51yxk5
blocked_by:
- 01M8FJ7ATFYZVSZW01YS927GWC
comments:
- id: 01M8GJ6TJPJ6A5WW3ZHG0NVS6J
  author: Steve Vine
  at: 2026-11-28T07:51:38.83794Z
  text: |-
    Built: PR #2226, merged to main (not on staging yet; it goes with the sprints' deploy).

    What's there:
    - Security Feed ▸ Sources gains "Linux distributions (OSV.dev)", with health like the others. It covers Ubuntu, Debian, Red Hat Enterprise Linux, Rocky Linux and AlmaLinux, each release separately.
    - Each distribution's advisory joins the existing item for every CVE it names. The item page gains a "Linux distributions" panel: release, package, the version that fixes it there (or "No fix yet"), a link to the advisory (USN, DSA, RHSA, RLSA, ALSA or the distribution's own CVE page), and the distribution's own rating beside the item's where they differ ("Ubuntu: Medium · overall: High").
    - Debian and RPM version rules are written from dpkg and rpm. Every one of 140 published reference cases passes, and the Debian ones are also checked against dpkg itself.
    - The agent's package lists are now kept as each server answered them, with source package, epoch and release, so packages can be looked up the way their distribution's advisories name them.

    One decision, different from the task's notes: the source doesn't copy OSV's whole exports. Ubuntu's alone is 850 MB, and nearly every record is rewritten each month, so a full read would mean hundreds of thousands of downloads a month. Instead it asks OSV about exactly what our servers run, every distinct package and version, a thousand at a time. It then reads each advisory that comes back once, and again only when it changes. The feed holds what matters to someone here and stays small. The cost: a CVE shows distribution data only once some server runs an affected package.

    Left out: Ubuntu Pro streams, Red Hat's extended-support streams, and Red Hat's bug-fix and enhancement advisories. Only RHSA security advisories are read.

    For you to look at: on staging, once the test servers report, an OpenSSL CVE's item should show Ubuntu 24.04 and Rocky 9 fixes. I'll check this in the pre-UAT pass. The task said Ubuntu 22.04, but the staging test servers run Ubuntu 24.04.
assignee: steve
label:
- feature
priority: high
task_status: review
---
**On the chain** (new tables and API). ADR 0188. After COM-2213.

## What people see
- **Security Feed ▸ Sources** gains **Linux distributions (OSV.dev)**, with its health like the others (switched on, last read, items, last error). It covers **Ubuntu, Debian, Red Hat Enterprise Linux, Rocky Linux and AlmaLinux**, each release separately (Ubuntu 22.04 and 24.04 are different).
- Its data **joins the existing item for each CVE** (one item per issue, ADR 0139 §2). The item page gains a **Linux distributions** section: per distribution and release, the package and the version that fixes it ("Ubuntu 22.04 · openssl · fixed in 3.0.2-0ubuntu1.18"), or the distribution's status where there's no fix yet ("Debian 12 · needs triage", "Ubuntu 24.04 · deferred"), with a link to the distribution's own advisory (USN, DSA, RHSA, RLSA, ALSA).
- The distribution's severity is shown beside NVD's where they differ ("Ubuntu: Medium · NVD: High").
- Nothing is matched against servers in this task (that's COM-2215).

## Notes (technical)
- Read OSV's per-ecosystem bulk exports (daily; ecosystems `Ubuntu`, `Debian`, `Red Hat`, `Rocky Linux`, `AlmaLinux`, with release in the ecosystem string, e.g. `Ubuntu:22.04:LTS`, `Debian:12`) rather than per-package queries — decide in the PR; the export is incremental-friendly via `modified`. A reader in `core/security_feed/readers/osv.py`, idempotent, Celery label in `core/task_labels.py`, Sources tile like the others.
- An OSV record may be an advisory covering several CVEs (`aliases`) or one CVE; attach its affected packages and fixed versions to **each CVE item** it names. Records with no CVE alias are kept as their own items only if ADR 0139 allows non-CVE items; otherwise skipped and counted.
- New per-item table for distribution fixes: ecosystem, release, package (source package name), fixed version (or status), advisory id, url.
- **Version comparison**: add Debian (`dpkg --compare-versions`: epoch, upstream, revision, `~`) and RPM (`rpmvercmp`: epoch:version-release, `~` and `^`) rules to `core/security_feed/versions.py`, chosen by the ecosystem — never the dotted rules. Test against the reference implementations' published cases.
- The worker reaches one more host (OSV's export bucket); list it with the others ADR 0139 names.

**Done when:** on staging, the source reads all five ecosystems with health green; a known CVE (e.g. an OpenSSL one) shows fixed versions for Ubuntu 22.04 and Rocky 9 on its item; and CI proves the dpkg and rpm comparisons against their reference cases.