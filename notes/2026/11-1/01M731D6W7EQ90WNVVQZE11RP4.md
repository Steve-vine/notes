---
id: 01M731D6W7EQ90WNVVQZE11RP4
created: 2026-11-10T15:32:12.807596Z
updated: 2026-11-10T15:32:16.130673Z
type: task
title: The crosswalk import brings back a link it retired once the file claims it again — a link a person deleted stays deleted
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1681
sprint: s6acz3m
assignee: steve
label:
- bug
priority: high
task_status: active
---
**Found deploying COM-1669 to staging (2026-11-10).** Staging showed 523 SOC 2 links where the file holds 528. Five pairs (INS.4→CC1.5, INS.3→CC2.2, ACC.5→CC6.3, END.20→CC6.7, EVM.10→CC7.3) were in the original keyword crosswalk, so COM-458 retired them on staging. When COM-1669 claimed them again, the import found the retired row, updated its grading and left it retired. A clean install or production (installed after that cleanup) gets all of them. Any install that has dropped a link and later restored it does not.

**Fix.** When the file claims a pair whose row the import itself retired (soft-deleted with no actor), bring it back. A row a person deleted carries an actor and stays deleted (ADR 0028). Seed code only. **Independent.**

**Done when:** staging shows 528 SOC 2 links after deploy, and a test covers both cases (an import-retired row revives; a person-deleted row stays deleted).