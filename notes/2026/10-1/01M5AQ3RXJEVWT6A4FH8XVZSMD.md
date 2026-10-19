---
id: 01M5AQ3RXJEVWT6A4FH8XVZSMD
created: 2026-10-19T18:34:49.650294Z
updated: 2026-10-19T18:34:52.217758Z
type: task
title: Software found on a technology asset that is out of support raises a finding — any operating system, database or runtime, on any cloud or on-premises
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1127
sprint: sbkelqe
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 67 follow-up (Inventory discovery). Raised by Steve smoke-testing staging, 2026-10-19: "Out of support software isn't showing in findings." ADR 0114 §10 named this as later work: "a finding that a technology asset runs software out of support (COM-936 has one for on-premises Windows only)".

## Why

The only support-related finding today is COM-936's. It covers **Windows Server on a domain-joined server**, judged from its directory account. Nothing else that discovery finds on an asset is checked: not a cloud server's operating system, and not a database or runtime.

On staging, the asset **MPUSASQLDS** (an Azure VM) runs:
- **SQL Server 2012**, out of support since 12 July 2022;
- **Windows Server 2012 R2**, out of support since 10 October 2023.

It has no findings at all. Discovered ▸ Software and the asset's Installed software both show the dates, but the Findings tab, where an owner answers what's wrong, says nothing.

## What people see

- **Each out-of-support product on an asset is its own finding,** on the resource it was found on. For example, "MPUSASQLDS runs SQL Server 2012, which stopped being supported on 12 July 2022." Two products on one server give two findings, and each is answered on its own.
- **What counts:** everything the Software tab recognises. That means operating systems, database engines (on a server or managed, e.g. RDS MariaDB), runtimes and Kubernetes versions. It applies to AWS, Azure, Google Cloud and domain-joined servers. Unrecognised applications are not judged: Compass has no dates for them.
- **The date used is the one the Software tab shows,** whether from the cloud provider or from endoflife.date. It is the end of extended support where there is one, as in COM-936. A product whose dates aren't known raises nothing. Not knowing is never a finding.
- **A Python that comes with the server's Linux** uses the distribution's dates (COM-1085). Python 3.12 on Ubuntu 24.04 raises nothing until Ubuntu 24.04 does.
- **Paid extended support is not known to Compass.** Someone who has bought it (Windows Server 2012 R2 ESU, say) **accepts the finding** with that as the reason, which is what Accept is for. Raise a risk works as for any finding.
- **It opens and closes by itself,** like every finding:
  - It opens on the first read after the support date passes.
  - It closes when the software is upgraded or removed and the server is read again.
  - It also closes when the resource leaves the asset.
- **Domain-joined servers don't get two findings for one Windows release.** Operating systems keep COM-936's finding ("Operating system out of support"), now raised for every server on every cloud. Findings already open, including accepted ones, stay as they are. Databases, runtimes and Kubernetes get a new one, "Software out of support".
- **The Findings tab** filters by both, and the asset's Findings card and the assistant's findings list show them like any other.

## Notes (technical)

- Today `core/discovery/findings._expected` runs `checks.for_kind(resource.kind)` over `resource.facts` only. A slot is `(resource id, key)`, so there can be only one finding per key per resource.
  - Products need one finding each: put the product in the key (`software_out_of_support:<discovered_software.key>`). Map it back to the "Software out of support" label in `checks.py`'s labels and the register's key filter. Alternatively, widen the slot. Choose, and say which in the PR.
- Source: the asset's resources' `discovered_software` rows whose `kind` is not `application`. Dates come from the row's provider dates if set, else `lifecycle.catalogue_dates` (tied keys from COM-1085 included), exactly as `software_view` does. Load them once per `evaluate` call, not per resource.
- Out of support = `now.date() >= extended_support_ends`, or `standard_support_ends` where no extended date exists. Neither known → nothing.
- OS: an `os:` row raises `unsupported_os` with the existing sentence shape, generalised from "Microsoft stopped supporting" to the publisher. Retire the directory-only check so a domain-joined server isn't judged twice. Keep the key, so open and accepted findings carry on.
  - Check that a domain-joined server's `os:` row and `directory/support.release_of` agree on the date; they may differ by source. Prefer the row (what the Software tab shows) and note any difference in the PR.
- `evaluate` already runs at the end of each read and on attach/detach/status change. A date passing between reads opens the finding on the next read, which is acceptable; no scheduled job.
- Assistant: `inventory_list_findings` picks the findings up. Check its key filter accepts the new key's prefix.
- No migration is expected (key is free text). Confirm against `resource_findings`.
- Tests:
  - SQL Server 2012 and Windows Server 2012 R2 on one Azure VM give two findings;
  - Ubuntu-tied Python 3.12 gives none;
  - undated software gives none;
  - upgrading and re-reading closes a finding;
  - an accepted `unsupported_os` on a domain-joined server stays open and accepted after the change.

**Done when:** on staging, after the Azure connection is read, MPUSASQLDS shows two findings, SQL Server 2012 and Windows Server 2012 R2, on its Findings card and on Inventory ▸ Findings. bstr-staging (Ubuntu 24.04, Python 3.12) shows none.