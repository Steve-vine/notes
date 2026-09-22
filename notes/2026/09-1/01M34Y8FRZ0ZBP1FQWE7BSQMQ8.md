---
id: 01M34Y8FRZ0ZBP1FQWE7BSQMQ8
created: 2026-09-22T16:12:53.919308Z
updated: 2026-09-22T16:13:04.83953Z
type: task
title: 'Shared mailboxes: who can open each one, and who can send as it'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 742
sprint: s3nfes0
blocked_by:
- 01M34Y77T2T2XKFFJA1YRG7VN8
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Today the answer to "who has access to the sales@ mailbox" needs an admin and a command. It becomes a page.

**Mirror**, on its own hourly cadence (fewer than 100 shared mailboxes: one listing plus two permission reads per mailbox is a couple of hundred calls, cheap enough to run hourly): every shared mailbox — Entra object id, display name, primary address, created, on-prem synced flag — and its access rows: **can open** (FullAccess) and **can send as** (SendAs), each naming the grantee. Grantees are matched to the mirrored directory user by Entra object id; a group grantee is kept and shown as a group; `NT AUTHORITY\SELF`, inherited and deny entries are ignored. Send-on-behalf is deliberately not mirrored — it is on-prem-owned for synced mailboxes and we will never manage it.

Vanished handling follows the mirror rule: a mailbox that leaves the tenant is marked, never deleted; an access row that disappears is removed, because it is a current-state fact.

**Screens** (Screen conventions, `brief/information-architecture.md`): **Access Control ▸ Shared Mailboxes** — searchable list with name, address, on-prem pill, and the two counts; a detail page with two lists, *Can open* and *Can send as*, each row linking to the person or group. A user's detail page gains a *Shared mailboxes* section. Read-only in this task.

Depends on the Exchange connection. Until it is configured the list says so.