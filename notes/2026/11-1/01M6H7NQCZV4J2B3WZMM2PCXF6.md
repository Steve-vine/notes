---
id: 01M6H7NQCZV4J2B3WZMM2PCXF6
created: 2026-11-03T17:35:23.551854Z
updated: 2026-11-03T17:35:23.551854Z
type: task
title: Products can be confirmed under a name the sources barely use, so they'd catch almost nothing — "SQL Server" and "Ubuntu"
priority: medium
task_status: todo
label: bug
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1547
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