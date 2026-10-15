---
id: 01M4RXRA4PMAD8HZ0N71H8P6HT
created: 2026-10-12T20:44:34.326062Z
updated: 2026-10-15T11:27:53.654073Z
type: task
title: A server says what it is known to run — SQL Server, Hyper-V, Exchange, a domain controller — from what it has registered in the directory, without anything looking at the server
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 937
sprint: surilj1
blocked_by:
- 01M4RXQVB8DS4C04ATRQJSEZ21
comments:
- id: 01M4XZNBMCRBKTGMVBT7XNRG09
  author: Steve Vine
  at: 2026-10-14T19:54:06.86022Z
  text: 2026-10-14, from planning sprint "Inventory discovery - Software" (COM-959..968). What a server is known to run (SQL Server, Exchange, Hyper-V, domain controller) should also appear as software in Discovered ▸ Software (COM-960), with "Active Directory" as where it was found. It should be keyed so that SQL Server found here and SQL Server found on cloud servers (COM-964/966) share a row wherever the version is known. Without a version, it is its own row ("SQL Server, version not known").
- id: 01M4ZN32SB7XBPQ5QFHYW7KXFP
  author: Steve Vine
  at: 2026-10-15T11:27:51.082939Z
  text: |-
    Merged to main (PR #960, 2026-10-15). Not on staging until the rest of the sprint is in Review. Still my addition; it can be reverted on main on its own if you don't want it.

    What to look at:
    - A server's row carries what it is known to run ("SQL Server", "Hyper-V host", "Exchange", "Cluster node"), and its detail has "Known to run (as registered in the directory)" and, for SQL Server, "SQL Server instances" (the instance name or port each registered, e.g. "1433, REPORTS"). Where nothing registered it reads "Nothing registered".
    - A Hyper-V host's "Physical or virtual" reads "Physical".
    - Discovered tab: a "Runs" filter appears once any server is known to run something; "SQL Server" shows every SQL Server awaiting a decision.
    - Rules: with kind "Domain-joined servers", a "Known to run" choice ("Domain-joined servers running SQL Server → …").

    Things that differ from the task text:
    - Service-account SQL Server: the search covers user accounts and managed service accounts (anything with a SQL Server name that is not a computer), and asks only for the names. It matches the host in the name to a server's full DNS name or its short name.
    - As the Software sprint's comment asked, SQL Server found here should appear in Discovered ▸ Software as "SQL Server, version not known" — that view (COM-960) is not built yet, so nothing reaches software from this today.

    Needed from you to smoke-test: a known SQL Server and a known Hyper-V host in the OUs chosen on staging.

    Technical: servers.runs_of / sql_instances / service_account_sql; scope.service_account_spns searches (&(servicePrincipalName=MSSQLSvc/*)(!(objectCategory=computer))) for servicePrincipalName only. The runs fact is filtered with JSONB containment; facets count it; rules MATCH_KEYS gains runs.
assignee: steve
label:
- feature
priority: medium
task_status: review
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