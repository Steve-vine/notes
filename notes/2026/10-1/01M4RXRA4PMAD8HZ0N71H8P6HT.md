---
id: 01M4RXRA4PMAD8HZ0N71H8P6HT
created: 2026-10-12T20:44:34.326062Z
updated: 2026-10-12T20:44:36.0634Z
type: task
title: A server says what it is known to run — SQL Server, Hyper-V, Exchange, a domain controller — from what it has registered in the directory, without anything looking at the server
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 937
sprint: surilj1
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Part of sprint 66, Inventory discovery - On-prem (ADR in COM-932). Follows the reading of servers (COM-934).

**This task is Claude's addition, not something Steve asked for, and it can be cut without affecting the rest.** The reason for it: a list of servers says little about information. Which of them hold data is what Inventory is for, and the directory already knows some of the answer, because certain software registers itself there when it starts.

## What people see

- **A server's row and page say what it is known to run:** "SQL Server", "Hyper-V host", "Exchange", "Cluster node", "Domain controller".
- **The Discovered tab can be filtered by it,** so "every server running SQL Server that nobody has placed yet" is one click.
- **A rule can use it:** "Servers running SQL Server in Servers ▸ Finance → TA-12 Finance system".
- **A Hyper-V host is physical.** For those servers "Physical or virtual" stops reading "not known".
- **It is honest about its limit.** The page says the list is what the server has registered in the directory. A server with nothing listed may still run something; Compass has not looked at it and will not.
- **Nothing reaches the Software register from this.** The directory says SQL Server is there but not which version, and a register entry without a version would be a guess. That waits for the Software sprint.

## Notes (technical)

- The reader adds `servicePrincipalName` to what it asks for, keeps only what it recognises and stores the result as a `runs` fact. The list of names itself is not stored.
- **Recognised:** `MSSQLSvc/` (SQL Server; the instance name or port after the host is kept, so two instances show as two), `Microsoft Virtual Console Service/` (Hyper-V host), `exchangeMDB/` or `exchangeRFR/` (Exchange), `MSServerClusterMgmtAPI/` (cluster node). Domain controller comes from the account itself, as the reader already knows.
- **SQL Server running as a service account registers under that account, not the computer.** So also search user accounts for `servicePrincipalName=MSSQLSvc/*` and match the host in the name to a server by its full DNS name, case-insensitively. Nothing else about those accounts is read here.
- `MATCH_KEYS` in rules gains `runs`. The Discovered tab's filter list comes from the values actually present.
- The ADR settles whether "runs SQL Server" should move a server from something that runs things to something that holds data. This task assumes it stays a fact: a resource that holds data may belong to only one technology asset, and a SQL Server commonly serves several.
- Regenerate `schema.d.ts`.

**Done when:** on staging a known SQL Server shows "SQL Server" with its instances, a known Hyper-V host shows "Hyper-V host" and reads as physical, and the filter finds both.