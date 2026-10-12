---
id: 01M4RT1ZRKSV06TFD63BAM1PHD
created: 2026-10-12T19:39:57.075468Z
updated: 2026-10-12T19:40:00.701739Z
type: task
title: Azure kinds keep their capitals in the middle of a sentence — "4 SQL databases", not "4 sql databases"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 923
sprint: svsqcj9
label:
- bug
priority: medium
task_status: active
---
Part of sprint 67, Inventory expansion. Found reviewing COM-919 and COM-920 before anything was deployed.

## What is wrong

A subscription's "what the last read found" line and its "could not be read" messages put each kind in lower case, which was right for AWS's plain names ("3 storage buckets, 1 database") and is wrong for names that carry a product's name:

- "4 sql databases, 2 postgresql servers, 1 cosmos db account, 2 aks clusters, 1 azure load balancer"
- "The role may not read sql databases — update the role from the current file"

## What people see after

- "4 SQL databases, 2 PostgreSQL servers, 1 Cosmos DB account, 2 AKS clusters, 1 Azure load balancer".
- "The role may not read SQL databases — …".
- Plain names are unchanged: "3 storage accounts", "2 virtual machines". AWS's lines are unchanged.

## Notes (technical)

- One rule in one place, on the server: `in_sentence(label)` lowers the first letter unless the name begins with a product's name.
- The per-kind line on a connection carries the two forms ready to use (`plural_phrase`, `singular_phrase`); the card uses them where present and lowers the name itself where not, so the AWS card is untouched.
- The Azure read's messages use the same function.

**Done when:** a read of a subscription with a SQL database says "1 SQL database".