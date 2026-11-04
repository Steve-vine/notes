---
id: 01M6H7NQCZV4J2B3WZMM2PCXF6
created: 2026-11-03T17:35:23.551854Z
updated: 2026-11-04T07:46:09.260474Z
type: task
title: Products can be confirmed under a name the sources barely use, so they'd catch almost nothing — "SQL Server" and "Ubuntu"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1547
sprint: s6xh9g1
comments:
- id: 01M6H94MNH2QYEQRM5BEYYN0ZA
  author: Steve Vine
  at: 2026-11-03T18:01:00.84932Z
  text: 'Another one (2026-11-03): CISA''s CSAF advisory VA-26-295-01 (and NVD''s CVE-2026-109618 row) names the product `php:php-src` (PHP''s GitHub repo name), so a watch list on PHP misses it. Fold `php-src` → `php` in naming.py as well.'
- id: 01M6HENF5K1GV9PG94GS4GQPG4
  author: Steve Vine
  at: 2026-11-03T19:37:35.155792Z
  text: |-
    Done (PR #1562, merged 2026-11-03). Not on staging yet.

    What people see now:
    - SQL Server, Exchange Server, SharePoint Server and Ubuntu are one product each, whichever way a source names them ("SQL Server 2019 for x64-based Systems (CU 27)", NVD's "ubuntu_linux" 24.04, "Ubuntu 22.04 LTS"). The release is kept with the product's versions. So Test Company's "SQL Server · 2012" and "Ubuntu · 24.04" match the items about those releases and not other releases.
    - "Ubuntu" on its own is Ubuntu Linux; PHP's repository name "php-src" (CISA's VA-26-295-01) is PHP.
    - Windows Server releases stay products of their own, as NVD and Microsoft both name them.
    - On Products each product says how many feed items name it ("Named by 2,480 items in the feed"). One with fewer than five says so in orange, with the names the sources use more: "Few items use this name (2 items). Did you mean …?", or "No item in the feed uses this name, so it will match nothing." The product picker reads "PHP · PHP — 1,234 items".
    - What's already stored — item products, product links, watch list rules — is brought into line by the deploy's name tidy, and matching runs again.

    Note: no item in the last 12 months names SQL Server 2012 at all (see COM-1548), so Test Company's SQL Server 2012 will still match little — but that's now visible rather than silent. Comparing a build like 11.0.7001 with a release is COM-1548.

    Verified: unit tests on 11 name shapes and release comparisons; an integration test with every source shape, release-only matching through "Everything we run", an old release-named link and rule re-tidied, and the item counts; screen test for the count and the warning.

    To check on staging: Test Company ▸ Security Feed ▸ Products — SQL Server and Ubuntu show item counts; Affects us picks up Ubuntu 24.04 items.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found while looking at Steve's report in Test Company, sprint 102 on staging (2026-11-03).

## What people see

Test Company's confirmed products and how many feed items use that exact name:

| Confirmed as | Items under that name | What the sources use instead |
|---|---|---|
| Microsoft · Windows Server 2019 | 2,480 | — |
| Microsoft · Windows Server 2012 R2 | 1,674 | — |
| Microsoft · SQL Server, version 2012 | **2** | per-release names: sql_server_2025 (92), _2022 (87), _2019 (84), _2017 (70), _2016 (13), plus CU names like `sql_server_2022_for_x64-based_systems_cu27` |
| Canonical · Ubuntu, version 24.04 | **1** | `ubuntu_linux` (16, NVD's name), `ubuntu_22.04_lts` (7), `ubuntu_26.04_lts` (7) … |

So once there's a watch list (COM-1546), SQL Server and Ubuntu would still match almost nothing, and nothing warns that they will.

## Fix

- Extend the one-name-per-product tidy (COM-1536, `naming.py`) so these come together under one product with the version carried as a version:
  - `sql_server_YYYY` and `sql_server_YYYY_for_x64-based_systems_cuNN` → SQL Server, version YYYY (and the CU where given)
  - `ubuntu_linux` and `ubuntu_NN.NN_lts` → Ubuntu Linux, version NN.NN
- Look for other per-release names of the same shape (Windows Server releases stay separate products, as NVD and Microsoft both name them that way).
- On Products, the picker shows how many feed items use each name, and warns when a confirmed name has (almost) none: "Few items use this name — did you mean …?"
- Re-tidy and rematch existing items once on deploy, kept out of item history (as for COM-1543).

**Done when:** Test Company's SQL Server 2012 and Ubuntu 24.04 links each match the items about those releases; the picker shows item counts; and a link to a name with no items says so.